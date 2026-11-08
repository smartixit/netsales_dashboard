import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/models/user_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class PlatformUsersRepositoryImpl implements PlatformUsersRepository {
  const PlatformUsersRepositoryImpl(this._remoteDataSource);
  final PlatformUsersRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResponse<List<UserModel>>> getUsers({
    String? search, String? status, String? cursor, int perPage = 20,
  }) => _remoteDataSource.getUsers(
    search: search, status: status, cursor: cursor, perPage: perPage,
  );
}
