import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';

/// نموذج الإشعار؛ يرث كيان Domain مباشرة.
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

  factory PlatformNotificationModel.fromJson(Map<String, dynamic> json) {
    return PlatformNotificationModel(
      id: _toInt(json['notification_id']),
      title: json['notification_title']?.toString() ?? '',
      message: json['notification_message']?.toString() ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      type: json['notification_type']?.toString(),
      typeLabel: json['notification_type_label']?.toString(),
      createdAt: _toDateTime(json['created_at']),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static DateTime? _toDateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
