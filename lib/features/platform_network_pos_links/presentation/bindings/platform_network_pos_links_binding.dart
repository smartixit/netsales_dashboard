import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/datasources/platform_network_pos_links_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/datasources/platform_network_pos_links_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/repositories/platform_network_pos_links_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/create_platform_network_pos_link_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/delete_platform_network_pos_link_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/get_platform_network_pos_links_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/get_platform_network_pos_link_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/update_platform_network_pos_link_status_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/controllers/platform_network_pos_links_controller.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_networks_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_list_use_case.dart';

class PlatformNetworkPosLinksBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlatformNetworkPosLinksRemoteDataSource>()) {
      Get.lazyPut<PlatformNetworkPosLinksRemoteDataSource>(
        PlatformNetworkPosLinksRemoteDataSourceImpl.new,
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlatformNetworkPosLinksRepository>()) {
      Get.lazyPut<PlatformNetworkPosLinksRepository>(
        () => PlatformNetworkPosLinksRepositoryImpl(
          Get.find<PlatformNetworkPosLinksRemoteDataSource>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPlatformNetworkPosLinksUseCase>()) {
      Get.lazyPut<GetPlatformNetworkPosLinksUseCase>(
        () => GetPlatformNetworkPosLinksUseCase(
          Get.find<PlatformNetworkPosLinksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetPlatformNetworkPosLinkDetailUseCase>()) {
      Get.lazyPut<GetPlatformNetworkPosLinkDetailUseCase>(
        () => GetPlatformNetworkPosLinkDetailUseCase(
          Get.find<PlatformNetworkPosLinksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<CreatePlatformNetworkPosLinkUseCase>()) {
      Get.lazyPut<CreatePlatformNetworkPosLinkUseCase>(
        () => CreatePlatformNetworkPosLinkUseCase(
          Get.find<PlatformNetworkPosLinksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<UpdatePlatformNetworkPosLinkStatusUseCase>()) {
      Get.lazyPut<UpdatePlatformNetworkPosLinkStatusUseCase>(
        () => UpdatePlatformNetworkPosLinkStatusUseCase(
          Get.find<PlatformNetworkPosLinksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<DeletePlatformNetworkPosLinkUseCase>()) {
      Get.lazyPut<DeletePlatformNetworkPosLinkUseCase>(
        () => DeletePlatformNetworkPosLinkUseCase(
          Get.find<PlatformNetworkPosLinksRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlatformNetworkPosLinksController>()) {
      Get.lazyPut<PlatformNetworkPosLinksController>(
        () => PlatformNetworkPosLinksController(
          getLinks: Get.find<GetPlatformNetworkPosLinksUseCase>(),
          createLink: Get.find<CreatePlatformNetworkPosLinkUseCase>(),
          updateStatus: Get.find<UpdatePlatformNetworkPosLinkStatusUseCase>(),
          deleteLink: Get.find<DeletePlatformNetworkPosLinkUseCase>(),
          getNetworks: Get.find<GetPlatformNetworksUseCase>(),
          getPos: Get.find<GetPlatformPosListUseCase>(),
        ),
      );
    }
  }
}
