import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

class PlatformUserDetailModel {
  const PlatformUserDetailModel({
    required this.user,
    required this.roleId,
    required this.twoFactorEnabled,
    required this.mustChangePassword,
    required this.loginAttempts,
    required this.createdAt,
    required this.updatedAt,
    required this.devices,
    required this.securityBans,
  });
  final PlatformUserModel user;
  final int roleId;
  final bool twoFactorEnabled;
  final bool mustChangePassword;
  final int loginAttempts;
  final String? createdAt;
  final String? updatedAt;
  final List<PlatformUserDeviceEntity> devices;
  final List<PlatformUserBanEntity> securityBans;

  factory PlatformUserDetailModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'] is Map ? Map<String, dynamic>.from(json['role'] as Map) : <String, dynamic>{};
    final devices = json['devices'] is List
        ? (json['devices'] as List).whereType<Map<String, dynamic>>().map((e) => _device(Map<String, dynamic>.from(e))).toList()
        : <PlatformUserDeviceEntity>[];
    final bans = json['security_bans'] is List
        ? (json['security_bans'] as List).whereType<Map<String, dynamic>>().map((e) => _ban(Map<String, dynamic>.from(e))).toList()
        : <PlatformUserBanEntity>[];
    return PlatformUserDetailModel(
      user: PlatformUserModel.fromJson({...json, 'role': role}),
      roleId: _int(json['role_id']),
      twoFactorEnabled: json['user_2fa_enabled'] == true || json['user_2fa_enabled'] == 1,
      mustChangePassword: json['must_change_password'] == true || json['must_change_password'] == 1,
      loginAttempts: _int(json['user_login_attempts']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      devices: devices,
      securityBans: bans,
    );
  }

  PlatformUserDetailEntity toEntity() => PlatformUserDetailEntity(
    user: user.toEntity(),
    roleId: roleId,
    twoFactorEnabled: twoFactorEnabled,
    mustChangePassword: mustChangePassword,
    loginAttempts: loginAttempts,
    createdAt: DateTime.tryParse(createdAt ?? ''),
    updatedAt: DateTime.tryParse(updatedAt ?? ''),
    devices: devices,
    securityBans: securityBans,
  );

  static PlatformUserDeviceEntity _device(Map<String, dynamic> json) => PlatformUserDeviceEntity(
    id: _int(json['device_id']),
    name: json['device_name']?.toString() ?? '',
    type: json['device_type']?.toString() ?? 'UNKNOWN',
    typeLabel: json['device_type_label']?.toString(),
    status: json['status']?.toString() ?? 'UNKNOWN',
    statusLabel: json['status_label']?.toString(),
    isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
    lastUsedAt: DateTime.tryParse(json['last_used_at']?.toString() ?? ''),
  );

  static PlatformUserBanEntity _ban(Map<String, dynamic> json) => PlatformUserBanEntity(
    id: _int(json['ban_id']),
    type: json['ban_type']?.toString() ?? 'UNKNOWN',
    typeLabel: json['ban_type_label']?.toString(),
    reason: json['ban_reason']?.toString(),
    startedAt: DateTime.tryParse(json['start_at']?.toString() ?? ''),
    endsAt: DateTime.tryParse(json['end_at']?.toString() ?? ''),
  );

  static int _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
}

class PlatformUserSessionModel {
  const PlatformUserSessionModel({required this.id, required this.ipAddress, required this.userAgent, required this.lastActivityAt, required this.expiresAt});
  final int id;
  final String? ipAddress;
  final String? userAgent;
  final String? lastActivityAt;
  final String? expiresAt;

  factory PlatformUserSessionModel.fromJson(Map<String, dynamic> json) => PlatformUserSessionModel(
    id: PlatformUserDetailModel._int(json['session_id']),
    ipAddress: json['ip_address']?.toString(),
    userAgent: json['user_agent']?.toString(),
    lastActivityAt: json['last_activity_at']?.toString(),
    expiresAt: json['expires_at']?.toString(),
  );

  PlatformUserSessionEntity toEntity() => PlatformUserSessionEntity(
    id: id,
    ipAddress: ipAddress,
    userAgent: userAgent,
    lastActivityAt: DateTime.tryParse(lastActivityAt ?? ''),
    expiresAt: DateTime.tryParse(expiresAt ?? ''),
  );
}
