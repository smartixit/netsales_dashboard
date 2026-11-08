import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_networks/data/models/platform_network_model.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';

void main() {
  group('PlatformNetworkModel', () {
    test('parses NetworkResource directly as a Domain entity', () {
      final model = PlatformNetworkModel.fromJson({
        'network_id': 73,
        'owner_id': 12,
        'network_uuid': 'NET-000073',
        'network_name': 'Al Noor Network',
        'network_profile_logo': 'https://cdn.example.test/networks/73.png',
        'network_holder_name': 'Network Owner',
        'network_phone_number': '771234567',
        'network_email': 'owner@example.test',
        'governorate_id': 4,
        'directorate_id': 9,
        'network_address': 'Main street',
        'approved_by': 2,
        'rejected_by': null,
        'approved_at': '2026-11-01T10:00:00Z',
        'rejected_at': null,
        'rejection_reason': null,
        'status': 'ACTIVE',
        'status_label': 'مفعّل',
        'created_at': '2026-10-01T10:00:00Z',
        'updated_at': '2026-11-02T10:00:00Z',
        'governorate': {'governorate_id': 4, 'governorate_name': 'عدن'},
        'directorate': {'directorate_id': 9, 'directorate_name': 'المنصورة'},
      });

      expect(model, isA<PlatformNetworkEntity>());
      expect(model.id, 73);
      expect(model.ownerId, 12);
      expect(model.uuid, 'NET-000073');
      expect(model.name, 'Al Noor Network');
      expect(model.ownerName, 'Network Owner');
      expect(model.governorateName, 'عدن');
      expect(model.directorateName, 'المنصورة');
      expect(model.status, 'ACTIVE');
      expect(model.statusLabel, 'مفعّل');
      expect(model.approvedAt, isA<DateTime>());
    });

    test('parses owner relation and tolerates absent optional fields', () {
      final model = PlatformNetworkModel.fromJson({
        'network_id': 74,
        'network_name': 'North Network',
        'status': 'PENDING',
        'owner': {'user_full_name': 'Relation Owner'},
      });

      expect(model, isA<PlatformNetworkEntity>());
      expect(model.ownerName, 'Relation Owner');
      expect(model.logo, isNull);
      expect(model.phoneNumber, isNull);
      expect(model.createdAt, isNull);
    });
  });
}
