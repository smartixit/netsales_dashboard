import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';

class PlatformRoleModel extends PlatformRoleEntity {
  const PlatformRoleModel({
    required super.id,
    required super.key,
    required super.name,
    required super.isSystem,
    required super.isActive,
    super.keyLabel,
    super.description,
    super.scope,
    super.scopeLabel,
  });

  factory PlatformRoleModel.fromJson(Map<String, dynamic> json) {
    return PlatformRoleModel(
      id: _toInt(json['role_id']),
      key: json['role_key']?.toString() ?? '',
      keyLabel: json['role_key_label']?.toString(),
      name: json['role_name']?.toString() ?? '',
      description: json['role_desc']?.toString(),
      scope: json['scope']?.toString(),
      scopeLabel: json['scope_label']?.toString(),
      isSystem: _toBool(json['is_system']),
      isActive: _toBool(json['status']),
    );
  }

  static int _toInt(Object? value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static bool _toBool(Object? value) =>
      value == true || value == 1 || value?.toString() == '1';
}
