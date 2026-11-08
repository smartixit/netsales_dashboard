import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';

/// نموذج سجل النشاط كما يصل من SystemLogResource.
class PlatformActivityModel {
  const PlatformActivityModel({
    required this.id,
    required this.module,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.actorName,
    required this.contextLabel,
    required this.timestamp,
    required this.source,
  });

  final int id;
  final String module;
  final String action;
  final String entityType;
  final int? entityId;
  final String? actorName;
  final String? contextLabel;
  final String? timestamp;
  final String? source;

  factory PlatformActivityModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final actor = user is Map<Object?, Object?>
        ? user['user_full_name']?.toString()
        : null;
    return PlatformActivityModel(
      id: _toInt(json['log_id']),
      module: json['module']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityId: _toNullableInt(json['entity_id']),
      actorName: actor,
      contextLabel: json['context_label']?.toString(),
      timestamp: json['log_date']?.toString(),
      source: 'system_log',
    );
  }

  PlatformActivityEntity toEntity() {
    return PlatformActivityEntity(
      id: id,
      module: module,
      action: action,
      entityType: entityType,
      entityId: entityId,
      actorName: actorName,
      contextLabel: contextLabel,
      timestamp: DateTime.tryParse(timestamp ?? ''),
      source: source,
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static int? _toNullableInt(dynamic value) =>
      value == null ? null : _toInt(value);
}
