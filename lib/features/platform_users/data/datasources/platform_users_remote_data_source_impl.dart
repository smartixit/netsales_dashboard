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
}
