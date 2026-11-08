import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

/// نموذج سجل الحظر كما يصل من SecurityBanResource في Laravel API.
class PlatformUserBanModel extends PlatformUserBanEntity {
  const PlatformUserBanModel({
    required super.id,
    required super.type,
    required super.typeLabel,
    required super.reason,
    required super.startedAt,
    required super.endsAt,
  });

  factory PlatformUserBanModel.fromJson(Map<String, dynamic> json) {
    return PlatformUserBanModel(
      id: _toInt(json['ban_id']),
      type: json['ban_type']?.toString() ?? 'UNKNOWN',
      typeLabel: json['ban_type_label']?.toString(),
      reason: json['ban_reason']?.toString(),
      startedAt: _toDateTime(json['start_at']),
      endsAt: _toDateTime(json['end_at']),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
