class PlatformNetworkPosLinkEntity {
  const PlatformNetworkPosLinkEntity({
    required this.id,
    required this.networkId,
    required this.posId,
    required this.isActive,
    this.networkName,
    this.networkUuid,
    this.networkLogo,
    this.posName,
    this.posUuid,
    this.posLogo,
    this.posPhoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int networkId;
  final int posId;
  final bool isActive;
  final String? networkName;
  final String? networkUuid;
  final String? networkLogo;
  final String? posName;
  final String? posUuid;
  final String? posLogo;
  final String? posPhoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
