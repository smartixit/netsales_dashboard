import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/exceptions/app_exception.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/features/auth/domain/usecases/request_password_reset_use_case.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

/// Controller for requesting a password recovery code.
class ForgotPasswordController extends GetxController {
  ForgotPasswordController({required this.requestPasswordResetUseCase});

  final RequestPasswordResetUseCase requestPasswordResetUseCase;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> submit() async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      await CustomAnimationOverlay.showLoading();

      final phone = phoneController.text.trim();
      await requestPasswordResetUseCase.execute(phone);

      if (isClosed) return;

      await CustomAnimationOverlay.showSuccess(
        message: 'تم إرسال رمز التحقق بنجاح!',
      );

      if (isClosed) return;

      await Get.toNamed<void>(AppRoutes.verifyOtp, arguments: {'phone': phone});
    } catch (error) {
      await CustomAnimationOverlay.hide();
      if (isClosed) return;
      final cleanMessage = AppException.sanitizeMessage(error);
      CustomSnackbar.show(
        title: 'تعذر إرسال الرمز',
        message: cleanMessage,
        type: SnackType.error,
      );
    } finally {
      isLoading.value = false;
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
    }
  }

  /// Reveal the existing login route instead of creating a second login page.
  ///
  /// LoginController owns the login Form GlobalKey. Pushing another login route
  /// while the original remains below recovery would mount that same key twice.
  void goToLogin() {
    if (Get.currentRoute == AppRoutes.forgotPassword &&
        Get.previousRoute == AppRoutes.login) {
      Get.back<void>();
      return;
    }

    Get.offAllNamed<void>(AppRoutes.login);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
