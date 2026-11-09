import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/provider_subscription_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_plan_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_request_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';

void main() {
  group('Platform subscription response models', () {
    test('plan model inherits entity and parses nested plan features', () {
      final model = SubscriptionPlanModel.fromJson({
        'plan_id': 7,
        'plan_uuid': 'PLAN-0007',
        'plan_name': 'Enterprise',
        'plan_price': '250.00',
        'plan_discount': '10',
        'plan_validity': 30,
        'plan_desc': 'Enterprise package',
        'status': true,
        'features': [
          {'feature_id': 2, 'feature_name': 'Networks', 'feature_value_type': 'INTEGER', 'feature_value': '5', 'status': true},
        ],
        'plan_features': [
          {
            'subscription_plan_feature_id': 11,
            'plan_id': 7,
            'feature_id': 2,
            'plan_feature_value': '-1',
            'status': true,
            'feature': {'feature_id': 2, 'feature_name': 'Networks', 'feature_value_type': 'INTEGER', 'status': true},
          },
        ],
        'created_at': '2026-11-08 09:00:00',
      });

      expect(model, isA<SubscriptionPlanEntity>());
      expect(model.id, 7);
      expect(model.name, 'Enterprise');
      expect(model.price, '250.00');
      expect(model.validityDays, 30);
      expect(model.isActive, isTrue);
      expect(model.features.single.name, 'Networks');
      expect(model.planFeatures.single.value, '-1');
      expect(model.planFeatures.single.feature?.name, 'Networks');
      expect(model.createdAt, DateTime(2026, 11, 8, 9));
    });

    test('provider subscription model inherits entity and parses server usage', () {
      final model = ProviderSubscriptionModel.fromJson({
        'subscription_id': 22,
        'network_id': 4,
        'plan_id': 7,
        'status': 'ACTIVE',
        'status_label': 'نشط',
        'subscription_start_date': '2026-11-01 00:00:00',
        'subscription_end_date': '2026-12-01 00:00:00',
        'network': {'network_name': 'Al Noor'},
        'plan': {'plan_name': 'Enterprise'},
        'consumptions': [
          {'consumption_id': 3, 'subscription_id': 22, 'feature_id': 2, 'consumption_value': '14', 'last_consumption_at': '2026-11-08 10:00:00'},
        ],
      });

      expect(model, isA<ProviderSubscriptionEntity>());
      expect(model.networkName, 'Al Noor');
      expect(model.planName, 'Enterprise');
      expect(model.status, 'ACTIVE');
      expect(model.consumptions.single.consumedValue, '14');
    });

    test('request model inherits entity and parses exact request resource keys', () {
      final model = SubscriptionRequestModel.fromJson({
        'request_id': 91,
        'network_id': 4,
        'plan_id': 7,
        'request_uuid': 'REQ-0091',
        'request_total_amount': 225.5,
        'request_payment_type': 'BANK',
        'request_payment_type_label': 'بنكي',
        'status': 'PENDING',
        'status_label': 'قيد المراجعة',
        'transaction_reference': 'TX-2026-001',
        'transaction_receipt': 'receipts/subscriptions/91.pdf',
        'request_note': 'Renewal',
        'network': {'network_name': 'Al Noor', 'network_phone_number': '771234567'},
        'plan': {'plan_name': 'Enterprise'},
        'requested_by_user': {'user_full_name': 'Network Owner'},
        'bank_account': {'account_name': 'Main Bank'},
      });

      expect(model, isA<SubscriptionRequestEntity>());
      expect(model.id, 91);
      expect(model.networkName, 'Al Noor');
      expect(model.planName, 'Enterprise');
      expect(model.totalAmount, '225.5');
      expect(model.paymentType, 'BANK');
      expect(model.bankAccountName, 'Main Bank');
      expect(model.receiptPath, 'receipts/subscriptions/91.pdf');
      expect(model.typedStatus.wireValue, 'PENDING');
    });
  });
}
