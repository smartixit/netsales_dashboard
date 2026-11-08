class PlatformUserEntity {
  const PlatformUserEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.status,
    this.statusLabel,
    this.email,
    this.profileImage,
    this.roleName,
    this.lastLoginAt,
  });
  final int id;
  final String fullName;
  final String phoneNumber;
  final String status;
  final String? statusLabel;
  final String? email;
  final String? profileImage;
  final String? roleName;
  final DateTime? lastLoginAt;
}
