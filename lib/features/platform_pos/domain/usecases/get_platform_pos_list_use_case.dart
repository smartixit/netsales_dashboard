import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/repositories/platform_pos_repository.dart';

class GetPlatformPosListUseCase {
  const GetPlatformPosListUseCase(this._repository);
  final PlatformPosRepository _repository;

  Future<ApiResponse<List<PlatformPosEntity>>> call({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) => _repository.getPosList(
    search: search,
    status: status,
    cursor: cursor,
    perPage: perPage,
  );
}
