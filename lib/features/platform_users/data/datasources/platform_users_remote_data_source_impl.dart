import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_role_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_detail_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_session_model.dart';

class PlatformUsersRemoteDataSourceImpl implements PlatformUsersRemoteDataSource {
  PlatformUsersRemoteDataSourceImpl({ApiService? apiService}) : _apiService = apiService ?? ApiService.instance;
  final ApiService _apiService;

  @override
  Future<ApiResponse<List<PlatformUserModel>>> getUsers({String? search, String? status, String? cursor, int perPage = 20}) =>
      _apiService.getList<PlatformUserModel>(ApiConstants.users,
        fromJson: (json) => PlatformUserModel.fromJson(Map<String, dynamic>.from(json as Map)),
        queryParameters: {if (search != null && search.trim().isNotEmpty) 'search': search.trim(), if (status != null && status.isNotEmpty) 'status': status},
        cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<PlatformUserDetailModel>> getUserDetail(int userId) =>
      _apiService.get<PlatformUserDetailModel>(ApiConstants.user(userId),
        fromJson: (json) => PlatformUserDetailModel.fromJson(Map<String, dynamic>.from(json as Map)));

  @override
  Future<ApiResponse<List<PlatformUserSessionModel>>> getUserSessions(int userId) =>
      _apiService.getList<PlatformUserSessionModel>(ApiConstants.securityUserSessions(userId),
        fromJson: (json) => PlatformUserSessionModel.fromJson(Map<String, dynamic>.from(json as Map)));

  @override
  Future<ApiResponse<List<PlatformRoleModel>>> getPlatformRoles() =>
      _apiService.getList<PlatformRoleModel>(ApiConstants.platformRoles,
        fromJson: (json) => PlatformRoleModel.fromJson(Map<String, dynamic>.from(json as Map)));

  @override
  Future<ApiResponse<PlatformUserModel>> createUser(Map<String, dynamic> data) =>
      _apiService.post<PlatformUserModel>(ApiConstants.users,
        data: data, fromJson: (json) => PlatformUserModel.fromJson(Map<String, dynamic>.from(json as Map)));

  @override
  Future<ApiResponse<PlatformUserModel>> updateUser(int userId, Map<String, dynamic> data) =>
      _apiService.put<PlatformUserModel>(ApiConstants.user(userId),
        data: data, fromJson: (json) => PlatformUserModel.fromJson(Map<String, dynamic>.from(json as Map)));

  @override
  Future<ApiResponse<PlatformUserModel>> updateUserStatus(int userId, String status) =>
      _apiService.post<PlatformUserModel>(ApiConstants.userStatus(userId),
        data: {'status': status}, fromJson: (json) => PlatformUserModel.fromJson(Map<String, dynamic>.from(json as Map)));
  @override
  Future<ApiResponse<dynamic>> terminateSession(int sessionId) =>
      _apiService.post<dynamic>(
        ApiConstants.securityTerminateSession(sessionId),
      );

  @override
  Future<ApiResponse<dynamic>> banUser(
    int userId, {
    required String type,
    required String reason,
    DateTime? endsAt,
  }) =>
      _apiService.post<dynamic>(
        ApiConstants.securityBanUser,
        data: {
          'user_id': userId,
          'ban_type': type,
          'ban_reason': reason,
          if (endsAt != null) 'end_at': endsAt.toIso8601String(),
        },
      );

  @override
  Future<ApiResponse<dynamic>> banDevice(
    int deviceId, {
    required String type,
    required String reason,
    DateTime? endsAt,
  }) =>
      _apiService.post<dynamic>(
        ApiConstants.securityBanDevice,
        data: {
          'device_id': deviceId,
          'ban_type': type,
          'ban_reason': reason,
          if (endsAt != null) 'end_at': endsAt.toIso8601String(),
        },
      );

  @override
  Future<ApiResponse<dynamic>> unban(int banId) =>
      _apiService.delete<dynamic>(ApiConstants.securityUnban(banId));

}
