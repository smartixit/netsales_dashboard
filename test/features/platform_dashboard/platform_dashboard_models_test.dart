import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_activity_model.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_dashboard_overview_model.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_notification_model.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';

void main() {
  group('PlatformDashboardOverviewModel', () {
    test('parses API payload into a model that is itself the domain entity', () {
      final model = PlatformDashboardOverviewModel.fromJson({
        'generated_at': '2026-11-08T10:00:00Z',
        'timezone': 'Asia/Aden',
        'period': {
          'key': '30d',
          'days': 30,
          'from': '2026-10-09T00:00:00Z',
          'to': '2026-11-08T00:00:00Z',
        },
        'metrics': {
          'networks': {
            'total': 12,
            'active': 9,
            'pending': 2,
            'inactive': 1,
            'rejected': 0,
            'banned': 0,
          },
          'subscriptions': {
            'total': 25,
            'active': 18,
            'queued': 2,
            'expired': 5,
            'expiring_within_7_days': 3,
          },
        },
        'charts': {
          'subscription_trend': [
            {'period': '2026-11-01', 'value': 7},
          ],
          'provider_distribution': [
            {
              'entity': 'network',
              'status': 'ACTIVE',
              'status_label': 'Active',
              'value': 9,
            },
          ],
          'operational_activity': [
            {'date': '2026-11-08', 'value': 14},
          ],
        },
        'attention': {
          'expiring_subscriptions': {
            'count': 1,
            'items': [
              {
                'id': 101,
                'title': 'Subscription expires soon',
                'subtitle': 'Provider 101',
                'route_key': 'subscriptions',
                'due_at': '2026-11-10T00:00:00Z',
              },
            ],
          },
        },
        'recent_activity': [
          {
            'id': 91,
            'title': 'Provider approved',
            'module': 'networks',
            'entity_type': 'network',
            'entity_id': 101,
            'actor_name': 'Platform Admin',
            'context_label': 'Network 101',
            'occurred_at': '2026-11-08T09:00:00Z',
            'source': 'system_log',
          },
        ],
      });

      final entity = model;
      expect(model, isA<PlatformDashboardOverviewEntity>());
      expect(entity.timezone, 'Asia/Aden');
      expect(entity.period.days, 30);
      expect(entity.metrics.networks?.active, 9);
      expect(entity.metrics.subscriptions?.expiringWithin7Days, 3);
      expect(entity.charts.subscriptionTrend.single.value, 7);
      expect(entity.charts.providerDistribution.single.statusLabel, 'Active');
      expect(entity.charts.operationalActivity.single.value, 14);
      expect(entity.attentionGroups.single.items.single.id, 101);
      expect(entity.recentActivity.single.actorName, 'Platform Admin');
    });

    test('tolerates absent optional dashboard sections', () {
      final entity = PlatformDashboardOverviewModel.fromJson({
        'period': {'key': '7d', 'days': 7},
      });

      expect(entity.period.key, '7d');
      expect(entity.metrics.networks, isNull);
      expect(entity.charts.subscriptionTrend, isEmpty);
      expect(entity.attentionGroups, isEmpty);
      expect(entity.recentActivity, isEmpty);
    });
  });

  test('activity model is a domain entity and parses transport fields', () {
    final entity = PlatformActivityModel.fromJson({
      'log_id': 8,
      'module': 'users',
      'action': 'created',
      'entity_type': 'user',
      'entity_id': 12,
      'user': {'user_full_name': 'Platform Admin'},
      'log_date': '2026-11-08T10:00:00Z',
    });

    expect(entity, isA<PlatformActivityEntity>());
    expect(entity.id, 8);
    expect(entity.entityId, 12);
    expect(entity.actorName, 'Platform Admin');
    expect(entity.timestamp, isNotNull);
  });

  test('notification model is a domain entity and parses transport fields', () {
    final entity = PlatformNotificationModel.fromJson({
      'notification_id': 4,
      'notification_title': 'New request',
      'notification_message': 'A request needs review.',
      'notification_type': 'REQUEST',
      'notification_type_label': 'Request',
      'is_read': false,
      'created_at': '2026-11-08T10:00:00Z',
    });

    expect(entity, isA<PlatformNotificationEntity>());
    expect(entity.id, 4);
    expect(entity.title, 'New request');
    expect(entity.isRead, isFalse);
    expect(entity.createdAt, isNotNull);
  });
}
