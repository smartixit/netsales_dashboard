import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/delete_platform_network_pos_link_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/get_platform_network_pos_link_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/usecases/update_platform_network_pos_link_status_use_case.dart';

class PlatformNetworkPosLinkDetailController extends GetxController {
  PlatformNetworkPosLinkDetailController({
    required this._getLink,
    required this._updateStatus,
    required this._deleteLink,
  });

  final GetPlatformNetworkPosLinkDetailUseCase _getLink;
  final UpdatePlatformNetworkPosLinkStatusUseCase _updateStatus;
  final DeletePlatformNetworkPosLinkUseCase _deleteLink;

  final link = Rxn<PlatformNetworkPosLinkEntity>();
  final isLoading = true.obs;
  final isMutating = false.obs;
  final errorMessage = ''.obs;
  int _generation = 0;

  int get linkId => int.tryParse(Get.parameters['id'] ?? '') ?? 0;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final generation = ++_generation;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      if (linkId <= 0) throw Exception('Invalid relationship identifier.');
      link.value = await _getLink(linkId);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      if (generation == _generation) isLoading.value = false;
    }
  }

  Future<void> setStatus(bool active) async {
    if (isMutating.value) return;
    isMutating.value = true;
    try {
      link.value = await _updateStatus(linkId: linkId, isActive: active);
    } finally {
      isMutating.value = false;
    }
  }

  Future<void> unlink() async {
    if (isMutating.value) return;
    isMutating.value = true;
    try {
      await _deleteLink(linkId);
    } finally {
      isMutating.value = false;
    }
  }

  @override
  void onClose() {
    _generation++;
    super.onClose();
  }
}
