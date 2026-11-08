import 'dart:async';
import 'dart:developer';

import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:desktop_windowing/desktop_windowing.dart';
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

  final RxString statusMessage =
      'تهيئة النواة السحابية والتحقق من البيئة...'.obs;
  final RxDouble progress = 0.18.obs;

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _bootstrapApp();
  }

  void _updatePhase(String message, double targetProgress) {
    if (_isDisposed) return;
    statusMessage.value = message;
    progress.value = targetProgress;
  }

  Future<void> _bootstrapApp() async {
    try {
      final stopwatch = Stopwatch()..start();

      _updatePhase('تهيئة النواة السحابية والتحقق من البيئة...', 0.22);
      final initFuture = initializeAppUseCase();

      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (_isDisposed) return;

      _updatePhase('فحص حزم التشفير وتكامل الجلسة الآمنة...', 0.58);
      await initFuture;
      if (_isDisposed) return;

      _updatePhase('التحقق من هوية المنصة وسياسات الوصول...', 0.85);
      final destinationFuture = determineBootDestinationUseCase();

      final elapsed = stopwatch.elapsed;
      if (elapsed < minSplashDuration) {
        await Future<void>.delayed(minSplashDuration - elapsed);
      }
      if (_isDisposed) return;

      final destination = await destinationFuture;
      if (_isDisposed) return;

      _updatePhase('اكتملت الجاهزية — جاري فتح المنصة...', 1.0);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (_isDisposed) return;

      log('[SplashController] Startup complete. Navigating to: $destination');
      if (Get.isRegistered<DesktopWindowingController>()) {
        await Get.find<DesktopWindowingController>().applyRoute(destination);
      }
      if (!_isDisposed) {
        unawaited(Get.offNamed<void>(destination));
      }
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
        if (Get.isRegistered<DesktopWindowingController>()) {
          await Get.find<DesktopWindowingController>()
              .applyRoute(AppRoutes.login);
        }
        if (!_isDisposed) {
          unawaited(Get.offNamed<void>(AppRoutes.login));
        }
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    super.onClose();
  }
}
