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
  final networkIdController = ''.obs;
  final accountIdController = ''.obs;
  final currencyIdController = ''.obs;
  final statusController = ''.obs;
  final searchController = ''.obs;

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
    final filters = <String, dynamic>{
      if (networkIdController.value.trim().isNotEmpty) 'network_id': int.tryParse(networkIdController.value.trim()),
      if (accountIdController.value.trim().isNotEmpty) 'billing_account_id': int.tryParse(accountIdController.value.trim()),
      if (currencyIdController.value.trim().isNotEmpty) 'currency_id': int.tryParse(currencyIdController.value.trim()),
      if (statusController.value.trim().isNotEmpty) 'status': statusController.value.trim(),
      if (searchController.value.trim().isNotEmpty) 'search': searchController.value.trim(),
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
