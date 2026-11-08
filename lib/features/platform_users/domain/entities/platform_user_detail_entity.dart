import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

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

class PlatformUserDeviceEntity {
  const PlatformUserDeviceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.typeLabel,
    required this.status,
    required this.statusLabel,
    required this.isPrimary,
    required this.lastUsedAt,
  });
  final int id;
  final String name;
  final String type;
  final String? typeLabel;
  final String status;
  final String? statusLabel;
  final bool isPrimary;
  final DateTime? lastUsedAt;
}

class PlatformUserBanEntity {
  const PlatformUserBanEntity({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.reason,
    required this.startedAt,
    required this.endsAt,
  });
  final int id;
  final String type;
  final String? typeLabel;
  final String? reason;
  final DateTime? startedAt;
  final DateTime? endsAt;
}

class PlatformUserSessionEntity {
  const PlatformUserSessionEntity({
    required this.id,
    required this.ipAddress,
    required this.userAgent,
    required this.lastActivityAt,
    required this.expiresAt,
  });
  final int id;
  final String? ipAddress;
  final String? userAgent;
  final DateTime? lastActivityAt;
  final DateTime? expiresAt;
}
