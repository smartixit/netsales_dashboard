import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';

abstract interface class PlatformPosRepository {
  Future<ApiResponse<List<PlatformPosEntity>>> getPosList({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<PlatformPosEntity> getPos(int posId);

  Future<PlatformPosEntity> updatePos(
    int posId, {
    required String name,
    required int governorateId,
    required int directorateId,
    String? email,
    String? address,
  });

  Future<PlatformPosEntity> approvePos(int posId);

  Future<PlatformPosEntity> rejectPos(int posId, {required String reason});
}
