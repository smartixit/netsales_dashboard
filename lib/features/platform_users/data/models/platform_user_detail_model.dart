import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_ban_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_device_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

/// نموذج استجابة تفاصيل المستخدم كما يعيدها UserResource في Laravel.
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
  final List<PlatformUserDeviceModel> devices;
  final List<PlatformUserBanModel> securityBans;

  factory PlatformUserDetailModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'] is Map<Object?, Object?>
        ? Map<String, dynamic>.from(json['role'] as Map<Object?, Object?>)
        : <String, dynamic>{};
    final devices = json['devices'] is List
        ? (json['devices'] as List)
            .whereType<Map<Object?, Object?>>()
            .map((item) => PlatformUserDeviceModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList(growable: false)
        : const <PlatformUserDeviceModel>[];
    final bans = json['security_bans'] is List
        ? (json['security_bans'] as List)
            .whereType<Map>()
            .map((item) => PlatformUserBanModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList(growable: false)
        : const <PlatformUserBanModel>[];

    return PlatformUserDetailModel(
      user: PlatformUserModel.fromJson({...json, 'role': role}),
      roleId: _toInt(json['role_id']),
      twoFactorEnabled: _toBool(json['user_2fa_enabled']),
      mustChangePassword: _toBool(json['must_change_password']),
      loginAttempts: _toInt(json['user_login_attempts']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      devices: devices,
      securityBans: bans,
    );
  }

  PlatformUserDetailEntity toEntity() {
    return PlatformUserDetailEntity(
      user: user.toEntity(),
      roleId: roleId,
      twoFactorEnabled: twoFactorEnabled,
      mustChangePassword: mustChangePassword,
      loginAttempts: loginAttempts,
      createdAt: DateTime.tryParse(createdAt ?? ''),
      updatedAt: DateTime.tryParse(updatedAt ?? ''),
      devices: devices.map((model) => model.toEntity()).toList(growable: false),
      securityBans:
          securityBans.map((model) => model.toEntity()).toList(growable: false),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static bool _toBool(dynamic value) =>
      value == true || value == 1 || value?.toString() == '1';
}
