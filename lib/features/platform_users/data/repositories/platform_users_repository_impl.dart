import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class PlatformUsersRepositoryImpl implements PlatformUsersRepository {
  const PlatformUsersRepositoryImpl(this._remoteDataSource);
  final PlatformUsersRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResponse<List<PlatformUserEntity>>> getUsers({
    String? search, String? status, String? cursor, int perPage = 20,
  }) async {
    final response = await _remoteDataSource.getUsers(
      search: search, status: status, cursor: cursor, perPage: perPage,
    );
    return ApiResponse<List<PlatformUserEntity>>(
      success: response.success,
      message: response.message,
      data: response.data?.map((model) => model.toEntity()).toList(growable: false),
      errors: response.errors,
      nextCursor: response.nextCursor,
      prevCursor: response.prevCursor,
      meta: response.meta,
      isIdempotentHit: response.isIdempotentHit,
      idempotencyKey: response.idempotencyKey,
    );
  }
}
