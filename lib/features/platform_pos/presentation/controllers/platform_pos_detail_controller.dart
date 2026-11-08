import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/approve_platform_pos_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/get_platform_pos_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/reject_platform_pos_use_case.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/usecases/update_platform_pos_use_case.dart';

class PlatformPosDetailController extends GetxController {
  PlatformPosDetailController({
    required this._getPos,
    required this._approvePos,
    required this._rejectPos,
    required this._updatePos,
  });

  final GetPlatformPosDetailUseCase _getPos;
  final ApprovePlatformPosUseCase _approvePos;
  final RejectPlatformPosUseCase _rejectPos;
  final UpdatePlatformPosUseCase _updatePos;

  final detail = Rxn<PlatformPosEntity>();
  final isLoading = true.obs;
  final isSaving = false.obs;
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

  Future<void> save({
    required String name,
    required String email,
    required String address,
  }) async {
    final current = detail.value;
    if (isSaving.value || current == null) return;
    final governorateId = current.governorateId;
    final directorateId = current.directorateId;
    if (governorateId == null || directorateId == null) {
      throw Exception('لا يمكن تعديل نقطة البيع قبل توفر بيانات المحافظة والمديرية.');
    }
    isSaving.value = true;
    try {
      detail.value = await _updatePos(
        posId,
        name: name.trim(),
        governorateId: governorateId,
        directorateId: directorateId,
        email: email.trim().isEmpty ? null : email.trim(),
        address: address.trim().isEmpty ? null : address.trim(),
      );
      await load();
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> approve() async {
    if (isApproving.value) return;
    isApproving.value = true;
    try {
      await _approvePos(posId);
      await load();
    } finally {
      isApproving.value = false;
    }
  }

  Future<void> reject(String reason) async {
    if (isRejecting.value) return;
    isRejecting.value = true;
    try {
      await _rejectPos(posId, reason: reason.trim());
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
