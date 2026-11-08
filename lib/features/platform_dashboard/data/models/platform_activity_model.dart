import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';

class PlatformActivityModel extends PlatformActivityEntity {
  const PlatformActivityModel({
    required super.id,
    required super.module,
    required super.action,
    required super.entityType,
    required super.timestamp,
    super.entityId,
    super.actorName,
    super.contextLabel,
    super.source,
  });

  factory PlatformActivityModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final actor = user is Map ? user['user_full_name']?.toString() : null;
    return PlatformActivityModel(
      id: _asInt(json['log_id']),
      module: json['module']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityId: int.tryParse(json['entity_id']?.toString() ?? ''),
      timestamp: DateTime.tryParse(json['log_date']?.toString() ?? ''),
      actorName: actor,
      source: 'system_log',
    );
  }

  static int _asInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
}
