import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class PlatformUsersRepositoryImpl implements PlatformUsersRepository {
  const PlatformUsersRepositoryImpl(this._remoteDataSource);

  final PlatformUsersRemoteDataSource _remoteDataSource;

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

  @override
  Future<PlatformUserDetailEntity?> getUserDetail(int id) async {
    final response = await _remoteDataSource.getUserDetail(id);
    if (!response.success || response.data == null) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'تعذر تحميل تفاصيل المستخدم.',
      );
    }
    return response.data;
  }

  @override
  Future<List<PlatformUserSessionEntity>> getUserSessions(int id) async {
    final response = await _remoteDataSource.getUserSessions(id);
    if (!response.success) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'تعذر تحميل جلسات المستخدم.',
      );
    }
    return response.data ?? const <PlatformUserSessionEntity>[];
  }

  @override
  Future<List<PlatformRoleEntity>> getPlatformRoles() async {
    final response = await _remoteDataSource.getPlatformRoles();
    if (!response.success || response.data == null) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'تعذر تحميل أدوار المنصة.',
      );
    }
    return response.data!;
  }

  @override
  Future<PlatformUserEntity> createUser(Map<String, dynamic> data) async {
    final response = await _remoteDataSource.createUser(data);
    if (!response.success || response.data == null) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'تعذر إنشاء المستخدم.',
      );
    }
    return response.data!;
  }

  @override
  Future<PlatformUserEntity> updateUser(
    int userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _remoteDataSource.updateUser(userId, data);
    if (!response.success || response.data == null) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'تعذر تحديث المستخدم.',
      );
    }
    return response.data!;
  }

  @override
  Future<PlatformUserEntity> updateUserStatus(
    int userId,
    String status,
  ) async {
    final response = await _remoteDataSource.updateUserStatus(userId, status);
    if (!response.success || response.data == null) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'تعذر تحديث حالة المستخدم.',
      );
    }
    return response.data!;
  }
}
