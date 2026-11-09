import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class UpdatePlatformUserStatusUseCase {
  const UpdatePlatformUserStatusUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<PlatformUserEntity> call(int userId, String status) =>
      _repository.updateUserStatus(userId, status);
}
