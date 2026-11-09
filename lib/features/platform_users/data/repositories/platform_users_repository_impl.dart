import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class PlatformUsersRepositoryImpl implements PlatformUsersRepository {
  PlatformUsersRepositoryImpl(this._remote);
  final PlatformUsersRemoteDataSource _remote;

  @override
  Future<ApiResponse<List<PlatformUserEntity>>> getUsers({String? search, String? status, String? cursor, int perPage = 20}) async {
    final response = await _remote.getUsers(search: search, status: status, cursor: cursor, perPage: perPage);
    return ApiResponse<List<PlatformUserEntity>>(success: response.success, message: response.message, data: response.data, errors: response.errors, nextCursor: response.nextCursor, prevCursor: response.prevCursor, meta: response.meta);
  }
  @override
  Future<PlatformUserDetailEntity?> getUserDetail(int id) => _remote.getUserDetail(id).then((r) => r.data);
  @override
  Future<List<PlatformUserSessionEntity>> getUserSessions(int id) async => (await _remote.getUserSessions(id)).data ?? [];
  @override
  Future<List<PlatformRoleEntity>> getPlatformRoles() async {
    final r = await _remote.getPlatformRoles();
    if (!r.success || r.data == null) throw Exception(r.message.isEmpty ? 'تعذر تحميل أدوار المنصة.' : r.message);
    return r.data!;
  }
  @override
  Future<PlatformUserEntity> createUser(Map<String, dynamic> data) async {
    final r = await _remote.createUser(data);
    if (!r.success || r.data == null) throw Exception(r.message.isEmpty ? 'تعذر إنشاء المستخدم.' : r.message);
    return r.data!;
  }
  @override
  Future<PlatformUserEntity> updateUser(int id, Map<String, dynamic> data) async {
    final r = await _remote.updateUser(id, data);
    if (!r.success || r.data == null) throw Exception(r.message.isEmpty ? 'تعذر تحديث المستخدم.' : r.message);
    return r.data!;
  }
  @override
  Future<PlatformUserEntity> updateUserStatus(int id, String status) async {
    final r = await _remote.updateUserStatus(id, status);
    if (!r.success || r.data == null) throw Exception(r.message.isEmpty ? 'تعذر تحديث حالة المستخدم.' : r.message);
    return r.data!;
  }
}
