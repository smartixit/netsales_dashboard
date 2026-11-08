import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class GetPlatformUserSessionsUseCase {
  const GetPlatformUserSessionsUseCase(this._repository);
  final PlatformUsersRepository _repository;
  Future<List<PlatformUserSessionEntity>> call(int id) =>
      _repository.getUserSessions(id);
}
