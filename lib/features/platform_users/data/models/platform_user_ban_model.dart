import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_ban_entity.dart';

/// نموذج سجل الحظر كما يصل من SecurityBanResource في Laravel API.
class PlatformUserBanModel {
  const PlatformUserBanModel({
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
  final String? startedAt;
  final String? endsAt;

  factory PlatformUserBanModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['ban_id'];
    return PlatformUserBanModel(
      id: rawId is num ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '') ?? 0,
      type: json['ban_type']?.toString() ?? 'UNKNOWN',
      typeLabel: json['ban_type_label']?.toString(),
      reason: json['ban_reason']?.toString(),
      startedAt: json['start_at']?.toString(),
      endsAt: json['end_at']?.toString(),
    );
  }

  PlatformUserBanEntity toEntity() {
    return PlatformUserBanEntity(
      id: id,
      type: type,
      typeLabel: typeLabel,
      reason: reason,
      startedAt: DateTime.tryParse(startedAt ?? ''),
      endsAt: DateTime.tryParse(endsAt ?? ''),
    );
  }
}
