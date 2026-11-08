class PlatformActivityEntity {
  const PlatformActivityEntity({
    required this.id,
    required this.module,
    required this.action,
    required this.entityType,
    required this.timestamp,
    this.entityId,
    this.actorName,
    this.contextLabel,
    this.source,
  });

  final int id;
  final String module;
  final String action;
  final String entityType;
  final int? entityId;
  final DateTime? timestamp;
  final String? actorName;
  final String? contextLabel;
  final String? source;
}
