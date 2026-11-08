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
