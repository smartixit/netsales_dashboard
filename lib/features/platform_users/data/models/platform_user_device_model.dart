import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_device_entity.dart';

/// نموذج الجهاز كما يصل من UserDeviceResource في Laravel API.
class PlatformUserDeviceModel {
  const PlatformUserDeviceModel({
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
  final String? lastUsedAt;

  factory PlatformUserDeviceModel.fromJson(Map<String, dynamic> json) {
    return PlatformUserDeviceModel(
      id: _toInt(json['device_id']),
      name: json['device_name']?.toString() ?? '',
      type: json['device_type']?.toString() ?? 'UNKNOWN',
      typeLabel: json['device_type_label']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
      lastUsedAt: json['last_used_at']?.toString(),
    );
  }

  PlatformUserDeviceEntity toEntity() {
    return PlatformUserDeviceEntity(
      id: id,
      name: name,
      type: type,
      typeLabel: typeLabel,
      status: status,
      statusLabel: statusLabel,
      isPrimary: isPrimary,
      lastUsedAt: DateTime.tryParse(lastUsedAt ?? ''),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
}
