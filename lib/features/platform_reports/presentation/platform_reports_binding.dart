import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_reports/data/platform_reports_repository.dart';
import 'package:netsales_dashboard/features/platform_reports/presentation/platform_reports_controller.dart';

class PlatformReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatformReportsRepository>(() => const PlatformReportsRepository());
    Get.lazyPut<PlatformReportsController>(
      () => PlatformReportsController(Get.find<PlatformReportsRepository>()),
    );
  }
}
