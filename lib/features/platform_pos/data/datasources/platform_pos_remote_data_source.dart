import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_pos/data/models/platform_pos_model.dart';

abstract interface class PlatformPosRemoteDataSource {
  Future<ApiResponse<List<PlatformPosModel>>> getPosList({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<ApiResponse<PlatformPosModel>> getPos(int posId);

  Future<ApiResponse<PlatformPosModel>> updatePos(
    int posId, {
    required String name,
    required int governorateId,
    required int directorateId,
    String? email,
    String? address,
  });

  Future<ApiResponse<PlatformPosModel>> approvePos(int posId);

  Future<ApiResponse<PlatformPosModel>> rejectPos(
    int posId, {
    required String reason,
  });
}
