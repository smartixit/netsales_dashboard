import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';

/// POSResource model inheriting the corresponding pure-Dart Domain entity.
class PlatformPosModel extends PlatformPosEntity {
  const PlatformPosModel({
    required super.id,
    required super.name,
    required super.status,
    super.ownerId,
    super.uuid,
    super.logo,
    super.ownerName,
    super.phoneNumber,
    super.email,
    super.governorateId,
    super.governorateName,
    super.directorateId,
    super.directorateName,
    super.address,
    super.approvedBy,
    super.rejectedBy,
    super.approvedAt,
    super.rejectedAt,
    super.rejectionReason,
    super.statusLabel,
    super.createdAt,
    super.updatedAt,
  });

  factory PlatformPosModel.fromJson(Map<String, dynamic> json) {
    final owner = _asJsonMap(json['owner']);
    final governorate = _asJsonMap(json['governorate']);
    final directorate = _asJsonMap(json['directorate']);

    return PlatformPosModel(
      id: _toInt(json['pos_id']),
      ownerId: _toNullableInt(json['owner_id']),
      uuid: json['pos_uuid']?.toString(),
      name: json['pos_name']?.toString() ?? '',
      logo: json['pos_profile_logo']?.toString(),
      ownerName: json['pos_holder_name']?.toString() ??
          owner?['user_full_name']?.toString(),
      phoneNumber: json['pos_phone_number']?.toString(),
      email: json['pos_email']?.toString(),
      governorateId: _toNullableInt(json['governorate_id']),
      governorateName: governorate?['governorate_name']?.toString(),
      directorateId: _toNullableInt(json['directorate_id']),
      directorateName: directorate?['directorate_name']?.toString(),
      address: json['pos_address']?.toString(),
      approvedBy: _toNullableInt(json['approved_by']),
      rejectedBy: _toNullableInt(json['rejected_by']),
      approvedAt: _toDateTime(json['approved_at']),
      rejectedAt: _toDateTime(json['rejected_at']),
      rejectionReason: json['rejection_reason']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  static Map<String, dynamic>? _asJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map<Object?, Object?>) return Map<String, dynamic>.from(value);
    return null;
  }

  static int _toInt(Object? value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static int? _toNullableInt(Object? value) =>
      value == null ? null : _toInt(value);

  static DateTime? _toDateTime(Object? value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
