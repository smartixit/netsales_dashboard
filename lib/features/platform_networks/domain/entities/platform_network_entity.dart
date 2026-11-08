class PlatformNetworkEntity {
  const PlatformNetworkEntity({
    required this.id,
    required this.name,
    required this.status,
    this.ownerId,
    this.uuid,
    this.logo,
    this.ownerName,
    this.phoneNumber,
    this.email,
    this.governorateId,
    this.governorateName,
    this.directorateId,
    this.directorateName,
    this.address,
    this.approvedBy,
    this.rejectedBy,
    this.approvedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int? ownerId;
  final String? uuid;
  final String name;
  final String? logo;
  final String? ownerName;
  final String? phoneNumber;
  final String? email;
  final int? governorateId;
  final String? governorateName;
  final int? directorateId;
  final String? directorateName;
  final String? address;
  final int? approvedBy;
  final int? rejectedBy;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String status;
  final String? statusLabel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
