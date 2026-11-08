import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

class GetPlatformUserDetailUseCase {
  const GetPlatformUserDetailUseCase(this._repository);
  final PlatformUsersRepository _repository;
  Future<PlatformUserDetailEntity?> call(int id) => _repository.getUserDetail(id);
}
