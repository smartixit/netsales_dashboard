import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

/// نموذج UserResource، يرث الكيان مباشرة حتى لا يحتاج المستودع إلى تحويل وسيط.
class PlatformUserModel extends PlatformUserEntity {
  const PlatformUserModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    required super.status,
    super.statusLabel,
    super.email,
    super.profileImage,
    super.roleName,
    super.lastLoginAt,
  });

  factory PlatformUserModel.fromJson(Map<String, dynamic> json) {
    final rawRole = json['role'];
    final role = rawRole is Map<Object?, Object?>
        ? Map<String, dynamic>.from(rawRole)
        : const <String, dynamic>{};

    return PlatformUserModel(
      id: _toInt(json['user_id']),
      fullName: json['user_full_name']?.toString() ?? '',
      phoneNumber: json['user_phone_number']?.toString() ?? '',
      email: json['user_email']?.toString(),
      profileImage: json['user_profile_logo']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      roleName: role['role_name']?.toString() ??
          role['role_key_label']?.toString() ??
          role['role_key']?.toString(),
      lastLoginAt: _toDateTime(json['last_login_at']),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
