import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_detail_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_session_model.dart';

/// عقد مصدر البيانات البعيد لإدارة مستخدمي المنصة.
abstract interface class PlatformUsersRemoteDataSource {
  Future<ApiResponse<List<PlatformUserModel>>> getUsers({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<ApiResponse<PlatformUserDetailModel>> getUserDetail(int userId);

  Future<ApiResponse<List<PlatformUserSessionModel>>> getUserSessions(
    int userId,
  );
}
