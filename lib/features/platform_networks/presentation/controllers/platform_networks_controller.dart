import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/approve_platform_network_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_networks_use_case.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformNetworksController extends GetxController {
  PlatformNetworksController({
    required GetPlatformNetworksUseCase getNetworks,
    required ApprovePlatformNetworkUseCase approveNetwork,
  }) : _getNetworks = getNetworks,
       _approveNetwork = approveNetwork;

  final GetPlatformNetworksUseCase _getNetworks;
  final ApprovePlatformNetworkUseCase _approveNetwork;

  static const int pageSize = 20;

  final networks = <PlatformNetworkEntity>[].obs;
  final viewState = AppDataGridViewState.loading.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;
  final nextCursor = RxnString();
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;
  final isApproving = <int>{}.obs;

  Timer? _searchDebounce;
  int _requestGeneration = 0;

  bool get hasMore => nextCursor.value?.isNotEmpty ?? false;

  @override
  void onInit() {
    super.onInit();
    loadNetworks();
  }

  Future<void> loadNetworks({bool append = false}) async {
    if (append && (!hasMore || isLoadingMore.value)) return;
    final generation = ++_requestGeneration;
    if (append) {
      isLoadingMore.value = true;
    } else {
      isLoadingMore.value = false;
      if (networks.isEmpty) {
        viewState.value = AppDataGridViewState.loading;
      } else {
        isRefreshing.value = true;
      }
      errorMessage.value = '';
      nextCursor.value = null;
    }

    try {
      final response = await _getNetworks(
        search: searchQuery.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        cursor: append ? nextCursor.value : null,
        perPage: pageSize,
      );
      if (generation != _requestGeneration) return;
      if (!response.success || response.data == null) {
        throw Exception(response.message.isNotEmpty
            ? response.message
            : 'تعذر تحميل قائمة الشبكات.');
      }
      if (append) {
        networks.addAll(response.data!);
      } else {
        networks.assignAll(response.data!);
      }
      nextCursor.value = response.nextCursor;
      viewState.value = networks.isEmpty
          ? AppDataGridViewState.empty
          : AppDataGridViewState.success;
    } catch (error) {
      if (generation != _requestGeneration) return;
      errorMessage.value = error.toString();
      if (!append && networks.isEmpty) {
        viewState.value = AppDataGridViewState.error;
      }
    } finally {
      if (generation == _requestGeneration) {
        isLoadingMore.value = false;
        isRefreshing.value = false;
      }
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
      () => loadNetworks(),
    );
  }

  void setStatus(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    loadNetworks();
  }

  Future<void> approve(int networkId) async {
    if (isApproving.contains(networkId)) return;
    isApproving.add(networkId);
    try {
      await _approveNetwork(networkId);
      await loadNetworks();
    } finally {
      isApproving.remove(networkId);
    }
  }

  void replaceNetwork(PlatformNetworkEntity updated) {
    final index = networks.indexWhere((item) => item.id == updated.id);
    if (index >= 0) networks[index] = updated;
  }

  @override
  void onClose() {
    _requestGeneration++;
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
