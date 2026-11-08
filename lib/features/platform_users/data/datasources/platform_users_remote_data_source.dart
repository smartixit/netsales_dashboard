import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/models/user_model.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';

abstract interface class PlatformUsersRemoteDataSource {
  Future<ApiResponse<List<UserModel>>> getUsers({
    String? search, String? status, String? cursor, int perPage,
  });
}

class PlatformUsersRemoteDataSourceImpl implements PlatformUsersRemoteDataSource {
  PlatformUsersRemoteDataSourceImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService.instance;

  final ApiService _apiService;

  @override
  Future<ApiResponse<List<UserModel>>> getUsers({
    String? search, String? status, String? cursor, int perPage = 20,
  }) {
    return _apiService.getList<UserModel>(
      ApiConstants.users,
      fromJson: (json) => UserModel.fromJson(Map<String, dynamic>.from(json as Map)),
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (status != null && status.isNotEmpty) 'status': status,
      },
      cursor: cursor,
      perPage: perPage,
    );
  }
}
