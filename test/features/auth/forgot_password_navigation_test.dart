import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/features/auth/domain/entities/auth_result_entity.dart';
import 'package:netsales_dashboard/features/auth/domain/repositories/auth_repository.dart';
import 'package:netsales_dashboard/features/auth/domain/usecases/request_password_reset_use_case.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/forgot_password_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'returning from password recovery reveals the existing login form',
    (tester) async {
      final loginFormKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.login,
          getPages: [
            GetPage<void>(
              name: AppRoutes.login,
              page: () => Scaffold(
                body: Form(
                  key: loginFormKey,
                  child: const Text('Existing login form'),
                ),
              ),
            ),
            GetPage<void>(
              name: AppRoutes.forgotPassword,
              page: () => const Scaffold(
                body: Text('Password recovery'),
              ),
              binding: BindingsBuilder<dynamic>(() {
                Get.lazyPut<ForgotPasswordController>(
                  () => ForgotPasswordController(
                    requestPasswordResetUseCase:
                        _FakeRequestPasswordResetUseCase(),
                  ),
                );
              }),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      unawaited(Get.toNamed<void>(AppRoutes.forgotPassword));
      await tester.pumpAndSettle();

      Get.find<ForgotPasswordController>().goToLogin();
      await tester.pumpAndSettle();

      expect(Get.currentRoute, AppRoutes.login);
      expect(find.text('Existing login form'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _FakeRequestPasswordResetUseCase extends RequestPasswordResetUseCase {
  _FakeRequestPasswordResetUseCase() : super(_FakeAuthRepository());

  @override
  Future<void> execute(String phoneNumber) async {}
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthResultEntity> login({
    required String phoneNumber,
    required String password,
    required String deviceUuid,
    required String fcmToken,
    String? deviceName,
    String? deviceType,
  }) async => throw UnimplementedError();

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async => throw UnimplementedError();

  @override
  Future<void> requestPasswordReset(String phoneNumber) async {}

  @override
  Future<void> verifyResetOtp({
    required String phoneNumber,
    required String otp,
  }) async => throw UnimplementedError();

  @override
  Future<void> resetPassword({
    required String phoneNumber,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async => throw UnimplementedError();

  @override
  Future<AuthResultEntity> verifyTwoFactor({
    required String phoneNumber,
    required String otp,
    required String deviceUuid,
    required String fcmToken,
    String? deviceName,
    String? deviceType,
  }) async => throw UnimplementedError();

  @override
  Future<void> resendOtp({
    required String phoneNumber,
    required String otpType,
    required String deviceUuid,
  }) async => throw UnimplementedError();

  @override
  Future<void> logout() async => throw UnimplementedError();
}
