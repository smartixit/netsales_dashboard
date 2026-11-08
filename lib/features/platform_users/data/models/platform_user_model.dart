import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

class PlatformUserModel {
  const PlatformUserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.status,
    this.statusLabel,
    this.email,
    this.profileImage,
    this.roleName,
    this.lastLoginAt,
  });
  final int id;
  final String fullName;
  final String phoneNumber;
  final String status;
  final String? statusLabel;
  final String? email;
  final String? profileImage;
  final String? roleName;
  final String? lastLoginAt;

  factory PlatformUserModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'] is Map ? Map<String, dynamic>.from(json['role'] as Map) : const <String, dynamic>{};
    return PlatformUserModel(
      id: _int(json['user_id']),
      fullName: json['user_full_name']?.toString() ?? '',
      phoneNumber: json['user_phone_number']?.toString() ?? '',
      email: json['user_email']?.toString(),
      profileImage: json['user_profile_logo']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      roleName: role['role_name']?.toString() ?? role['role_key_label']?.toString() ?? role['role_key']?.toString(),
      lastLoginAt: json['last_login_at']?.toString(),
    );
  }

  PlatformUserEntity toEntity() => PlatformUserEntity(
    id: id, fullName: fullName, phoneNumber: phoneNumber, email: email,
    profileImage: profileImage, status: status, statusLabel: statusLabel,
    roleName: roleName, lastLoginAt: DateTime.tryParse(lastLoginAt ?? ''),
  );

  static int _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
}
