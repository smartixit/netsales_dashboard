import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';

class PlatformNetworkPosLinkModel extends PlatformNetworkPosLinkEntity {
  const PlatformNetworkPosLinkModel({
    required super.id,
    required super.networkId,
    required super.posId,
    required super.isActive,
    super.networkName,
    super.networkUuid,
    super.networkLogo,
    super.posName,
    super.posUuid,
    super.posLogo,
    super.posPhoneNumber,
    super.createdAt,
    super.updatedAt,
  });

  factory PlatformNetworkPosLinkModel.fromJson(Map<String, dynamic> json) {
    final network = _asJsonMap(json['network']);
    final pos = _asJsonMap(json['pos']);

    return PlatformNetworkPosLinkModel(
      id: _toInt(json['network_pos_id']),
      networkId: _toInt(json['network_id']),
      posId: _toInt(json['pos_id']),
      isActive: _toBool(json['status']),
      networkName: network?['network_name']?.toString(),
      networkUuid: network?['network_uuid']?.toString(),
      networkLogo: network?['network_profile_logo']?.toString(),
      posName: pos?['pos_name']?.toString(),
      posUuid: pos?['pos_uuid']?.toString(),
      posLogo: pos?['pos_profile_logo']?.toString(),
      posPhoneNumber: pos?['pos_phone_number']?.toString(),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  static Map<String, dynamic>? _asJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map<Object?, Object?>) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static int _toInt(Object? value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static bool _toBool(Object? value) =>
      value == true || value == 1 || value == '1' || value == 'true';

  static DateTime? _toDateTime(Object? value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
