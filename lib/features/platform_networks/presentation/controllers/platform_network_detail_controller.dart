import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/approve_platform_network_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/get_platform_network_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/reject_platform_network_use_case.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/usecases/update_platform_network_use_case.dart';

class PlatformNetworkDetailController extends GetxController {
  PlatformNetworkDetailController({
    required this._getNetwork,
    required this._updateNetwork,
    required this._approveNetwork,
    required this._rejectNetwork,
  });

  final GetPlatformNetworkDetailUseCase _getNetwork;
  final UpdatePlatformNetworkUseCase _updateNetwork;
  final ApprovePlatformNetworkUseCase _approveNetwork;
  final RejectPlatformNetworkUseCase _rejectNetwork;

  final network = Rxn<PlatformNetworkEntity>();
  final isLoading = true.obs;
  final isSaving = false.obs;
  final isApproving = false.obs;
  final isRejecting = false.obs;
  final errorMessage = ''.obs;
  int _generation = 0;

  int get networkId => int.tryParse(Get.parameters['id'] ?? '') ?? 0;

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
      if (networkId <= 0) throw Exception('معرّف الشبكة غير صالح.');
      network.value = await _getNetwork(networkId);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      if (generation == _generation) isLoading.value = false;
    }
  }

  Future<void> save({
    required String name,
    required String address,
  }) async {
    if (isSaving.value || network.value == null) return;
    isSaving.value = true;
    try {
      final updated = await _updateNetwork(
        networkId,
        name: name.trim(),
        address: address.trim().isEmpty ? null : address.trim(),
      );
      network.value = updated;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> approve() async {
    if (isApproving.value) return;
    isApproving.value = true;
    try {
      await _approveNetwork(networkId);
      await load();
    } finally {
      isApproving.value = false;
    }
  }

  Future<void> reject(String reason) async {
    if (isRejecting.value) return;
    isRejecting.value = true;
    try {
      await _rejectNetwork(networkId, reason: reason.trim());
      await load();
    } finally {
      isRejecting.value = false;
    }
  }

  @override
  void onClose() {
    _generation++;
    super.onClose();
  }
}
