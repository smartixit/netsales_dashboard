import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_pos/data/datasources/platform_pos_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_pos/data/datasources/platform_pos_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_pos/data/repositories/platform_pos_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/repositories/platform_pos_repository.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/approve_platform_pos_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_list_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/reject_platform_pos_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/controllers/platform_pos_controller.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/controllers/platform_pos_detail_controller.dart';

class PlatformPosBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlatformPosRemoteDataSource>()) {
      Get.lazyPut<PlatformPosRemoteDataSource>(
        PlatformPosRemoteDataSourceImpl.new,
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlatformPosRepository>()) {
      Get.lazyPut<PlatformPosRepository>(
        () => PlatformPosRepositoryImpl(
          Get.find<PlatformPosRemoteDataSource>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPlatformPosListUseCase>()) {
      Get.lazyPut<GetPlatformPosListUseCase>(
        () => GetPlatformPosListUseCase(Get.find<PlatformPosRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPlatformPosDetailUseCase>()) {
      Get.lazyPut<GetPlatformPosDetailUseCase>(
        () => GetPlatformPosDetailUseCase(Get.find<PlatformPosRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ApprovePlatformPosUseCase>()) {
      Get.lazyPut<ApprovePlatformPosUseCase>(
        () => ApprovePlatformPosUseCase(Get.find<PlatformPosRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<RejectPlatformPosUseCase>()) {
      Get.lazyPut<RejectPlatformPosUseCase>(
        () => RejectPlatformPosUseCase(Get.find<PlatformPosRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlatformPosController>(
      () => PlatformPosController(getPos: Get.find<GetPlatformPosListUseCase>()),
    );
    if (!Get.isRegistered<PlatformPosDetailController>()) {
      Get.lazyPut<PlatformPosDetailController>(
        () => PlatformPosDetailController(
          getPos: Get.find<GetPlatformPosDetailUseCase>(),
          approvePos: Get.find<ApprovePlatformPosUseCase>(),
          rejectPos: Get.find<RejectPlatformPosUseCase>(),
        ),
      );
    }
  }
}
