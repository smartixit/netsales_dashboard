import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class GetPlatformUsersUseCase {
  const GetPlatformUsersUseCase(this._repository);
  final PlatformUsersRepository _repository;

  Future<ApiResponse<List<PlatformUserEntity>>> call({
    String? search, String? status, String? cursor, int perPage = 20,
  }) => _repository.getUsers(
    search: search, status: status, cursor: cursor, perPage: perPage,
  );
}
