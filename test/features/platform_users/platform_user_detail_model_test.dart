import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_detail_model.dart';
import 'package:netsales_dashboard/features/platform_users/data/models/platform_user_model.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';

void main() {
  group('PlatformUserDetailModel', () {
    test('parses user, device and ban details as domain entities directly', () {
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
        'created_at': '2026-11-01T10:00:00Z',
        'updated_at': '2026-11-02T10:00:00Z',
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
            'last_used_at': '2026-11-08T10:30:00Z',
          },
        ],
        'security_bans': [
          {
            'ban_id': 3,
            'ban_type': 'TEMPORARY',
            'ban_type_label': 'مؤقت',
            'ban_reason': 'Security review',
            'start_at': '2026-11-07T10:00:00Z',
            'end_at': '2026-11-09T10:00:00Z',
          },
        ],
      });

      expect(model, isA<PlatformUserDetailEntity>());
      expect(model.user, isA<PlatformUserEntity>());
      expect(model.user, isA<PlatformUserModel>());
      expect(model.user.id, 41);
      expect(model.user.roleName, 'Support Agent');
      expect(model.twoFactorEnabled, isTrue);
      expect(model.devices.single, isA<PlatformUserDeviceEntity>());
      expect(model.devices.single.id, 8);
      expect(model.devices.single.type, 'WINDOWS');
      expect(model.securityBans.single, isA<PlatformUserBanEntity>());
      expect(model.securityBans.single.reason, 'Security review');
    });

    test('tolerates absent optional security relationships', () {
      final model = PlatformUserDetailModel.fromJson({
        'user_id': 42,
        'role_id': 3,
        'user_full_name': 'Support Operator',
        'user_phone_number': '779876543',
        'status': 'ACTIVE',
      });

      expect(model, isA<PlatformUserDetailEntity>());
      expect(model.user.id, 42);
      expect(model.devices, isEmpty);
      expect(model.securityBans, isEmpty);
    });
  });
}
