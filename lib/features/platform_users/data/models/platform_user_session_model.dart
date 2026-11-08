import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_session_entity.dart';

/// نموذج جلسة المستخدم كما يصل من UserSessionResource في Laravel API.
class PlatformUserSessionModel {
  const PlatformUserSessionModel({
    required this.id,
    required this.ipAddress,
    required this.userAgent,
    required this.lastActivityAt,
    required this.expiresAt,
  });

  final int id;
  final String? ipAddress;
  final String? userAgent;
  final String? lastActivityAt;
  final String? expiresAt;

  factory PlatformUserSessionModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['session_id'];
    return PlatformUserSessionModel(
      id: rawId is num ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '') ?? 0,
      ipAddress: json['ip_address']?.toString(),
      userAgent: json['user_agent']?.toString(),
      lastActivityAt: json['last_activity_at']?.toString(),
      expiresAt: json['expires_at']?.toString(),
    );
  }

  PlatformUserSessionEntity toEntity() {
    return PlatformUserSessionEntity(
      id: id,
      ipAddress: ipAddress,
      userAgent: userAgent,
      lastActivityAt: DateTime.tryParse(lastActivityAt ?? ''),
      expiresAt: DateTime.tryParse(expiresAt ?? ''),
    );
  }
}
