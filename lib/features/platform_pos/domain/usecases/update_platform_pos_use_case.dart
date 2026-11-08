import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/repositories/platform_pos_repository.dart';

class UpdatePlatformPosUseCase {
  const UpdatePlatformPosUseCase(this._repository);
  final PlatformPosRepository _repository;

  Future<PlatformPosEntity> call(
    int posId, {
    required String name,
    required int governorateId,
    required int directorateId,
    String? email,
    String? address,
  }) => _repository.updatePos(
    posId,
    name: name,
    governorateId: governorateId,
    directorateId: directorateId,
    email: email,
    address: address,
  );
}
