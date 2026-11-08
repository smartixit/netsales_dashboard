import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';

class PlatformNotificationModel extends PlatformNotificationEntity {
  const PlatformNotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.isRead,
    super.type,
    super.typeLabel,
    super.createdAt,
  });

  factory PlatformNotificationModel.fromJson(Map<String, dynamic> json) =>
      PlatformNotificationModel(
        id: _asInt(json['notification_id']),
        title: json['notification_title']?.toString() ?? '',
        message: json['notification_message']?.toString() ?? '',
        isRead: json['is_read'] == true || json['is_read'] == 1,
        type: json['notification_type']?.toString(),
        typeLabel: json['notification_type_label']?.toString(),
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      );

  static int _asInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
}
