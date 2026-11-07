import 'package:netsales_dashboard/features/auth/domain/entities/auth_result_entity.dart';

/// عقد مستودع المصادقة الدوميني المجرد
abstract interface class AuthRepository {
  /// تسجيل الدخول إلى النظام والتحقق من المستخدم وإنشاء الجلسة
  Future<AuthResultEntity> login({
    required String phoneNumber,
    required String password,
    required String deviceUuid,
    required String fcmToken,
    String? deviceName,
    String? deviceType,
  });

  /// تحديث كلمة المرور للمستخدم المسجل وتأكيد الهوية وتحديث الصلاحيات
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// طلب رمز التحقق لاستعادة كلمة المرور عبر SMS
  Future<void> requestPasswordReset(String phoneNumber);

  /// التحقق من رمز OTP واستلام كلمة المرور المؤقتة عبر SMS
  Future<void> verifyResetOtp({
    required String phoneNumber,
    required String otp,
  });

  /// اعتماد كلمة المرور الجديدة بعد استيفاء رمز التحقق OTP
  Future<void> resetPassword({
    required String phoneNumber,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  });

  /// إتمام التحقق الثنائي وتأكيد ربط الجهاز وإنشاء الجلسة
  Future<AuthResultEntity> verifyTwoFactor({
    required String phoneNumber,
    required String otp,
    required String deviceUuid,
    required String fcmToken,
    String? deviceName,
    String? deviceType,
  });

  /// إعادة إرسال رمز OTP محدد النوع
  Future<void> resendOtp({
    required String phoneNumber,
    required String otpType,
    required String deviceUuid,
  });

  /// تسجيل الخروج وإنهاء الجلسة الرسمية على الخادم محلياً وعن بعد
  Future<void> logout();
}
