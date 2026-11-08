import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/delete_platform_network_pos_link_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/get_platform_network_pos_link_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/update_platform_network_pos_link_status_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/controllers/platform_network_pos_link_detail_controller.dart';

class PlatformNetworkPosLinkDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatformNetworkPosLinkDetailController>(
      () => PlatformNetworkPosLinkDetailController(
        getLink: Get.find<GetPlatformNetworkPosLinkDetailUseCase>(),
        updateStatus: Get.find<UpdatePlatformNetworkPosLinkStatusUseCase>(),
        deleteLink: Get.find<DeletePlatformNetworkPosLinkUseCase>(),
      ),
    );
  }
}
