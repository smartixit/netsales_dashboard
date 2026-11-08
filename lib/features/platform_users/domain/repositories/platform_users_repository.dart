import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

abstract interface class PlatformUsersRepository {
  Future<ApiResponse<List<PlatformUserEntity>>> getUsers({
    String? search, String? status, String? cursor, int perPage,
  });
}
