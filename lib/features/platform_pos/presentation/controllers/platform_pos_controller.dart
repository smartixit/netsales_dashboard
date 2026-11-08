import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_list_use_case.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/app_data_grid_export_controller.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/net_sales_data_grid_source.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformPosController extends GetxController {
  PlatformPosController({required GetPlatformPosListUseCase getPos})
    : _getPos = getPos;

  final GetPlatformPosListUseCase _getPos;
  static const int pageSize = 20;

  final items = <PlatformPosEntity>[].obs;
  final viewState = AppDataGridViewState.loading.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;
  final nextCursor = RxnString();
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;
  late final NetSalesDataGridSource<PlatformPosEntity> gridSource;
  final AppDataGridExportController exportController =
      AppDataGridExportController();

  Timer? _debounce;
  int _generation = 0;

  bool get hasMore => nextCursor.value?.isNotEmpty ?? false;

  @override
  void onInit() {
    super.onInit();
    gridSource = NetSalesDataGridSource<PlatformPosEntity>(
      items: const <PlatformPosEntity>[],
      columns: const [],
    );
    load();
  }

  void attachColumns(List<dynamic> columns) {}

  Future<void> load({bool append = false}) async {
    if (append && (!hasMore || isLoadingMore.value)) return;
    final generation = ++_generation;
    if (append) {
      isLoadingMore.value = true;
    } else {
      isLoadingMore.value = false;
      if (items.isEmpty) {
        viewState.value = AppDataGridViewState.loading;
      } else {
        isRefreshing.value = true;
      }
      errorMessage.value = '';
      nextCursor.value = null;
    }
    try {
      final response = await _getPos(
        search: searchQuery.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        cursor: append ? nextCursor.value : null,
        perPage: pageSize,
      );
      if (generation != _generation) return;
      if (!response.success || response.data == null) {
        throw Exception(response.message.isNotEmpty
            ? response.message
            : 'تعذر تحميل نقاط البيع.');
      }
      if (append) {
        items.addAll(response.data!);
      } else {
        items.assignAll(response.data!);
      }
      gridSource.replaceRows(items.toList(growable: false));
      nextCursor.value = response.nextCursor;
      viewState.value = items.isEmpty
          ? (searchQuery.value.isNotEmpty || selectedStatus.value.isNotEmpty
                ? AppDataGridViewState.noResults
                : AppDataGridViewState.empty)
          : AppDataGridViewState.success;
    } catch (error) {
      if (generation != _generation) return;
      errorMessage.value = error.toString();
      if (!append && items.isEmpty) viewState.value = AppDataGridViewState.error;
    } finally {
      if (generation == _generation) {
        isLoadingMore.value = false;
        isRefreshing.value = false;
      }
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), load);
  }

  void setStatus(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    load();
  }

  void clearFilters() {
    _debounce?.cancel();
    searchController.clear();
    searchQuery.value = '';
    selectedStatus.value = '';
    load();
  }

  @override
  void onClose() {
    _generation++;
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
