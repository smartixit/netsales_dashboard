import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/models/user_model.dart';

abstract interface class PlatformUsersRepository {
  Future<ApiResponse<List<UserModel>>> getUsers({
    String? search, String? status, String? cursor, int perPage,
  });
}
