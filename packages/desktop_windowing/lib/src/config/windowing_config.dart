import 'window_animation_config.dart';
import 'window_profile.dart';

/// App-supplied configuration. It contains no app routes or framework types.
class WindowingConfig {
  const WindowingConfig({
    required this.initialProfileId,
    required this.profiles,
    this.routeProfiles = const {},
    this.animation = const WindowAnimationConfig(),
    this.hideUntilReady = true,
    this.resizable = true,
  }) : assert(initialProfileId != '');

  final String initialProfileId;
  final Map<String, WindowProfile> profiles;

  /// Maps route names to profile identifiers. Multiple routes can share one
  /// profile so routine navigation does not resize the native window.
  final Map<String, String> routeProfiles;

  final WindowAnimationConfig animation;
  final bool hideUntilReady;
  final bool resizable;
}
