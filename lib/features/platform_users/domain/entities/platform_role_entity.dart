class PlatformRoleEntity {
  const PlatformRoleEntity({
    required this.id,
    required this.key,
    required this.name,
    required this.isSystem,
    required this.isActive,
    this.keyLabel,
    this.description,
    this.scope,
    this.scopeLabel,
  });

  final int id;
  final String key;
  final String name;
  final bool isSystem;
  final bool isActive;
  final String? keyLabel;
  final String? description;
  final String? scope;
  final String? scopeLabel;
}
