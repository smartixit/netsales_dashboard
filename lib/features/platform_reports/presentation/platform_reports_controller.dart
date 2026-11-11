import 'package:flutter/material.dart';
import 'package:document_engine/document_engine.dart';
import 'package:netsales_dashboard/features/platform_reports/domain/platform_report_engine_definition_factory.dart';
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
  final selectedReport = Rxn<PlatformReportCatalogItem>();
  final engineDefinition = Rxn<ReportDefinition>();
  final criteria = ReportCriteria().obs;
  final presentation = ReportPresentationOptions().obs;
  final Map<String, TextEditingController> filterControllers = {};
  final _definitionFactory = const PlatformReportEngineDefinitionFactory();

  @override
  void onClose() {
    for (final field in filterControllers.values) {
      field.dispose();
    }
    filterControllers.clear();
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

  void configure(PlatformReportCatalogItem report) {
    for (final field in filterControllers.values) {
      field.dispose();
    }
    filterControllers.clear();
    selectedReport.value = report;
    engineDefinition.value = _definitionFactory.create(report);
    criteria.value = ReportCriteria();
    presentation.value = ReportPresentationOptions();
    for (final filter in engineDefinition.value!.filters) {
      filterControllers[filter.id] = TextEditingController();
    }
  }

  TextEditingController textControllerFor(String id) =>
      filterControllers.putIfAbsent(id, TextEditingController.new);

  void updateCriteria(ReportCriteria value) => criteria.value = value;

  void updateFilter(String id, ReportFilterValue? value) {
    final next = Map<String, ReportFilterValue>.from(criteria.value.filters);
    if (value == null) {
      next.remove(id);
    } else {
      next[id] = value;
    }
    criteria.value = ReportCriteria(filters: next);
  }

  void updatePresentation(ReportPresentationOptions value) =>
      presentation.value = value;

  Future<void> createConfiguredReport() async {
    final report = selectedReport.value;
    final definition = engineDefinition.value;
    if (report == null || definition == null) return;
    if (criteria.value.validateAgainst(definition).isNotEmpty) {
      CustomSnackbar.show(
        title: 'مرشحات غير مكتملة',
        message: 'راجع الحقول المطلوبة وصيغ المرشحات قبل التنفيذ.',
        type: SnackType.warning,
      );
      return;
    }
    final filters = <String, dynamic>{
      for (final entry in criteria.value.filters.entries)
        entry.key: entry.value.jsonValue,
    };
    isCreating.value = true;
    try {
      activeRun.value = await repository.create(key: report.key, filters: filters);
      selectedReport.value = null;
      engineDefinition.value = null;
      CustomSnackbar.show(
        title: 'تم تسجيل التقرير',
        message: 'يمكن متابعة التنفيذ وتنزيل النتيجة بعد اكتمالها.',
        type: SnackType.success,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'تعذر إنشاء التقرير',
        message: e.toString(),
        type: SnackType.error,
      );
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
