import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_session_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_users_page_entity.dart';

/// عقد عمليات إدارة مستخدمي المنصة بعيداً عن تفاصيل النقل والاستجابة.
abstract interface class PlatformUsersRepository {
  Future<PlatformUsersPageEntity> getUsers({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<PlatformUserDetailEntity> getUserDetail(int userId);

  Future<List<PlatformUserSessionEntity>> getUserSessions(int userId);
}
