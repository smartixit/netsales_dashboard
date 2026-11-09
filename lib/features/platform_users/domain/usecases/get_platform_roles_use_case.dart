import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class GetPlatformRolesUseCase {
  const GetPlatformRolesUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<List<PlatformRoleEntity>> call() => _repository.getPlatformRoles();
}
