class PlatformNotificationEntity {
  const PlatformNotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    this.type,
    this.typeLabel,
    this.createdAt,
  });
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String? type;
  final String? typeLabel;
  final DateTime? createdAt;
}
