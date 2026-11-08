import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/locale_service.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/create_platform_network_pos_link_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/delete_platform_network_pos_link_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/get_platform_network_pos_links_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/update_platform_network_pos_link_status_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/widgets/platform_network_pos_link_grid_columns.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_networks_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_list_use_case.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/net_sales_data_grid_source.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/app_data_grid_export_controller.dart';

class PlatformNetworkPosLinksController extends GetxController {
  PlatformNetworkPosLinksController({
    required GetPlatformNetworkPosLinksUseCase getLinks,
    required CreatePlatformNetworkPosLinkUseCase createLink,
    required UpdatePlatformNetworkPosLinkStatusUseCase updateStatus,
    required DeletePlatformNetworkPosLinkUseCase deleteLink,
    required GetPlatformNetworksUseCase getNetworks,
    required GetPlatformPosListUseCase getPos,
  }) : _getLinks = getLinks,
       _createLink = createLink,
       _updateStatus = updateStatus,
       _deleteLink = deleteLink,
       _getNetworks = getNetworks,
       _getPos = getPos;

  final GetPlatformNetworkPosLinksUseCase _getLinks;
  final CreatePlatformNetworkPosLinkUseCase _createLink;
  final UpdatePlatformNetworkPosLinkStatusUseCase _updateStatus;
  final DeletePlatformNetworkPosLinkUseCase _deleteLink;
  final GetPlatformNetworksUseCase _getNetworks;
  final GetPlatformPosListUseCase _getPos;

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final statusFilter = ''.obs;
  final networkFilterId = Rxn<int>();
  final posFilterId = Rxn<int>();
  final links = <PlatformNetworkPosLinkEntity>[].obs;
  final networks = <PlatformNetworkEntity>[].obs;
  final pointsOfSale = <PlatformPosEntity>[].obs;
  final selectedNetworkListenable = ValueNotifier<int?>(null);
  final selectedPosListenable = ValueNotifier<int?>(null);
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final isLoadingOptions = false.obs;
  final networkOptionsSearching = ValueNotifier<bool>(false);
  final posOptionsSearching = ValueNotifier<bool>(false);
  final exportController = AppDataGridExportController();
  final isMutating = false.obs;
  final errorMessage = ''.obs;
  final hasMore = false.obs;

  late final NetSalesDataGridSource<PlatformNetworkPosLinkEntity> dataSource;
  String? _nextCursor;
  Timer? _debounce;
  int _requestGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    dataSource = NetSalesDataGridSource<PlatformNetworkPosLinkEntity>(
      items: const [],
      columns: PlatformNetworkPosLinkGridColumns.build(
        AppLocalizations(LocaleService.to.locale),
      ),
    );
    load();
    loadSelectionOptions();
  }

  Future<void> load({bool reset = true}) async {
    final generation = ++_requestGeneration;
    if (reset) {
      isLoading.value = true;
      _nextCursor = null;
    }
    errorMessage.value = '';
    try {
      final response = await _getLinks(
        search: searchQuery.value,
        networkId: networkFilterId.value,
        posId: posFilterId.value,
        status: statusFilter.value.isEmpty ? null : statusFilter.value,
        cursor: reset ? null : _nextCursor,
      );
      if (generation != _requestGeneration) return;
      if (!response.success) throw Exception(response.message);
      final page = response.data ?? const <PlatformNetworkPosLinkEntity>[];
      if (reset) {
        links.assignAll(page);
        dataSource.replaceRows(page);
      } else {
        links.addAll(page);
        dataSource.appendRows(page);
      }
      _nextCursor = response.nextCursor;
      hasMore.value = _nextCursor != null && _nextCursor!.isNotEmpty;
      dataSource.setHasMore(hasMore.value);
    } catch (error) {
      if (generation == _requestGeneration) {
        errorMessage.value = error.toString();
      }
    } finally {
      if (generation == _requestGeneration) {
        isLoading.value = false;
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || _nextCursor == null) return;
    isLoadingMore.value = true;
    await load(reset: false);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => load());
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
  }

  void applyFilters({String? status, int? networkId, int? posId}) {
    statusFilter.value = status ?? '';
    networkFilterId.value = networkId;
    posFilterId.value = posId;
    load();
  }

  String networkNameFor(int id) {
    for (final network in networks) {
      if (network.id == id) return network.name;
    }
    return '';
  }

  String posNameFor(int id) {
    for (final pos in pointsOfSale) {
      if (pos.id == id) return pos.name;
    }
    return '';
  }

  Future<void> searchNetworkOptions(String query) async {
    networkOptionsSearching.value = true;
    try {
      final response = await _getNetworks(search: query, perPage: 50);
      if (response.success) {
        networks.assignAll(response.data?.where((item) => item.status == 'ACTIVE').toList() ?? const <PlatformNetworkEntity>[]);
      }
    } finally {
      networkOptionsSearching.value = false;
    }
  }

  Future<void> searchPosOptions(String query) async {
    posOptionsSearching.value = true;
    try {
      final response = await _getPos(search: query, perPage: 50);
      if (response.success) {
        pointsOfSale.assignAll(response.data?.where((item) => item.status == 'ACTIVE').toList() ?? const <PlatformPosEntity>[]);
      }
    } finally {
      posOptionsSearching.value = false;
    }
  }

  Future<void> loadSelectionOptions() async {
    isLoadingOptions.value = true;
    try {
      final networkResponse = await _getNetworks(perPage: 50);
      if (networkResponse.success) {
        networks.assignAll(
          networkResponse.data?.where((item) => item.status == 'ACTIVE').toList() ??
              const <PlatformNetworkEntity>[],
        );
      }
      final posResponse = await _getPos(perPage: 50);
      if (posResponse.success) {
        pointsOfSale.assignAll(
          posResponse.data?.where((item) => item.status == 'ACTIVE').toList() ??
              const <PlatformPosEntity>[],
        );
      }
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoadingOptions.value = false;
    }
  }

  Future<void> create() async {
    final networkId = selectedNetworkListenable.value;
    final posId = selectedPosListenable.value;
    if (isMutating.value || networkId == null || posId == null) return;
    isMutating.value = true;
    try {
      await _createLink(networkId: networkId, posId: posId);
      selectedNetworkListenable.value = null;
      selectedPosListenable.value = null;
      await loadSelectionOptions();
      await load();
    } finally {
      isMutating.value = false;
    }
  }

  Future<void> setStatus(
    PlatformNetworkPosLinkEntity link, {
    required bool isActive,
  }) async {
    if (isMutating.value) return;
    isMutating.value = true;
    try {
      await _updateStatus(linkId: link.id, isActive: isActive);
      await load();
    } finally {
      isMutating.value = false;
    }
  }

  Future<void> unlink(PlatformNetworkPosLinkEntity link) async {
    if (isMutating.value) return;
    isMutating.value = true;
    try {
      await _deleteLink(link.id);
      await load();
    } finally {
      isMutating.value = false;
    }
  }

  @override
  void onClose() {
    _requestGeneration++;
    _debounce?.cancel();
    searchController.dispose();
    selectedNetworkListenable.dispose();
    selectedPosListenable.dispose();
    networkOptionsSearching.dispose();
    posOptionsSearching.dispose();
    super.onClose();
  }
}
