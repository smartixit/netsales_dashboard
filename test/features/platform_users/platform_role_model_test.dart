import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_role_model.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';

void main() {
  group('PlatformRoleModel', () {
    test('maps platform role wire fields into a domain entity', () {
      final model = PlatformRoleModel.fromJson({
        'role_id': 7,
        'role_key': 'SUPPORT_AGENT',
        'role_key_label': 'موظف دعم',
        'role_name': 'Support Agent',
        'role_desc': 'Platform support role',
        'scope': 'PLATFORM',
        'scope_label': 'المنصة',
        'is_system': true,
        'status': true,
      });

      expect(model, isA<PlatformRoleEntity>());
      expect(model.id, 7);
      expect(model.key, 'SUPPORT_AGENT');
      expect(model.name, 'Support Agent');
      expect(model.scope, 'PLATFORM');
      expect(model.isSystem, isTrue);
      expect(model.isActive, isTrue);
    });

    test('handles numeric and string boolean values safely', () {
      final model = PlatformRoleModel.fromJson({
        'role_id': '8',
        'role_key': 'ACCOUNTANT',
        'role_name': 'Accountant',
        'is_system': 1,
        'status': '1',
      });

      expect(model.id, 8);
      expect(model.isSystem, isTrue);
      expect(model.isActive, isTrue);
    });

    test('does not treat unknown status values as active', () {
      final model = PlatformRoleModel.fromJson({
        'role_id': 9,
        'role_key': 'UNKNOWN',
        'role_name': 'Unknown',
        'is_system': false,
        'status': 'active',
      });

      expect(model.isActive, isFalse);
    });
  });
}
