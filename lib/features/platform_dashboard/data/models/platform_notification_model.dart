import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';

/// نموذج الإشعار كما يصل من NotificationResource.
class PlatformNotificationModel {
  const PlatformNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.typeLabel,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String? type;
  final String? typeLabel;
  final String? createdAt;

  factory PlatformNotificationModel.fromJson(Map<String, dynamic> json) {
    return PlatformNotificationModel(
      id: _toInt(json['notification_id']),
      title: json['notification_title']?.toString() ?? '',
      message: json['notification_message']?.toString() ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      type: json['notification_type']?.toString(),
      typeLabel: json['notification_type_label']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  PlatformNotificationEntity toEntity() {
    return PlatformNotificationEntity(
      id: id,
      title: title,
      message: message,
      isRead: isRead,
      type: type,
      typeLabel: typeLabel,
      createdAt: DateTime.tryParse(createdAt ?? ''),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
}
