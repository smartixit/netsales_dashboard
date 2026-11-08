import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/models/user_model.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_users_use_case.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformUsersController extends GetxController {
  PlatformUsersController(this._getUsers);

  final GetPlatformUsersUseCase _getUsers;
  static const int _pageSize = 20;

  final users = <UserModel>[].obs;
  final viewState = AppDataGridViewState.loading.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;
  final nextCursor = RxnString();
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  Timer? _searchDebounce;
  int _requestGeneration = 0;

  bool get hasMore => nextCursor.value != null && nextCursor.value!.isNotEmpty;

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
      viewState.value = AppDataGridViewState.loading;
      errorMessage.value = '';
      nextCursor.value = null;
    }

    try {
      final response = await _getUsers(
        search: searchQuery.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        cursor: append ? nextCursor.value : null,
        perPage: _pageSize,
      );
      if (generation != _requestGeneration) return;
      if (!response.success || response.data == null) {
        throw Exception(response.message.isNotEmpty ? response.message : 'تعذر تحميل قائمة المستخدمين.');
      }
      final page = response.data!;
      if (append) {
        users.addAll(page);
      } else {
        users.assignAll(page);
      }
      nextCursor.value = response.nextCursor;
      viewState.value = users.isEmpty ? AppDataGridViewState.empty : AppDataGridViewState.success;
    } catch (error) {
      if (generation != _requestGeneration) return;
      if (append && users.isNotEmpty) {
        errorMessage.value = error.toString();
      } else {
        errorMessage.value = error.toString();
        viewState.value = AppDataGridViewState.error;
      }
    } finally {
      if (generation == _requestGeneration) isLoadingMore.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), loadUsers);
  }

  void setStatus(String? status) {
    final next = status ?? '';
    if (selectedStatus.value == next) return;
    selectedStatus.value = next;
    loadUsers();
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
