import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/repositories/platform_pos_repository.dart';

class GetPlatformPosDetailUseCase {
  const GetPlatformPosDetailUseCase(this._repository);
  final PlatformPosRepository _repository;

  Future<PlatformPosEntity> call(int posId) => _repository.getPos(posId);
}
