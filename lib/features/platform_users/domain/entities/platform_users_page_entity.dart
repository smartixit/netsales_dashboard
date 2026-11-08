import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

/// صفحة نتائج دليل مستخدمي المنصة وبيانات متابعة المؤشر.
class PlatformUsersPageEntity {
  const PlatformUsersPageEntity({
    required this.users,
    this.nextCursor,
    this.previousCursor,
  });

  final List<PlatformUserEntity> users;
  final String? nextCursor;
  final String? previousCursor;

  bool get hasMore => nextCursor?.isNotEmpty ?? false;
}
