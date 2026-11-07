import 'package:flutter/animation.dart';

/// Controls how a profile transition changes the native window bounds.
class WindowAnimationConfig {
  const WindowAnimationConfig({
    this.enabled = true,
    this.preferNative = true,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeInOutCubic,
    this.manualResizeInterruptThreshold = 24,
  }) : assert(manualResizeInterruptThreshold >= 0);

  /// Whether profile changes are animated.
  final bool enabled;

  /// Uses the operating system animation when the native API supports it.
  /// Other platforms fall back to the package's single frame-driven ticker.
  final bool preferNative;

  /// Duration used by the frame-driven fallback and native completion guard.
  final Duration duration;

  /// Curve used by the frame-driven fallback.
  final Curve curve;

  /// A native resize/move event farther than this many logical pixels from
  /// the expected frame is treated as a manual user override.
  final double manualResizeInterruptThreshold;
}
