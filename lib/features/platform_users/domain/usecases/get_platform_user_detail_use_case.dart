import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

/// استرجاع التفاصيل الإدارية لحساب مستخدم المنصة.
class GetPlatformUserDetailUseCase {
  const GetPlatformUserDetailUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<PlatformUserDetailEntity> execute(int userId) {
    return _repository.getUserDetail(userId);
  }

  Future<PlatformUserDetailEntity> call(int userId) => execute(userId);
}
