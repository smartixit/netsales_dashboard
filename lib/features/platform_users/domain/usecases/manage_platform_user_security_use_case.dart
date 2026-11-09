import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class ManagePlatformUserSecurityUseCase {
  const ManagePlatformUserSecurityUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<void> terminateSession(int sessionId) =>
      _repository.terminateSession(sessionId);

  Future<void> banUser(
    int userId, {
    required String type,
    required String reason,
  }) => _repository.banUser(userId, type: type, reason: reason);

  Future<void> banDevice(
    int deviceId, {
    required String type,
    required String reason,
  }) => _repository.banDevice(deviceId, type: type, reason: reason);

  Future<void> unban(int banId) => _repository.unban(banId);
}
