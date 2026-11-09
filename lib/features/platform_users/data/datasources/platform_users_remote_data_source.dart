import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_role_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_detail_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_session_model.dart';

abstract interface class PlatformUsersRemoteDataSource {
  Future<ApiResponse<List<PlatformUserModel>>> getTrashedUsers({String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<dynamic>> restoreUser(int userId);
  Future<ApiResponse<dynamic>> forceDeleteUser(int userId);
  Future<ApiResponse<List<PlatformUserModel>>> getUsers({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });
  Future<ApiResponse<PlatformUserDetailModel>> getUserDetail(int userId);
  Future<ApiResponse<List<PlatformUserSessionModel>>> getUserSessions(int userId);
  Future<ApiResponse<List<PlatformRoleModel>>> getPlatformRoles();
  Future<ApiResponse<PlatformUserModel>> createUser(Map<String, dynamic> data);
  Future<ApiResponse<PlatformUserModel>> updateUser(int userId, Map<String, dynamic> data);
  Future<ApiResponse<PlatformUserModel>> updateUserStatus(int userId, String status);
  Future<ApiResponse<dynamic>> terminateSession(int sessionId);
  Future<ApiResponse<dynamic>> banUser(int userId, {required String type, required String reason, DateTime? endsAt});
  Future<ApiResponse<dynamic>> banDevice(int deviceId, {required String type, required String reason, DateTime? endsAt});
  Future<ApiResponse<dynamic>> unban(int banId);
}
