import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/locale_service.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_grid_columns.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/app_data_grid_export_controller.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/net_sales_data_grid_source.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_networks_use_case.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformNetworksController extends GetxController {
  PlatformNetworksController({
    required this._getNetworks,
  });

  final GetPlatformNetworksUseCase _getNetworks;

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
  late final NetSalesDataGridSource<PlatformNetworkEntity> gridSource;
  final AppDataGridExportController exportController = AppDataGridExportController();

  Timer? _searchDebounce;
  int _requestGeneration = 0;

  bool get hasMore => nextCursor.value?.isNotEmpty ?? false;

  @override
  void onInit() {
    super.onInit();
    gridSource = NetSalesDataGridSource<PlatformNetworkEntity>(
      items: const <PlatformNetworkEntity>[],
      columns: PlatformNetworkGridColumns.build(
        AppLocalizations(LocaleService.to.locale),
      ),
    );
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
      gridSource.replaceRows(networks.toList(growable: false));
      nextCursor.value = response.nextCursor;
      viewState.value = networks.isEmpty
          ? (searchQuery.value.isNotEmpty || selectedStatus.value.isNotEmpty
                ? AppDataGridViewState.noResults
                : AppDataGridViewState.empty)
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

  void clearFilters() {
    _searchDebounce?.cancel();
    searchController.clear();
    searchQuery.value = '';
    selectedStatus.value = '';
    loadNetworks();
  }

  void setStatus(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    loadNetworks();
  }

  @override
  void onClose() {
    _requestGeneration++;
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
