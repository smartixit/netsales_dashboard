import 'package:flutter/widgets.dart';

import 'window_constraints.dart';

enum WindowPositionPolicy {
  /// Center the target window within the selected display's work area.
  center,

  /// Keep the current top-left position, clamped to the selected work area.
  preserve,

  /// Place the window at the work area's top-left corner.
  workAreaOrigin,
}

enum WindowPresentationState {
  normal,
  maximized,
  fullscreen,
}

enum WindowTitleBarStyle {
  normal,
  hidden,
}

/// A named window geometry and presentation policy.
class WindowProfile {
  const WindowProfile({
    required this.id,
    required this.size,
    this.constraints = const WindowConstraints(),
    this.positionPolicy = WindowPositionPolicy.center,
    this.initialState = WindowPresentationState.normal,
    this.resizable = true,
    this.alwaysOnTop = false,
    this.skipTaskbar = false,
    this.frameless = false,
    this.titleBarStyle = WindowTitleBarStyle.normal,
  }) : assert(id != '');

  final String id;

  /// Target outer-frame size in Flutter logical pixels.
  final Size size;

  final WindowConstraints constraints;
  final WindowPositionPolicy positionPolicy;

  /// Applied during initialization. Profile changes do not override a
  /// maximized or fullscreen state explicitly chosen by the user.
  final WindowPresentationState initialState;

  /// Whether the native window frame can be manually resized by the user.
  final bool resizable;

  /// Whether the window remains floating on top of all other windows.
  final bool alwaysOnTop;

  /// Whether the window is hidden from the system taskbar/dock.
  final bool skipTaskbar;

  /// Whether the native window is completely frameless without OS chrome.
  final bool frameless;

  /// OS title bar presentation style (normal or hidden).
  final WindowTitleBarStyle titleBarStyle;
}
