import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';

/// نموذج سجل النشاط؛ يرث كيان Domain ويحتفظ بتحويل JSON داخل طبقة Data.
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
    final actor = user is Map<Object?, Object?>
        ? user['user_full_name']?.toString()
        : json['actor_name']?.toString();
    return PlatformActivityModel(
      id: _toInt(json['log_id'] ?? json['id']),
      module: json['module']?.toString() ?? '',
      action: json['action']?.toString() ?? json['title']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityId: _toNullableInt(json['entity_id']),
      actorName: actor,
      contextLabel: json['context_label']?.toString(),
      timestamp: _toDateTime(json['log_date'] ?? json['occurred_at']),
      source: json['source']?.toString() ?? 'system_log',
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static int? _toNullableInt(dynamic value) =>
      value == null ? null : _toInt(value);

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
