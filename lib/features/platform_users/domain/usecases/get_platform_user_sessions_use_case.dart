import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_session_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

/// استرجاع جلسات المستخدم وفق الصلاحيات التي يفرضها الخادم.
class GetPlatformUserSessionsUseCase {
  const GetPlatformUserSessionsUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<List<PlatformUserSessionEntity>> execute(int userId) {
    return _repository.getUserSessions(userId);
  }

  Future<List<PlatformUserSessionEntity>> call(int userId) =>
      execute(userId);
}
