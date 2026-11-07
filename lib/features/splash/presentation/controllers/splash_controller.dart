import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:netsales_dashboard/core/exceptions/app_exception.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_motion.dart';
import 'package:netsales_dashboard/features/splash/domain/usecases/determine_boot_destination_use_case.dart';
import 'package:netsales_dashboard/features/splash/domain/usecases/initialize_app_use_case.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

/// Coordinates startup timing and delegates routing decisions to Domain.
class SplashController extends GetxController {
  SplashController({
    required this.initializeAppUseCase,
    required this.determineBootDestinationUseCase,
  });

  final InitializeAppUseCase initializeAppUseCase;
  final DetermineBootDestinationUseCase determineBootDestinationUseCase;

  static const Duration minSplashDuration = AppMotion.splashMinimum;

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    try {
      final stopwatch = Stopwatch()..start();
      await initializeAppUseCase();

      final elapsed = stopwatch.elapsed;
      if (elapsed < minSplashDuration) {
        await Future<void>.delayed(minSplashDuration - elapsed);
      }
      if (_isDisposed) return;

      final destination = await determineBootDestinationUseCase();
      if (_isDisposed) return;

      log('[SplashController] Startup complete. Navigating to: $destination');
      await Get.offNamed<void>(destination);
    } catch (error, stackTrace) {
      final cleanMessage = AppException.sanitizeMessage(error);
      CustomSnackbar.show(
        title: 'تعذر تهيئة المنصة',
        message: cleanMessage,
        type: SnackType.error,
      );
      log(
        '[SplashController] Startup failed: $error',
        stackTrace: stackTrace,
      );
      if (!_isDisposed) {
        await Get.offNamed<void>(AppRoutes.login);
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    super.onClose();
  }
}
