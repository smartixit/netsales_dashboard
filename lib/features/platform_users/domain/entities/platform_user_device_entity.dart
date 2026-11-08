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
