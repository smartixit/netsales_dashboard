import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class RecoverPlatformUserUseCase {
  const RecoverPlatformUserUseCase(this._repository);
  final PlatformUsersRepository _repository;
  Future<void> softDelete(int userId) => _repository.deleteUser(userId);
  Future<void> restore(int userId) => _repository.restoreUser(userId);
  Future<void> forceDelete(int userId) => _repository.forceDeleteUser(userId);
}
