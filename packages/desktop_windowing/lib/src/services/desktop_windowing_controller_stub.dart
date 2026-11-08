import 'package:flutter/widgets.dart';

import '../config/windowing_config.dart';
import '../models/window_operation_result.dart';

/// Web/non-desktop implementation. Browser window sizing remains under the
/// browser and user controls; the Flutter UI remains responsive instead.
class DesktopWindowingController {
  DesktopWindowingController({required this.config});

  final WindowingConfig config;

  bool get isSupported => false;
  bool get isInitialized => false;
  String? get activeProfileId => null;
  Rect? get currentBounds => null;

  Future<WindowOperationResult> initialize() async =>
      const WindowOperationResult(
        status: WindowOperationStatus.unsupportedPlatform,
      );

  Future<WindowOperationResult> show() async =>
      const WindowOperationResult(
        status: WindowOperationStatus.unsupportedPlatform,
      );

  Future<WindowOperationResult> applyProfile(String profileId) async =>
      WindowOperationResult(
        status: WindowOperationStatus.unsupportedPlatform,
        profileId: profileId,
      );

  Future<WindowOperationResult> applyRoute(String? routeName) async =>
      const WindowOperationResult(
        status: WindowOperationStatus.unsupportedPlatform,
      );

  void maximize() {}

  void minimize() {}

  void restore() {}

  void setFullscreen(bool enabled) {}

  void dispose() {}
}
