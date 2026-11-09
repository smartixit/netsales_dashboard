import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class CreatePlatformUserUseCase {
  const CreatePlatformUserUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<PlatformUserEntity> call(Map<String, dynamic> data) =>
      _repository.createUser(data);
}
