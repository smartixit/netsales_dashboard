import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_detail_model.dart';

void main() {
  group('PlatformUserDetailModel', () {
    test('maps server user, device and ban details without exposing device credentials', () {
      final model = PlatformUserDetailModel.fromJson({
        'user_id': 41,
        'role_id': 2,
        'user_full_name': 'Platform Operator',
        'user_phone_number': '771234567',
        'user_email': 'operator@example.com',
        'status': 'ACTIVE',
        'status_label': 'مفعّل',
        'user_2fa_enabled': true,
        'must_change_password': false,
        'user_login_attempts': 1,
        'created_at': '2026-11-01 10:00:00',
        'updated_at': '2026-11-02 10:00:00',
        'role': {'role_name': 'Support Agent', 'role_key': 'SUPPORT_AGENT'},
        'devices': [
          {
            'device_id': 8,
            'device_name': 'Windows Desktop',
            'device_type': 'WINDOWS',
            'device_type_label': 'ويندوز',
            'status': 'ACTIVE',
            'status_label': 'مفعّل',
            'is_primary': true,
            'last_used_at': '2026-11-08 10:30:00',
          },
        ],
        'security_bans': [
          {
            'ban_id': 3,
            'ban_type': 'TEMPORARY',
            'ban_type_label': 'مؤقت',
            'ban_reason': 'Security review',
            'start_at': '2026-11-07 10:00:00',
            'end_at': '2026-11-09 10:00:00',
          },
        ],
      });

      final entity = model.toEntity();
      expect(entity.user.id, 41);
      expect(entity.user.roleName, 'Support Agent');
      expect(entity.twoFactorEnabled, isTrue);
      expect(entity.devices.single.id, 8);
      expect(entity.devices.single.type, 'WINDOWS');
      expect(entity.securityBans.single.reason, 'Security review');
    });

    test('tolerates missing optional security relationships for callers without auth.view', () {
      final model = PlatformUserDetailModel.fromJson({
        'user_id': 42,
        'role_id': 3,
        'user_full_name': 'Support Operator',
        'user_phone_number': '779876543',
        'status': 'ACTIVE',
      });

      final entity = model.toEntity();
      expect(entity.user.id, 42);
      expect(entity.devices, isEmpty);
      expect(entity.securityBans, isEmpty);
    });
  });
}
