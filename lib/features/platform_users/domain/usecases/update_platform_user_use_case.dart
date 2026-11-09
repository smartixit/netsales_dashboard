import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class UpdatePlatformUserUseCase {
  const UpdatePlatformUserUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<PlatformUserEntity> call(
    int userId,
    Map<String, dynamic> data,
  ) => _repository.updateUser(userId, data);
}
