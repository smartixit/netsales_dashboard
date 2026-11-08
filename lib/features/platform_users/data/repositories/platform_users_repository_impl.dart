import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

/// ينسق مصدر البيانات ويعيد النماذج باعتبارها كيانات Domain عبر الوراثة.
class PlatformUsersRepositoryImpl implements PlatformUsersRepository {
  const PlatformUsersRepositoryImpl(this._remoteDataSource);

  final PlatformUsersRemoteDataSource _remoteDataSource;

  @override
  Future<PlatformUserDetailEntity?> getUserDetail(int id) async {
    final response = await _remoteDataSource.getUserDetail(id);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data;
  }

  @override
  Future<List<PlatformUserSessionEntity>> getUserSessions(int id) async {
    final response = await _remoteDataSource.getUserSessions(id);
    if (!response.success) {
      throw Exception(response.message);
    }
    return response.data ?? const <PlatformUserSessionEntity>[];
  }

  @override
  Future<ApiResponse<List<PlatformUserEntity>>> getUsers({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) async {
    final response = await _remoteDataSource.getUsers(
      search: search,
      status: status,
      cursor: cursor,
      perPage: perPage,
    );

    return ApiResponse<List<PlatformUserEntity>>(
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
}
