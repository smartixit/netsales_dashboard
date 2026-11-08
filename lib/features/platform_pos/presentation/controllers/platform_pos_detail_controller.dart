import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/approve_platform_pos_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/reject_platform_pos_use_case.dart';

class PlatformPosDetailController extends GetxController {
  PlatformPosDetailController({
    required GetPlatformPosDetailUseCase getPos,
    required ApprovePlatformPosUseCase approvePos,
    required RejectPlatformPosUseCase rejectPos,
  }) : _getPos = getPos,
       _approvePos = approvePos,
       _rejectPos = rejectPos;

  final GetPlatformPosDetailUseCase _getPos;
  final ApprovePlatformPosUseCase _approvePos;
  final RejectPlatformPosUseCase _rejectPos;

  final detail = Rxn<PlatformPosEntity>();
  final isLoading = true.obs;
  final isApproving = false.obs;
  final isRejecting = false.obs;
  final errorMessage = ''.obs;
  int _generation = 0;

  int get posId => int.tryParse(Get.parameters['id'] ?? '') ?? 0;

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
      if (posId <= 0) throw Exception('معرّف نقطة البيع غير صالح.');
      detail.value = await _getPos(posId);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      if (generation == _generation) isLoading.value = false;
    }
  }

  Future<void> approve() async {
    if (isApproving.value) return;
    isApproving.value = true;
    try {
      detail.value = await _approvePos(posId);
      await load();
    } finally {
      isApproving.value = false;
    }
  }

  Future<void> reject(String reason) async {
    if (isRejecting.value) return;
    isRejecting.value = true;
    try {
      detail.value = await _rejectPos(posId, reason: reason.trim());
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
