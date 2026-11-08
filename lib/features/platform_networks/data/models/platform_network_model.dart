import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';

/// NetworkResource model. It is also the Domain entity through inheritance.
class PlatformNetworkModel extends PlatformNetworkEntity {
  const PlatformNetworkModel({
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

  factory PlatformNetworkModel.fromJson(Map<String, dynamic> json) {
    final owner = _map(json['owner']);
    final governorate = _map(json['governorate']);
    final directorate = _map(json['directorate']);

    return PlatformNetworkModel(
      id: _toInt(json['network_id']),
      ownerId: _toNullableInt(json['owner_id']),
      uuid: json['network_uuid']?.toString(),
      name: json['network_name']?.toString() ?? '',
      logo: json['network_profile_logo']?.toString(),
      ownerName: json['network_holder_name']?.toString() ??
          owner?['user_full_name']?.toString(),
      phoneNumber: json['network_phone_number']?.toString(),
      email: json['network_email']?.toString(),
      governorateId: _toNullableInt(json['governorate_id']),
      governorateName: governorate?['governorate_name']?.toString(),
      directorateId: _toNullableInt(json['directorate_id']),
      directorateName: directorate?['directorate_name']?.toString(),
      address: json['network_address']?.toString(),
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

  static Map<String, dynamic>? _map(Object? value) {
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
