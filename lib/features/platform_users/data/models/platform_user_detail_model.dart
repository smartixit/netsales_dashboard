import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_ban_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_device_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

/// نموذج UserResource التفصيلي، وهو نفسه كيان Domain دون تحويل إضافي.
class PlatformUserDetailModel extends PlatformUserDetailEntity {
  const PlatformUserDetailModel({
    required PlatformUserModel super.user,
    required super.roleId,
    required super.twoFactorEnabled,
    required super.mustChangePassword,
    required super.loginAttempts,
    required super.createdAt,
    required super.updatedAt,
    required List<PlatformUserDeviceModel> super.devices,
    required List<PlatformUserBanModel> super.securityBans,
  });

  factory PlatformUserDetailModel.fromJson(Map<String, dynamic> json) {
    final rawDevices = json['devices'];
    final devices = rawDevices is List
        ? rawDevices
            .whereType<Map<Object?, Object?>>()
            .map(
              (item) => PlatformUserDeviceModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false)
        : const <PlatformUserDeviceModel>[];

    final rawBans = json['security_bans'];
    final bans = rawBans is List
        ? rawBans
            .whereType<Map<Object?, Object?>>()
            .map(
              (item) => PlatformUserBanModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false)
        : const <PlatformUserBanModel>[];

    return PlatformUserDetailModel(
      user: PlatformUserModel.fromJson(json),
      roleId: _toInt(json['role_id']),
      twoFactorEnabled: _toBool(json['user_2fa_enabled']),
      mustChangePassword: _toBool(json['must_change_password']),
      loginAttempts: _toInt(json['user_login_attempts']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      devices: devices,
      securityBans: bans,
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static bool _toBool(dynamic value) =>
      value == true || value == 1 || value?.toString() == '1';

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
