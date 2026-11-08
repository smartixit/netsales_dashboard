import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/exceptions/app_exception.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_session_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_sessions_use_case.dart';

/// يدير حالة العرض وعمليات القراءة في شاشة تفاصيل مستخدم المنصة.
class PlatformUserDetailController extends GetxController {
  PlatformUserDetailController({
    required this.userId,
    required GetPlatformUserDetailUseCase getUserDetail,
    required GetPlatformUserSessionsUseCase getUserSessions,
  }) : _getUserDetail = getUserDetail,
       _getUserSessions = getUserSessions;

  final int userId;
  final GetPlatformUserDetailUseCase _getUserDetail;
  final GetPlatformUserSessionsUseCase _getUserSessions;

  final Rxn<PlatformUserDetailEntity> detail = Rxn<PlatformUserDetailEntity>();
  final RxList<PlatformUserSessionEntity> sessions =
      <PlatformUserSessionEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSessionsLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString sessionsError = ''.obs;

  bool get canViewSecurity =>
      PermissionService.to.can(AppPermissions.authView);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      detail.value = await _getUserDetail.execute(userId);
      if (canViewSecurity) {
        await loadSessions();
      }
    } catch (error) {
      errorMessage.value = AppException.sanitizeMessage(
        error,
        fallback: 'تعذر تحميل تفاصيل المستخدم.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSessions() async {
    if (!canViewSecurity) return;
    isSessionsLoading.value = true;
    sessionsError.value = '';
    try {
      sessions.assignAll(await _getUserSessions.execute(userId));
    } catch (error) {
      sessionsError.value = AppException.sanitizeMessage(
        error,
        fallback: 'تعذر تحميل جلسات المستخدم.',
      );
    } finally {
      isSessionsLoading.value = false;
    }
  }
}
