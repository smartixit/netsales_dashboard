import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/enums/user_status.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_sessions_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/update_platform_user_status_use_case.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

class PlatformUserDetailController extends GetxController {
  PlatformUserDetailController(
    this.userId,
    this._getDetail,
    this._getSessions,
    this._updateStatus,
  );

  final int userId;
  final GetPlatformUserDetailUseCase _getDetail;
  final GetPlatformUserSessionsUseCase _getSessions;
  final UpdatePlatformUserStatusUseCase _updateStatus;

  final detail = Rxn<PlatformUserDetailEntity>();
  final sessions = <PlatformUserSessionEntity>[].obs;
  final isLoading = true.obs;
  final isSessionsLoading = false.obs;
  final isStatusUpdating = false.obs;
  final errorMessage = ''.obs;
  final sessionsError = ''.obs;
  int _detailGeneration = 0;
  int _sessionsGeneration = 0;

  bool get canViewSecurity => PermissionService.to.can(AppPermissions.authView);
  bool get canEditUser => PermissionService.to.can(AppPermissions.usersEdit);
  bool get canChangeStatus =>
      canEditUser &&
      detail.value != null &&
      detail.value!.user.status != UserStatus.banned.wireValue;

  String get nextStatus {
    final current = detail.value?.user.status;
    return current == UserStatus.active.wireValue
        ? UserStatus.inactive.wireValue
        : UserStatus.active.wireValue;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final generation = ++_detailGeneration;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getDetail(userId);
      if (isClosed || generation != _detailGeneration) return;
      if (result == null) {
        throw Exception('لم يتم العثور على حساب المستخدم المطلوب.');
      }
      detail.value = result;
      if (canViewSecurity) await loadSessions();
    } catch (error) {
      if (!isClosed && generation == _detailGeneration) {
        errorMessage.value = error.toString();
      }
    } finally {
      if (!isClosed && generation == _detailGeneration) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadSessions() async {
    if (!canViewSecurity || isClosed) return;
    final generation = ++_sessionsGeneration;
    isSessionsLoading.value = true;
    sessionsError.value = '';
    try {
      final result = await _getSessions(userId);
      if (isClosed || generation != _sessionsGeneration) return;
      sessions.assignAll(result);
    } catch (error) {
      if (!isClosed && generation == _sessionsGeneration) {
        sessionsError.value = error.toString();
      }
    } finally {
      if (!isClosed && generation == _sessionsGeneration) {
        isSessionsLoading.value = false;
      }
    }
  }

  Future<void> changeStatus() async {
    if (!canChangeStatus || isStatusUpdating.value || isClosed) return;
    final target = nextStatus;
    final targetLabel = target == UserStatus.active.wireValue
        ? 'التفعيل'
        : 'إيقاف الحساب';

    final confirmed = await CustomDialog.showConfirmation(
      title: 'تغيير حالة الحساب',
      message: target == UserStatus.active.wireValue
          ? 'سيتم تفعيل حساب المستخدم والسماح له بتسجيل الدخول. هل تريد المتابعة؟'
          : 'سيتم إيقاف حساب المستخدم ومنعه من استخدام المنصة. هل تريد المتابعة؟',
      confirmLabel: targetLabel,
      cancelLabel: 'إلغاء',
    );
    if (confirmed != true) return;

    isStatusUpdating.value = true;
    try {
      await CustomAnimationOverlay.showLoading(
        message: 'جارٍ تحديث حالة الحساب...',
      );
      await _updateStatus(userId, target);
      if (isClosed) return;
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
      await load();
      await CustomAnimationOverlay.showSuccess(
        message: 'تم تحديث حالة حساب المستخدم.',
      );
    } catch (error) {
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
      CustomSnackbar.show(
        title: 'تعذر تحديث حالة الحساب',
        message: error.toString(),
        type: SnackType.error,
      );
    } finally {
      if (!isClosed) isStatusUpdating.value = false;
    }
  }

  @override
  void onClose() {
    _detailGeneration++;
    _sessionsGeneration++;
    super.onClose();
  }
}
