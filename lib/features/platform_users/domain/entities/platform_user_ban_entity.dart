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
