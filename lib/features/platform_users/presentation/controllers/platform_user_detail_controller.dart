import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_sessions_use_case.dart';

class PlatformUserDetailController extends GetxController {
  PlatformUserDetailController(this.userId, this._getDetail, this._getSessions);
  final int userId;
  final GetPlatformUserDetailUseCase _getDetail;
  final GetPlatformUserSessionsUseCase _getSessions;
  final detail = Rxn<PlatformUserDetailEntity>();
  final sessions = <PlatformUserSessionEntity>[].obs;
  final isLoading = true.obs;
  final isSessionsLoading = false.obs;
  final errorMessage = ''.obs;
  final sessionsError = ''.obs;

  bool get canViewSecurity => PermissionService.to.can(AppPermissions.authView);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getDetail(userId);
      if (result == null) {
        throw Exception('لم يتم العثور على حساب المستخدم المطلوب.');
      }
      detail.value = result;
      if (canViewSecurity) {
        await loadSessions();
      }
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSessions() async {
    if (!canViewSecurity) return;
    isSessionsLoading.value = true;
    sessionsError.value = '';
    try {
      sessions.assignAll(await _getSessions(userId));
    } catch (error) {
      sessionsError.value = error.toString();
    } finally {
      isSessionsLoading.value = false;
    }
  }
}
