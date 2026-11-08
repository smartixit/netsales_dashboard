import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_pos/data/datasources/platform_pos_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/repositories/platform_pos_repository.dart';

/// Repository exposes inherited Data Models as Domain entities without mapping.
class PlatformPosRepositoryImpl implements PlatformPosRepository {
  const PlatformPosRepositoryImpl(this._remoteDataSource);

  final PlatformPosRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResponse<List<PlatformPosEntity>>> getPosList({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) async {
    final response = await _remoteDataSource.getPosList(
      search: search,
      status: status,
      cursor: cursor,
      perPage: perPage,
    );
    return ApiResponse<List<PlatformPosEntity>>(
      success: response.success,
      message: response.message,
      data: response.data,
      errors: response.errors,
      nextCursor: response.nextCursor,
      prevCursor: response.prevCursor,
      meta: response.meta,
      isIdempotentHit: response.isIdempotentHit,
      idempotencyKey: response.idempotencyKey,
    );
  }

  @override
  Future<PlatformPosEntity> getPos(int posId) async {
    final response = await _remoteDataSource.getPos(posId);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<PlatformPosEntity> updatePos(
    int posId, {
    required String name,
    required int governorateId,
    required int directorateId,
    String? email,
    String? address,
  }) async {
    final response = await _remoteDataSource.updatePos(
      posId,
      name: name,
      governorateId: governorateId,
      directorateId: directorateId,
      email: email,
      address: address,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<PlatformPosEntity> approvePos(int posId) async {
    final response = await _remoteDataSource.approvePos(posId);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<PlatformPosEntity> rejectPos(int posId, {required String reason}) async {
    final response = await _remoteDataSource.rejectPos(posId, reason: reason);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }
}
