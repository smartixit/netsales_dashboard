import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_users_use_case.dart';
import 'package:netsales_dashboard/core/exceptions/app_exception.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformUsersController extends GetxController {
  PlatformUsersController({required GetPlatformUsersUseCase getPlatformUsers})
      : _getPlatformUsers = getPlatformUsers;

  final GetPlatformUsersUseCase _getPlatformUsers;
  static const int _pageSize = 20;
  final users = <PlatformUserEntity>[].obs;
  final viewState = AppDataGridViewState.loading.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;
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
      final page = await _getPlatformUsers.execute(
        GetPlatformUsersParams(
          search: searchQuery.value,
          status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
          cursor: append ? nextCursor.value : null,
          perPage: _pageSize,
        ),
      );
      if (generation != _requestGeneration) return;
      if (append) {
        users.addAll(page.users);
      } else {
        users.assignAll(page.users);
      }
      nextCursor.value = page.nextCursor;
      viewState.value = users.isEmpty ? AppDataGridViewState.empty : AppDataGridViewState.success;
    } catch (error) {
      if (generation != _requestGeneration) return;
      errorMessage.value = AppException.sanitizeMessage(error, fallback: 'تعذر تحميل قائمة المستخدمين.');
      if (!append || users.isEmpty) viewState.value = AppDataGridViewState.error;
    } finally {
      if (generation == _requestGeneration) isLoadingMore.value = false;
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
