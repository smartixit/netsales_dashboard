import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
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

  bool get hasMore => nextCursor.value?.isNotEmpty ?? false;

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

  Future<void> restoreUser(int userId) async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'استعادة المستخدم',
      message: 'سيتم إعادة الحساب إلى قائمة المستخدمين النشطين. هل تريد المتابعة؟',
      confirmLabel: 'استعادة',
      cancelLabel: 'إلغاء',
    );
    if (confirmed != true) return;
    try {
      await _recoverUser.restore(userId);
      await loadUsers();
      CustomSnackbar.show(title: 'تمت الاستعادة', message: 'أعيد المستخدم إلى النظام.', type: SnackType.success);
    } catch (error) {
      CustomSnackbar.show(title: 'تعذرت الاستعادة', message: error.toString(), type: SnackType.error);
    }
  }

  Future<void> forceDeleteUser(int userId) async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'حذف نهائي غير قابل للتراجع',
      message: 'سيتم حذف الحساب نهائياً من قاعدة البيانات. لا يمكن استعادة هذه البيانات بعد التنفيذ. هل أنت متأكد؟',
      confirmLabel: 'حذف نهائي',
      cancelLabel: 'إلغاء',
    );
    if (confirmed != true) return;
    try {
      await _recoverUser.forceDelete(userId);
      await loadUsers();
      CustomSnackbar.show(title: 'تم الحذف النهائي', message: 'حذف الحساب نهائياً.', type: SnackType.success);
    } catch (error) {
      CustomSnackbar.show(title: 'تعذر الحذف النهائي', message: error.toString(), type: SnackType.error);
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
