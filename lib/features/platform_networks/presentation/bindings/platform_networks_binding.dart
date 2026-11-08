import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_networks/data/datasources/platform_networks_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_networks/data/datasources/platform_networks_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_networks/data/repositories/platform_networks_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/approve_platform_network_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_network_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_networks_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/reject_platform_network_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/update_platform_network_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/controllers/platform_network_detail_controller.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/controllers/platform_networks_controller.dart';

class PlatformNetworksBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlatformNetworksRemoteDataSource>()) {
      Get.lazyPut<PlatformNetworksRemoteDataSource>(
        PlatformNetworksRemoteDataSourceImpl.new,
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlatformNetworksRepository>()) {
      Get.lazyPut<PlatformNetworksRepository>(
        () => PlatformNetworksRepositoryImpl(
          Get.find<PlatformNetworksRemoteDataSource>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPlatformNetworksUseCase>()) {
      Get.lazyPut<GetPlatformNetworksUseCase>(
        () => GetPlatformNetworksUseCase(
          Get.find<PlatformNetworksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPlatformNetworkDetailUseCase>()) {
      Get.lazyPut<GetPlatformNetworkDetailUseCase>(
        () => GetPlatformNetworkDetailUseCase(
          Get.find<PlatformNetworksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<UpdatePlatformNetworkUseCase>()) {
      Get.lazyPut<UpdatePlatformNetworkUseCase>(
        () => UpdatePlatformNetworkUseCase(
          Get.find<PlatformNetworksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ApprovePlatformNetworkUseCase>()) {
      Get.lazyPut<ApprovePlatformNetworkUseCase>(
        () => ApprovePlatformNetworkUseCase(
          Get.find<PlatformNetworksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<RejectPlatformNetworkUseCase>()) {
      Get.lazyPut<RejectPlatformNetworkUseCase>(
        () => RejectPlatformNetworkUseCase(
          Get.find<PlatformNetworksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlatformNetworksController>()) {
      Get.lazyPut<PlatformNetworksController>(
        () => PlatformNetworksController(
          getNetworks: Get.find<GetPlatformNetworksUseCase>(),
          approveNetwork: Get.find<ApprovePlatformNetworkUseCase>(),
        ),
      );
    }
    if (!Get.isRegistered<PlatformNetworkDetailController>()) {
      Get.lazyPut<PlatformNetworkDetailController>(
        () => PlatformNetworkDetailController(
          getNetwork: Get.find<GetPlatformNetworkDetailUseCase>(),
          updateNetwork: Get.find<UpdatePlatformNetworkUseCase>(),
          approveNetwork: Get.find<ApprovePlatformNetworkUseCase>(),
          rejectNetwork: Get.find<RejectPlatformNetworkUseCase>(),
        ),
      );
    }
  }
}
