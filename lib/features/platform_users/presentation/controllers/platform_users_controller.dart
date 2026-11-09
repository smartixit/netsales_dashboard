import 'dart:async';

import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_users_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_trashed_platform_users_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/recover_platform_user_use_case.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformUsersController extends GetxController {
  PlatformUsersController(this._getUsers, this._getTrashedUsers, this._recoverUser);
  final GetPlatformUsersUseCase _getUsers;
  final GetTrashedPlatformUsersUseCase _getTrashedUsers;
  final RecoverPlatformUserUseCase _recoverUser;
  static const int _pageSize = 20;
  final users = <PlatformUserEntity>[].obs;
  final viewState = AppDataGridViewState.loading.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;
  final isTrashView = false.obs;
  final nextCursor = RxnString();
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  Timer? _searchDebounce;
  int _requestGeneration = 0;

  String _t(String key) => AppLocalizations(Get.locale ?? const Locale('ar')).text(key);

  bool get hasMore => nextCursor.value?.isNotEmpty ?? false;
  bool get canDelete => PermissionService.to.can(AppPermissions.usersDelete);
  bool get canRestore => PermissionService.to.can(AppPermissions.usersEdit);

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers({bool append = false}) async {
    if (append && (!hasMore || isLoadingMore.value)) return;
    final generation = ++_requestGeneration;
    if (append) {
      isLoadingMore.value = true;
    } else {
      isLoadingMore.value = false;
      viewState.value = AppDataGridViewState.loading;
      errorMessage.value = '';
      nextCursor.value = null;
    }
    try {
      final response = isTrashView.value
          ? await _getTrashedUsers(
              search: searchQuery.value,
              cursor: append ? nextCursor.value : null,
              perPage: _pageSize,
            )
          : await _getUsers(
              search: searchQuery.value,
              status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
              cursor: append ? nextCursor.value : null,
              perPage: _pageSize,
            );
      if (generation != _requestGeneration) return;
      if (!response.success || response.data == null) {
        throw Exception(
          response.message.isNotEmpty
              ? response.message
              : 'تعذر تحميل قائمة المستخدمين.',
        );
      }
      if (append) {
        users.addAll(response.data!);
      } else {
        users.assignAll(response.data!);
      }
      nextCursor.value = response.nextCursor;
      viewState.value = users.isEmpty
          ? AppDataGridViewState.empty
          : AppDataGridViewState.success;
    } catch (error) {
      if (generation != _requestGeneration) return;
      errorMessage.value = error.toString();
      if (!append || users.isEmpty) {
        viewState.value = AppDataGridViewState.error;
      }
    } finally {
      if (generation == _requestGeneration) isLoadingMore.value = false;
    }
  }


  void toggleTrashView() {
    isTrashView.value = !isTrashView.value;
    selectedStatus.value = '';
    loadUsers();
  }


  Future<void> softDeleteUser(int userId) async {
    if (!canDelete) return;
    final confirmed = await CustomDialog.showConfirmation(
      title: _t('user_soft_delete_title'),
      message: _t('user_soft_delete_confirmation'),
      confirmLabel: _t('user_soft_delete'),
      cancelLabel: 'إلغاء',
    );
    if (confirmed != true) return;
    try {
      await _recoverUser.softDelete(userId);
      await loadUsers();
      CustomSnackbar.show(title: _t('user_soft_delete'), message: _t('user_moved_to_trash'), type: SnackType.success);
    } catch (error) {
      CustomSnackbar.show(title: _t('user_soft_delete_title'), message: error.toString(), type: SnackType.error);
    }
  }

  Future<void> restoreUser(int userId) async {
    if (!canRestore) return;
    final confirmed = await CustomDialog.showConfirmation(
      title: _t('user_restore_title'),
      message: _t('user_restore_confirmation'),
      confirmLabel: _t('user_restore'),
      cancelLabel: 'إلغاء',
    );
    if (confirmed != true) return;
    try {
      await _recoverUser.restore(userId);
      await loadUsers();
      CustomSnackbar.show(title: _t('user_restore'), message: _t('user_restored'), type: SnackType.success);
    } catch (error) {
      CustomSnackbar.show(title: _t('user_restore_title'), message: error.toString(), type: SnackType.error);
    }
  }

  Future<void> forceDeleteUser(int userId) async {
    if (!canDelete) return;
    final confirmed = await CustomDialog.showConfirmation(
      title: _t('user_force_delete_title'),
      message: _t('user_force_delete_confirmation'),
      confirmLabel: _t('user_force_delete'),
      cancelLabel: 'إلغاء',
    );
    if (confirmed != true) return;
    try {
      await _recoverUser.forceDelete(userId);
      await loadUsers();
      CustomSnackbar.show(title: _t('user_force_delete'), message: _t('user_force_deleted'), type: SnackType.success);
    } catch (error) {
      CustomSnackbar.show(title: _t('user_force_delete_title'), message: error.toString(), type: SnackType.error);
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), loadUsers);
  }

  void setStatus(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    loadUsers();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
