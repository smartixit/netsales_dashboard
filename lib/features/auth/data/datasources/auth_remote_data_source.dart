import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/auth/data/models/login_request_model.dart';
import 'package:netsales_dashboard/features/auth/data/models/login_response_model.dart';
import 'package:netsales_dashboard/features/auth/data/models/reset_password_request_model.dart';
import 'package:netsales_dashboard/features/auth/data/models/verify_two_factor_request_model.dart';

/// عقد مصدر البيانات البعيد للمصادقة والحسابات
abstract interface class AuthRemoteDataSource {
  /// إرسال طلب تسجيل الدخول للواجهة الخلفية
  Future<ApiResponse<LoginResponseModel>> login(LoginRequestModel request);

  /// تحديث كلمة المرور للمستخدم المسجل (إلزامي أو اختياري)
  Future<ApiResponse<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// جلب الملف الشخصي والصلاحيات المحدثة للمستخدم المسجل
  Future<ApiResponse<Map<String, dynamic>>> getProfile();

  /// إرسال طلب استعادة كلمة المرور عبر رمز OTP
  Future<ApiResponse<void>> requestPasswordReset(String phoneNumber);

  /// التحقق من رمز OTP واستلام كلمة مرور مؤقتة عبر SMS
  Future<ApiResponse<void>> verifyResetOtp({
    required String phoneNumber,
    required String otp,
  });

  /// اعتماد كلمة المرور الجديدة مباشرة مع رمز التحقق OTP
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequestModel request);

  /// إتمام التحقق الثنائي وتأكيد الجهاز وإنشاء الجلسة
  Future<ApiResponse<LoginResponseModel>> verifyTwoFactor(
    VerifyTwoFactorRequestModel request,
  );

  /// إعادة إرسال رمز OTP محدد النوع (مثل OTP_2FA)
  Future<ApiResponse<void>> resendOtp({
    required String phoneNumber,
    required String otpType,
    required String deviceUuid,
  });

  /// تسجيل الخروج وإنهاء الجلسة الحالية
  Future<ApiResponse<void>> logout({required String deviceUuid});
}
