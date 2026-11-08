import 'package:netsales_dashboard/core/exceptions/app_exception.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_session_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_users_page_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';

/// تحويل استجابات Data إلى كيانات Domain دون تسريب ApiResponse إلى الطبقات العليا.
class PlatformUsersRepositoryImpl implements PlatformUsersRepository {
  const PlatformUsersRepositoryImpl(this._remoteDataSource);

  final PlatformUsersRemoteDataSource _remoteDataSource;

  @override
  Future<PlatformUsersPageEntity> getUsers({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) async {
    final response = await _remoteDataSource.getUsers(
      search: search,
      status: status,
      cursor: cursor,
      perPage: perPage,
    );
    if (!response.success) {
      throw AppException(response.message);
    }
    return PlatformUsersPageEntity(
      users: response.data
              ?.map((model) => model.toEntity())
              .toList(growable: false) ??
          const <PlatformUserEntity>[],
      nextCursor: response.nextCursor,
      previousCursor: response.prevCursor,
    );
  }

  @override
  Future<PlatformUserDetailEntity> getUserDetail(int userId) async {
    final response = await _remoteDataSource.getUserDetail(userId);
    if (!response.success || response.data == null) {
      throw AppException(response.message);
    }
    return response.data!.toEntity();
  }

  @override
  Future<List<PlatformUserSessionEntity>> getUserSessions(int userId) async {
    final response = await _remoteDataSource.getUserSessions(userId);
    if (!response.success) {
      throw AppException(response.message);
    }
    return response.data
            ?.map((model) => model.toEntity())
            .toList(growable: false) ??
        const <PlatformUserSessionEntity>[];
  }
}
