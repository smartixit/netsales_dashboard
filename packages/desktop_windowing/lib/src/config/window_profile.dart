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

/// A named window geometry and presentation policy.
class WindowProfile {
  const WindowProfile({
    required this.id,
    required this.size,
    this.constraints = const WindowConstraints(),
    this.positionPolicy = WindowPositionPolicy.center,
    this.initialState = WindowPresentationState.normal,
  }) : assert(id != '');

  final String id;

  /// Target outer-frame size in Flutter logical pixels.
  final Size size;

  final WindowConstraints constraints;
  final WindowPositionPolicy positionPolicy;

  /// Applied during initialization. Profile changes do not override a
  /// maximized or fullscreen state explicitly chosen by the user.
  final WindowPresentationState initialState;
}
