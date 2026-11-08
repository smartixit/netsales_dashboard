import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';

/// نموذج الجهاز كما يصل من UserDeviceResource في Laravel API.
class PlatformUserDeviceModel extends PlatformUserDeviceEntity {
  const PlatformUserDeviceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.typeLabel,
    required super.status,
    required super.statusLabel,
    required super.isPrimary,
    required super.lastUsedAt,
  });

  factory PlatformUserDeviceModel.fromJson(Map<String, dynamic> json) {
    return PlatformUserDeviceModel(
      id: _toInt(json['device_id']),
      name: json['device_name']?.toString() ?? '',
      type: json['device_type']?.toString() ?? 'UNKNOWN',
      typeLabel: json['device_type_label']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
      lastUsedAt: _toDateTime(json['last_used_at']),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
