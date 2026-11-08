import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

/// نموذج الجلسة كما يصل من UserSessionResource في Laravel API.
class PlatformUserSessionModel extends PlatformUserSessionEntity {
  const PlatformUserSessionModel({
    required super.id,
    required super.ipAddress,
    required super.userAgent,
    required super.lastActivityAt,
    required super.expiresAt,
  });

  factory PlatformUserSessionModel.fromJson(Map<String, dynamic> json) {
    return PlatformUserSessionModel(
      id: _toInt(json['session_id']),
      ipAddress: json['ip_address']?.toString(),
      userAgent: json['user_agent']?.toString(),
      lastActivityAt: _toDateTime(json['last_activity_at']),
      expiresAt: _toDateTime(json['expires_at']),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
