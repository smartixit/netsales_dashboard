import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_reports/data/platform_reports_repository.dart';
import 'package:netsales_dashboard/features/platform_reports/domain/entities/platform_report_models.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

class PlatformReportsController extends GetxController {
  PlatformReportsController(this.repository);
  final PlatformReportsRepository repository;

  final catalog = <PlatformReportCatalogItem>[].obs;
  final activeRun = Rxn<PlatformReportRun>();
  final isLoading = false.obs;
  final isCreating = false.obs;
  final isRefreshing = false.obs;
  final isDownloading = false.obs;
  final error = RxnString();
  final networkIdController = TextEditingController();
  final accountIdController = TextEditingController();
  final currencyIdController = TextEditingController();
  final statusController = TextEditingController();
  final searchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  void onClose() {
    networkIdController.dispose();
    accountIdController.dispose();
    currencyIdController.dispose();
    statusController.dispose();
    searchController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    isLoading.value = true;
    error.value = null;
    try {
      catalog.assignAll(await repository.catalog());
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> create(PlatformReportCatalogItem report) async {
    final availableFilters = report.filters.keys.toSet();
    final filters = <String, dynamic>{
      if (availableFilters.contains('network_id') &&
          networkIdController.text.trim().isNotEmpty)
        'network_id': int.tryParse(networkIdController.text.trim()),
      if (availableFilters.contains('billing_account_id') &&
          accountIdController.text.trim().isNotEmpty)
        'billing_account_id': int.tryParse(accountIdController.text.trim()),
      if (availableFilters.contains('currency_id') &&
          currencyIdController.text.trim().isNotEmpty)
        'currency_id': int.tryParse(currencyIdController.text.trim()),
      if (availableFilters.contains('status') &&
          statusController.text.trim().isNotEmpty)
        'status': statusController.text.trim(),
      if (availableFilters.contains('search') &&
          searchController.text.trim().isNotEmpty)
        'search': searchController.text.trim(),
      if (availableFilters.contains('from') && fromDateController.text.trim().isNotEmpty)
        'from': fromDateController.text.trim(),
      if (availableFilters.contains('to') && toDateController.text.trim().isNotEmpty)
        'to': toDateController.text.trim(),
      if (availableFilters.contains('from_date') && fromDateController.text.trim().isNotEmpty)
        'from_date': fromDateController.text.trim(),
      if (availableFilters.contains('to_date') && toDateController.text.trim().isNotEmpty)
        'to_date': toDateController.text.trim(),
    }..removeWhere((key, value) => value == null);
    isCreating.value = true;
    try {
      activeRun.value = await repository.create(key: report.key, filters: filters);
      CustomSnackbar.show(title: 'تم تسجيل التقرير', message: 'يمكن متابعة التنفيذ وتنزيل النتيجة بعد اكتمالها.', type: SnackType.success);
    } catch (e) {
      CustomSnackbar.show(title: 'تعذر إنشاء التقرير', message: e.toString(), type: SnackType.error);
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> refreshRun() async {
    final run = activeRun.value;
    if (run == null) return;
    isRefreshing.value = true;
    try {
      activeRun.value = await repository.refresh(run.id);
    } catch (e) {
      CustomSnackbar.show(title: 'تعذر تحديث الحالة', message: e.toString(), type: SnackType.error);
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> downloadRun() async {
    final run = activeRun.value;
    if (run == null) return;
    isDownloading.value = true;
    try {
      await repository.download(run);
    } catch (e) {
      CustomSnackbar.show(title: 'تعذر التنزيل', message: e.toString(), type: SnackType.error);
    } finally {
      isDownloading.value = false;
    }
  }
}
