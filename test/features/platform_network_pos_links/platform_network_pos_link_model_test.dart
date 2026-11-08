import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/models/platform_network_pos_link_model.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';

void main() {
  group('PlatformNetworkPosLinkModel', () {
    test('inherits its domain entity and parses the exact NetworkPosResource contract', () {
      final model = PlatformNetworkPosLinkModel.fromJson({
        'network_pos_id': 18,
        'network_id': 4,
        'pos_id': 9,
        'status': true,
        'created_at': '2026-11-08 10:30:00',
        'updated_at': '2026-11-08 11:00:00',
        'network': {
          'network_id': 4,
          'network_uuid': 'NET-0004',
          'network_name': 'Al Noor Network',
          'network_profile_logo': 'https://cdn.example.test/network.png',
        },
        'pos': {
          'pos_id': 9,
          'pos_uuid': 'POS-0009',
          'pos_name': 'Al Noor Store',
          'pos_profile_logo': 'https://cdn.example.test/pos.png',
          'pos_phone_number': '771234567',
        },
      });

      expect(model, isA<PlatformNetworkPosLinkEntity>());
      expect(model.id, 18);
      expect(model.networkId, 4);
      expect(model.posId, 9);
      expect(model.isActive, isTrue);
      expect(model.networkName, 'Al Noor Network');
      expect(model.networkUuid, 'NET-0004');
      expect(model.networkLogo, 'https://cdn.example.test/network.png');
      expect(model.posName, 'Al Noor Store');
      expect(model.posUuid, 'POS-0009');
      expect(model.posLogo, 'https://cdn.example.test/pos.png');
      expect(model.posPhoneNumber, '771234567');
      expect(model.createdAt, DateTime(2026, 11, 8, 10, 30));
    });

    test('handles boolean false and absent optional relationships safely', () {
      final model = PlatformNetworkPosLinkModel.fromJson({
        'network_pos_id': '19',
        'network_id': '5',
        'pos_id': '10',
        'status': false,
      });

      expect(model, isA<PlatformNetworkPosLinkEntity>());
      expect(model.id, 19);
      expect(model.isActive, isFalse);
      expect(model.networkName, isNull);
      expect(model.posName, isNull);
      expect(model.createdAt, isNull);
    });
  });
}
