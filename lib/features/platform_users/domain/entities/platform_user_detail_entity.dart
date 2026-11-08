import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_ban_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_device_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

/// المعلومات الإدارية الإضافية لحساب مستخدم المنصة.
class PlatformUserDetailEntity {
  const PlatformUserDetailEntity({
    required this.user,
    required this.roleId,
    required this.twoFactorEnabled,
    required this.mustChangePassword,
    required this.loginAttempts,
    required this.createdAt,
    required this.updatedAt,
    this.devices = const [],
    this.securityBans = const [],
  });

  final PlatformUserEntity user;
  final int roleId;
  final bool twoFactorEnabled;
  final bool mustChangePassword;
  final int loginAttempts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PlatformUserDeviceEntity> devices;
  final List<PlatformUserBanEntity> securityBans;
}
