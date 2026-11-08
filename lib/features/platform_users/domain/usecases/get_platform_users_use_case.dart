import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_users_page_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

/// مدخلات استرجاع دليل المستخدمين.
class GetPlatformUsersParams {
  const GetPlatformUsersParams({
    this.search,
    this.status,
    this.cursor,
    this.perPage = 20,
  });

  final String? search;
  final String? status;
  final String? cursor;
  final int perPage;
}

/// استرجاع صفحة من مستخدمي المنصة.
class GetPlatformUsersUseCase {
  const GetPlatformUsersUseCase(this._repository);

  final PlatformUsersRepository _repository;

  Future<PlatformUsersPageEntity> execute(GetPlatformUsersParams params) {
    return _repository.getUsers(
      search: params.search,
      status: params.status,
      cursor: params.cursor,
      perPage: params.perPage,
    );
  }

  Future<PlatformUsersPageEntity> call(GetPlatformUsersParams params) =>
      execute(params);
}
