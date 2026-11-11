import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_billing/data/models/platform_billing_models.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';

void main() {
  group('Platform billing wire contracts', () {
    test('subscription statuses preserve exact Laravel wire values', () {
      expect(BillingSubscriptionStatus.fromWire('ACTIVE'), BillingSubscriptionStatus.active);
      expect(BillingSubscriptionStatus.fromWire('TRIALING'), BillingSubscriptionStatus.trialing);
      expect(BillingSubscriptionStatus.fromWire('PAST_DUE'), BillingSubscriptionStatus.pastDue);
      expect(BillingSubscriptionStatus.fromWire('future_value'), BillingSubscriptionStatus.unknown);
    });

    test('invoice and payment statuses have forward-compatible unknown cases', () {
      expect(BillingInvoiceStatus.fromWire('PARTIALLY_PAID'), BillingInvoiceStatus.partiallyPaid);
      expect(BillingInvoiceStatus.fromWire('VOID'), BillingInvoiceStatus.voided);
      expect(BillingPaymentStatus.fromWire('PENDING_REVIEW'), BillingPaymentStatus.pendingReview);
      expect(BillingPaymentStatus.fromWire('NEW_STATUS'), BillingPaymentStatus.unknown);
    });

    test('plan model maps published version, currency-specific prices and features', () {
      final plan = BillingPlanModel.fromJson({
        'plan_id': 7,
        'plan_key': 'pro',
        'name': 'Professional',
        'is_public': true,
        'is_active': true,
        'current_version': {
          'plan_version_id': 12,
          'version_number': 3,
          'status': 'PUBLISHED',
          'prices': [
            {
              'price_id': 91,
              'currency': {
                'currency_id': 4,
                'code': 'YER',
                'name': 'Yemeni Rial',
                'decimal_places': 2,
                'is_active': true,
              },
              'unit_amount_minor': 125000,
              'unit_amount': '1250.00',
              'setup_fee_minor': 0,
              'setup_fee': '0.00',
              'billing_interval': 'MONTH',
              'interval_count': 1,
              'is_active': true,
            },
          ],
          'features': [
            {
              'plan_feature_id': 3,
              'feature_key': 'max_users',
              'name': 'Maximum users',
              'feature_type': 'RESOURCE_LIMIT',
              'value': '25',
            },
          ],
        },
      });

      expect(plan.currentVersion?.typedStatus, BillingPlanVersionStatus.published);
      expect(plan.currentVersion?.prices.single.currency?.code, 'YER');
      expect(plan.currentVersion?.prices.single.unitAmountMinor, 125000);
      expect(plan.currentVersion?.prices.single.unitAmount, '1250.00');
      expect(plan.currentVersion?.prices.single.setupFee, '0.00');
      expect(plan.currentVersion?.features.single.key, 'max_users');
    });

    test('plan version history maps immutable draft and archived versions with complete prices', () {
      final version = BillingPlanVersionModel.fromJson({
        'plan_version_id': 44,
        'plan_id': 7,
        'version_number': 4,
        'status': 'DRAFT',
        'status_label': 'مسودة',
        'trial_policy_version_id': 9,
        'dunning_policy_version_id': 10,
        'prices': [
          {
            'price_id': 201,
            'currency': {
              'currency_id': 4,
              'code': 'YER',
              'name': 'Yemeni Rial',
              'decimal_places': 2,
            },
            'unit_amount_minor': 500000,
            'unit_amount': '5000.00',
            'setup_fee_minor': 25000,
            'setup_fee': '250.00',
            'billing_interval': 'MONTH',
            'interval_count': 1,
            'is_active': true,
          },
        ],
        'features': [
          {
            'plan_feature_id': 8,
            'feature_key': 'max_networks',
            'name': 'Maximum networks',
            'feature_type': 'RESOURCE_LIMIT',
            'value': '-1',
          },
        ],
      });

      expect(version.id, 44);
      expect(version.typedStatus, BillingPlanVersionStatus.draft);
      expect(version.trialPolicyVersionId, 9);
      expect(version.dunningPolicyVersionId, 10);
      expect(version.prices.single.unitAmount, '5000.00');
      expect(version.prices.single.setupFee, '250.00');
      expect(version.features.single.value, '-1');
    });

    test('product and price models preserve product keys and policy version links', () {
      final product = BillingProductModel.fromJson({
        'product_id': 12,
        'product_key': 'netsales-platform',
        'name': 'NetSales Platform',
        'description': 'Subscription product',
        'is_active': true,
      });
      final price = BillingPriceModel.fromJson({
        'price_id': 91,
        'currency': {
          'currency_id': 4,
          'code': 'YER',
          'name': 'Yemeni Rial',
          'decimal_places': 2,
        },
        'unit_amount_minor': 125000,
        'unit_amount': '1250.00',
        'setup_fee_minor': 0,
        'setup_fee': '0.00',
        'billing_interval': 'MONTH',
        'interval_count': 1,
        'trial_policy_version_id': 7,
        'dunning_policy_version_id': 8,
        'is_active': true,
      });

      expect(product.id, 12);
      expect(product.key, 'netsales-platform');
      expect(product.isActive, isTrue);
      expect(price.id, 91);
      expect(price.trialPolicyVersionId, 7);
      expect(price.dunningPolicyVersionId, 8);
      expect(price.currencyId, 4);
    });

    test('trial and dunning policy models map immutable current versions', () {
      final trial = BillingTrialPolicyModel.fromJson({
        'trial_policy_id': 3,
        'policy_key': 'new-network-trial',
        'name': 'New network trial',
        'is_active': true,
        'current_version': {
          'trial_policy_version_id': 31,
          'version_number': 2,
          'status': 'PUBLISHED',
          'is_enabled': true,
          'duration_value': 14,
          'duration_unit': 'DAY',
          'start_trigger': 'PURCHASE',
          'redemption_scope': 'BILLING_ACCOUNT',
          'eligibility_mode': 'NEW_BILLING_ACCOUNT',
          'requires_manual_approval': true,
          'end_behavior': 'CREATE_INVOICE',
          'entitlement_mode': 'FULL_PLAN',
          'entitlement_config': {'max_pos_count': 1},
          'published_at': '2026-11-01 10:00:00',
        },
      });
      final dunning = BillingDunningPolicyModel.fromJson({
        'dunning_policy_id': 5,
        'policy_key': 'standard-collection',
        'name': 'Standard collection',
        'is_active': true,
        'current_version': {
          'dunning_policy_version_id': 51,
          'version_number': 3,
          'status': 'PUBLISHED',
          'grace_period_days': 7,
          'auto_suspend_after_grace': true,
          'reminder_schedule_days': [0, 1, 3, 7],
          'pre_renewal_alert_days': [7, 3],
        },
      });

      expect(trial.currentVersion?.id, 31);
      expect(trial.currentVersion?.policyId, 3);
      expect(trial.currentVersion?.requiresManualApproval, isTrue);
      expect(trial.currentVersion?.entitlementConfig?['max_pos_count'], 1);
      expect(trial.currentVersion?.isPublished, isTrue);
      expect(dunning.currentVersion?.id, 51);
      expect(dunning.currentVersion?.policyId, 5);
      expect(dunning.currentVersion?.reminderScheduleDays, [0, 1, 3, 7]);
      expect(dunning.currentVersion?.autoSuspendAfterGrace, isTrue);
    });

    test('trial redemption joins policy and billing account context from nested resources', () {
      final redemption = BillingTrialRedemptionModel.fromJson({
        'trial_redemption_id': 19,
        'billing_subscription_id': 27,
        'trial_policy_id': 3,
        'trial_policy_version_id': 31,
        'network_id': 77,
        'billing_account_id': 88,
        'redemption_scope': 'BILLING_ACCOUNT',
        'redemption_subject_key': 'account:88',
        'status': 'PENDING_APPROVAL',
        'reserved_at': '2026-11-10 12:00:00',
        'policy': {
          'policy_key': 'new-network-trial',
          'name': 'New network trial',
        },
        'policy_version': {
          'version_number': 2,
        },
        'subscription': {
          'trial_end': null,
          'billing_account': {
            'billing_account_id': 88,
            'account_number': 'BA-000088',
            'network_id': 77,
            'network': {
              'network_name': 'North Network',
            },
          },
        },
        'metadata': {'source': 'signup'},
      });

      expect(redemption.id, 19);
      expect(redemption.subscriptionId, 27);
      expect(redemption.policyName, 'New network trial');
      expect(redemption.versionNumber, 2);
      expect(redemption.networkName, 'North Network');
      expect(redemption.accountNumber, 'BA-000088');
      expect(redemption.metadata?['source'], 'signup');
    });

    test('overview keeps financial figures partitioned by currency and uses server formatted values', () {
      final overview = BillingOverviewModel.fromJson({
        'period': {'from': '2026-11-01', 'to': '2026-11-30', 'as_of': '2026-11-11 10:00:00', 'timezone': 'Asia/Aden'},
        'counts': {
          'billing_accounts': 8,
          'subscriptions': {'total': 5, 'ACTIVE': 3, 'TRIALING': 2},
          'invoices': {'total': 9, 'PAID': 4, 'OPEN': 5},
        },
        'financials_by_currency': [
          {
            'currency': {'currency_id': 1, 'code': 'YER', 'name': 'Yemeni Rial', 'decimal_places': 2},
            'pending_payments': {'count': 1, 'amount_minor': 12500, 'amount': '125.00'},
            'open_invoices': {'count': 2, 'outstanding_minor': 30000, 'outstanding': '300.00'},
            'overdue_invoices': {'count': 1, 'outstanding_minor': 10000, 'outstanding': '100.00'},
            'verified_collections_this_month': {'count': 4, 'amount_minor': 50000, 'amount': '500.00'},
          },
          {
            'currency': {'currency_id': 2, 'code': 'USD', 'name': 'US Dollar', 'decimal_places': 2},
            'pending_payments': {'count': 0, 'amount_minor': 0, 'amount': '0.00'},
            'open_invoices': {'count': 1, 'outstanding_minor': 900, 'outstanding': '9.00'},
            'overdue_invoices': {'count': 0, 'outstanding_minor': 0, 'outstanding': '0.00'},
            'verified_collections_this_month': {'count': 1, 'amount_minor': 2000, 'amount': '20.00'},
          },
        ],
        'payment_review_queue': <Map<String, dynamic>>[],
      });

      expect(overview.billingAccountsCount, 8);
      expect(overview.subscriptions.countFor('ACTIVE'), 3);
      expect(overview.financialsByCurrency, hasLength(2));
      expect(overview.financialsByCurrency[0].verifiedCollections, '500.00');
      expect(overview.financialsByCurrency[1].currency.code, 'USD');
      expect(overview.financialsByCurrency[1].verifiedCollections, '20.00');
    });
  });
}
