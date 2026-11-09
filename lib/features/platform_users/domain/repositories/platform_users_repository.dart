import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

abstract interface class PlatformUsersRepository {
  Future<ApiResponse<List<PlatformUserEntity>>> getUsers({
    String? search, String? status, String? cursor, int perPage,
  });
  Future<PlatformUserDetailEntity?> getUserDetail(int id);
  Future<List<PlatformUserSessionEntity>> getUserSessions(int id);
  Future<List<PlatformRoleEntity>> getPlatformRoles();
  Future<PlatformUserEntity> createUser(Map<String, dynamic> data);
  Future<PlatformUserEntity> updateUser(int userId, Map<String, dynamic> data);
  Future<PlatformUserEntity> updateUserStatus(int userId, String status);
}
