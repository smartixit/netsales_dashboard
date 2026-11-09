import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:nativeapi/nativeapi.dart' show DisplayManager, TitleBarStyle;
import 'package:window_manager/window_manager.dart';

import '../config/window_profile.dart';
import '../config/windowing_config.dart';
import '../geometry/window_geometry_resolver.dart';
import '../models/window_operation_result.dart';
import '../routing/window_profile_router.dart';

/// Coordinates native window initialization, profile changes, and transitions.
///
/// A single ticker owns all frame-driven geometry changes. New route requests
/// interrupt the current transition and begin from the actual current bounds.
class DesktopWindowingController {
  DesktopWindowingController({
    required this.config,
    WindowGeometryResolver? geometryResolver,
  }) : _geometryResolver =
           geometryResolver ?? const WindowGeometryResolver(),
       _router = WindowProfileRouter(config.routeProfiles) {
    _ticker = Ticker(_handleAnimationFrame, debugLabel: 'DesktopWindowing');
  }

  final WindowingConfig config;
  final WindowGeometryResolver _geometryResolver;
  final WindowProfileRouter _router;

  late final Ticker _ticker;
  Window? _window;
  ListenerId? _listenerId;
  final ValueNotifier<bool> _isMaximizedNotifier = ValueNotifier<bool>(false);
  bool _initialized = false;
  bool _nativeAnimation = false;
  String? _activeProfileId;
  String? _pendingProfileId;
  Rect? _transitionStart;
  Rect? _transitionTarget;
  Rect? _lastExpectedBounds;
  Completer<WindowOperationResult>? _transitionCompleter;
  Duration _transitionDuration = Duration.zero;
  bool _disposed = false;

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS);

  bool get isInitialized => _initialized;

  String? get activeProfileId => _activeProfileId;

  Rect? get currentBounds => _window?.bounds.toRect();

  Future<WindowOperationResult> initialize() async {
    if (!isSupported) {
      return const WindowOperationResult(
        status: WindowOperationStatus.unsupportedPlatform,
      );
    }
    if (_initialized) {
      return const WindowOperationResult(
        status: WindowOperationStatus.unchanged,
      );
    }

    final window = WindowManager.instance.getCurrent();
    if (window == null) {
      return const WindowOperationResult(
        status: WindowOperationStatus.windowUnavailable,
      );
    }

    final initialProfile = config.profiles[config.initialProfileId];
    if (initialProfile == null) {
      return WindowOperationResult(
        status: WindowOperationStatus.profileNotFound,
        profileId: config.initialProfileId,
      );
    }

    _window = window;
    if (config.hideUntilReady) {
      window.hide();
    }

    _listenerId = window.addListener(_handleWindowEvent);

    final current = window.bounds.toRect();
    final workArea = _workAreaFor(current);
    final bounds = _geometryResolver.resolve(
      currentBounds: current,
      requestedSize: initialProfile.size,
      constraints: initialProfile.constraints,
      workArea: workArea,
      positionPolicy: initialProfile.positionPolicy,
    );

    _applyConstraints(initialProfile, workArea);
    _applyInitialWindowChrome(initialProfile);
    _applyProfilePresentation(initialProfile);
    window.bounds = bounds.toNative();
    _activeProfileId = initialProfile.id;
    _applyInitialPresentationState(initialProfile.initialState);

    _initialized = true;
    return WindowOperationResult(
      status: WindowOperationStatus.completed,
      profileId: initialProfile.id,
    );
  }

  Future<WindowOperationResult> show() async {
    final window = _window;
    if (!_initialized || window == null) {
      return const WindowOperationResult(
        status: WindowOperationStatus.notInitialized,
      );
    }
    window.show();
    return WindowOperationResult(
      status: WindowOperationStatus.completed,
      profileId: _activeProfileId,
    );
  }

  Future<WindowOperationResult> applyRoute(String? routeName) {
    final profileId = _router.resolve(routeName);
    if (profileId == null) {
      return Future.value(
        const WindowOperationResult(status: WindowOperationStatus.unchanged),
      );
    }
    return applyProfile(profileId);
  }

  Future<WindowOperationResult> applyProfile(String profileId) async {
    final window = _window;
    if (!_initialized || window == null) {
      return WindowOperationResult(
        status: WindowOperationStatus.notInitialized,
        profileId: profileId,
      );
    }

    final profile = config.profiles[profileId];
    if (profile == null) {
      return WindowOperationResult(
        status: WindowOperationStatus.profileNotFound,
        profileId: profileId,
      );
    }

    if (_activeProfileId == profileId && !_ticker.isActive) {
      return WindowOperationResult(
        status: WindowOperationStatus.unchanged,
        profileId: profileId,
      );
    }
    if (_pendingProfileId == profileId && _transitionCompleter != null) {
      return _transitionCompleter!.future;
    }

    if (window.isMaximized || window.isMinimized || window.isFullScreen) {
      return WindowOperationResult(
        status: WindowOperationStatus.userWindowStatePreserved,
        profileId: profileId,
      );
    }

    _cancelTransition(WindowOperationStatus.interruptedByNewRequest);
    final current = window.bounds.toRect();
    final workArea = _workAreaFor(current);
    final target = _geometryResolver.resolve(
      currentBounds: current,
      requestedSize: profile.size,
      constraints: profile.constraints,
      workArea: workArea,
      positionPolicy: profile.positionPolicy,
    );

    if (_nearlyEqual(current, target)) {
      _applyConstraints(profile, workArea);
      _applyProfilePresentation(profile);
      _activeProfileId = profileId;
      return WindowOperationResult(
        status: WindowOperationStatus.unchanged,
        profileId: profileId,
      );
    }

    _pendingProfileId = profileId;

    if (!config.animation.enabled) {
      await _safeSetBounds(target);
      _applyConstraints(profile, workArea);
      _applyProfilePresentation(profile);
      _activeProfileId = profileId;
      _pendingProfileId = null;
      return WindowOperationResult(
        status: WindowOperationStatus.completed,
        profileId: profileId,
      );
    }

    _applyTransitionConstraints(current, target, workArea);
    _applyProfilePresentation(profile);
    return _animateBounds(current, target, profileId);
  }

  Future<void> _safeSetBounds(Rect bounds) async {
    final window = _window;
    if (window == null) return;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
    window.bounds = bounds.toNative();
  }

  Future<WindowOperationResult> _animateBounds(
    Rect start,
    Rect target,
    String profileId,
  ) async {
    final window = _window!;
    final completer = Completer<WindowOperationResult>();
    _transitionCompleter = completer;
    _transitionStart = start;
    _transitionTarget = target;
    _lastExpectedBounds = start;
    _transitionDuration = config.animation.duration;

    // animateBounds returns false on platforms without native frame animation.
    _nativeAnimation =
        config.animation.preferNative && window.animateBounds(target.toNative());

    if (!_nativeAnimation) {
      // Platforms without native OS window animation (Windows/Linux) must not
      // attempt frame-by-frame bounds manipulation via a Flutter Ticker, because
      // SetWindowPos dispatches Win32 messages re-entrantly into Flutter's WndProc
      // during transientCallbacks, triggering scheduler assertion failures.
      await _safeSetBounds(target);
      final profile = config.profiles[profileId];
      if (profile != null) {
        _applyConstraints(profile, _workAreaFor(target));
        _applyProfilePresentation(profile);
      }
      _finishTransition(WindowOperationStatus.completed);
      return completer.future;
    }

    _ticker.start();
    return completer.future;
  }

  void _handleAnimationFrame(Duration elapsed) {
    final window = _window;
    final start = _transitionStart;
    final target = _transitionTarget;
    final completer = _transitionCompleter;
    if (window == null || start == null || target == null || completer == null) {
      _ticker.stop();
      return;
    }

    final actual = window.bounds.toRect();

    if (_nativeAnimation) {
      final elapsedLimit = _transitionDuration + _transitionDuration +
          const Duration(milliseconds: 120);
      if (_nearlyEqual(actual, target)) {
        _finishTransition(WindowOperationStatus.completed);
      } else if (elapsed >= elapsedLimit) {
        _finishTransition(WindowOperationStatus.completed);
      }
      return;
    }

    _finishTransition(WindowOperationStatus.completed);
  }

  void _handleWindowEvent(WindowEvent event) {
    if (_window != null) {
      final currentMaximized = _window!.isMaximized;
      if (_isMaximizedNotifier.value != currentMaximized) {
        _isMaximizedNotifier.value = currentMaximized;
      }
    }

    if (!_ticker.isActive || _nativeAnimation || _window == null) {
      return;
    }

    if (event is WindowResizedEvent || event is WindowMovedEvent) {
      final actual = _window!.bounds.toRect();
      final expected = _lastExpectedBounds;
      if (expected != null &&
          _rectDistance(actual, expected) >
              config.animation.manualResizeInterruptThreshold) {
        _cancelTransition(WindowOperationStatus.interruptedByUser);
      }
    }
  }

  void _finishTransition(WindowOperationStatus status) {
    final profileId = _pendingProfileId;
    _ticker.stop();
    _transitionStart = null;
    _transitionTarget = null;
    _lastExpectedBounds = null;
    _nativeAnimation = false;
    _pendingProfileId = null;
    _transitionCompleter?.complete(
      WindowOperationResult(status: status, profileId: profileId),
    );
    _transitionCompleter = null;
    if (status == WindowOperationStatus.completed && profileId != null) {
      _activeProfileId = profileId;
      final profile = config.profiles[profileId];
      final window = _window;
      if (profile != null && window != null) {
        _applyConstraints(profile, _workAreaFor(window.bounds.toRect()));
        _applyProfilePresentation(profile);
      }
    }
  }

  void _cancelTransition(WindowOperationStatus reason) {
    if (_transitionCompleter == null) {
      return;
    }

    // Stop a native animation at its current bounds before accepting the next
    // request; never jump back to the old transition's start point.
    if (_nativeAnimation && _window != null) {
      final current = _window!.bounds.toRect();
      _window!.bounds = current.toNative();
    }

    _ticker.stop(canceled: true);
    final profileId = _pendingProfileId;
    _transitionCompleter!.complete(
      WindowOperationResult(status: reason, profileId: profileId),
    );
    _transitionCompleter = null;
    _transitionStart = null;
    _transitionTarget = null;
    _lastExpectedBounds = null;
    _pendingProfileId = null;
    _nativeAnimation = false;
  }

  void _applyTransitionConstraints(Rect start, Rect target, Rect workArea) {
    final window = _window!;
    final minimum = Size(
      math.min(start.width, target.width).toDouble(),
      math.min(start.height, target.height).toDouble(),
    );
    final maximum = Size(
      math.max(start.width, target.width).toDouble(),
      math.max(start.height, target.height).toDouble(),
    );
    window.minimumSize = minimum.toNative();
    window.maximumSize = Size(
      math.min(maximum.width, workArea.width).toDouble(),
      math.min(maximum.height, workArea.height).toDouble(),
    ).toNative();
    window.isResizable = false;
  }

  void _applyConstraints(WindowProfile profile, Rect workArea) {
    final window = _window!;
    final requestedMin = profile.constraints.minimumSize ?? Size.zero;
    final minSize = Size(
      math.min(requestedMin.width, workArea.width).toDouble(),
      math.min(requestedMin.height, workArea.height).toDouble(),
    );
    final requestedMax = profile.constraints.maximumSize ?? workArea.size;
    final maxSize = Size(
      math
          .max(minSize.width, math.min(requestedMax.width, workArea.width))
          .toDouble(),
      math
          .max(minSize.height, math.min(requestedMax.height, workArea.height))
          .toDouble(),
    );
    window.minimumSize = minSize.toNative();
    window.maximumSize = maxSize.toNative();
    window.isResizable = profile.resizable && config.resizable;
  }

  void _applyInitialWindowChrome(WindowProfile profile) {
    final window = _window;
    if (window == null) return;
    if (profile.frameless) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.setFrameless(true);
    } else {
      window.setFrameless(false);
      window.titleBarStyle = profile.titleBarStyle == WindowTitleBarStyle.hidden
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal;
    }
  }

  void _applyProfilePresentation(WindowProfile profile) {
    final window = _window;
    if (window == null) return;

    window.isResizable = profile.resizable && config.resizable;
    window.isAlwaysOnTop = profile.alwaysOnTop;
    window.isVisibleInTaskbar = !profile.skipTaskbar;
  }

  Rect _workAreaFor(Rect currentBounds) {
    final displays = DisplayManager.instance.getAll();
    for (final display in displays) {
      final workArea = display.workArea.toRect();
      if (workArea.overlaps(currentBounds)) {
        return workArea;
      }
    }
    final primary = DisplayManager.instance.getPrimary();
    return primary?.workArea.toRect() ??
        Rect.fromLTWH(0, 0, currentBounds.width, currentBounds.height);
  }

  void _applyInitialPresentationState(WindowPresentationState state) {
    switch (state) {
      case WindowPresentationState.normal:
        break;
      case WindowPresentationState.maximized:
        _window?.maximize();
        break;
      case WindowPresentationState.fullscreen:
        if (_window != null) {
          _window!.isFullScreen = true;
        }
        break;
    }
  }

  bool _nearlyEqual(Rect a, Rect b) => _rectDistance(a, b) <= 1.5;

  double _rectDistance(Rect a, Rect b) {
    return math.max(
      math.max((a.left - b.left).abs(), (a.top - b.top).abs()),
      math.max((a.width - b.width).abs(), (a.height - b.height).abs()),
    ).toDouble();
  }

  bool get isMaximized => _window?.isMaximized ?? false;
  ValueListenable<bool> get isMaximizedListenable => _isMaximizedNotifier;

  void maximize() {
    _window?.maximize();
    _isMaximizedNotifier.value = isMaximized;
  }

  void minimize() {
    _window?.minimize();
    _isMaximizedNotifier.value = isMaximized;
  }

  void restore() {
    _window?.unmaximize();
    _isMaximizedNotifier.value = isMaximized;
  }

  void toggleMaximize() {
    final window = _window;
    if (window == null) return;
    if (window.isMaximized) {
      window.unmaximize();
    } else {
      window.maximize();
    }
    _isMaximizedNotifier.value = window.isMaximized;
  }

  void startDragging() => _window?.startDragging();

  void performTitleBarDoubleClick() {
    final window = _window;
    if (window == null) return;
    window.performTitleBarDoubleClick();
    _isMaximizedNotifier.value = window.isMaximized;
  }

  void close() => _window?.close();

  void setFullscreen(bool enabled) {
    final window = _window;
    if (window != null) {
      window.isFullScreen = enabled;
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _cancelTransition(WindowOperationStatus.interruptedByNewRequest);
    _ticker.dispose();
    _isMaximizedNotifier.dispose();
    final window = _window;
    final listenerId = _listenerId;
    if (window != null && listenerId != null) {
      window.removeListener(listenerId);
    }
    _window = null;
    _initialized = false;
  }
}
