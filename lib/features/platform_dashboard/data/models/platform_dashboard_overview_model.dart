import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';

/// نموذج نقل لاستجابة Platform Dashboard Overview.
class PlatformDashboardOverviewModel {
  const PlatformDashboardOverviewModel(this._json);

  final Map<String, dynamic> _json;

  factory PlatformDashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return PlatformDashboardOverviewModel(Map<String, dynamic>.from(json));
  }

  PlatformDashboardOverviewEntity toEntity() {
    final rawPeriod = _asMap(_json['period']);
    final rawMetrics = _asMap(_json['metrics']);
    final rawCharts = _asMap(_json['charts']);
    final rawAttention = _asMap(_json['attention']);

    return PlatformDashboardOverviewEntity(
      generatedAt: _dateTime(_json['generated_at']),
      timezone: _json['timezone']?.toString() ?? 'Asia/Aden',
      period: PlatformDashboardPeriodEntity(
        key: rawPeriod['key']?.toString() ?? '30d',
        days: _asInt(rawPeriod['days']),
        from: _dateTime(rawPeriod['from']),
        to: _dateTime(rawPeriod['to']),
      ),
      metrics: PlatformDashboardMetricsEntity(
        networks: _statusMetric(rawMetrics['networks']),
        pos: _statusMetric(rawMetrics['pos']),
        subscriptions: _subscriptionMetric(rawMetrics['subscriptions']),
        support: _supportMetric(rawMetrics['support']),
        sales: _salesMetric(rawMetrics['sales']),
        expenses: _expensesMetric(rawMetrics['expenses']),
      ),
      charts: PlatformDashboardChartsEntity(
        subscriptionTrend: _asList(rawCharts['subscription_trend'])
            .map((item) {
              final map = _asMap(item);
              return PlatformSubscriptionTrendPointEntity(
                period: map['period']?.toString() ?? '',
                value: _asInt(map['value']),
              );
            }).toList(growable: false),
        providerDistribution: _asList(rawCharts['provider_distribution'])
            .map((item) {
              final map = _asMap(item);
              return PlatformProviderDistributionPointEntity(
                entity: map['entity']?.toString() ?? '',
                status: map['status']?.toString() ?? '',
                statusLabel: map['status_label']?.toString() ??
                    map['status']?.toString() ?? '',
                value: _asInt(map['value']),
              );
            }).toList(growable: false),
        operationalActivity: _asList(rawCharts['operational_activity'])
            .map((item) {
              final map = _asMap(item);
              return PlatformOperationalActivityPointEntity(
                date: map['date']?.toString() ?? '',
                value: _asInt(map['value']),
              );
            }).toList(growable: false),
      ),
      attentionGroups: rawAttention.entries.map((entry) {
        final group = _asMap(entry.value);
        final items = _asList(group['items']).map((item) {
          final map = _asMap(item);
          return PlatformDashboardAttentionItemEntity(
            id: _asInt(map['id']),
            title: map['title']?.toString() ?? '',
            subtitle: map['subtitle']?.toString() ?? '',
            routeKey: map['route_key']?.toString() ?? '',
            occurredAt: _dateTime(map['occurred_at']),
            dueAt: _dateTime(map['due_at']),
          );
        }).toList(growable: false);
        return PlatformDashboardAttentionGroupEntity(
          key: entry.key,
          count: _asInt(group['count']),
          items: items,
        );
      }).toList(growable: false),
      recentActivity: _asList(_json['recent_activity']).map((item) {
        final map = _asMap(item);
        return PlatformActivityEntity(
          id: _asInt(map['id']),
          action: map['title']?.toString() ?? '',
          module: map['module']?.toString() ?? '',
          entityType: map['entity_type']?.toString() ?? '',
          entityId: _nullableInt(map['entity_id']),
          actorName: _nullableString(map['actor_name']),
          contextLabel: _nullableString(map['context_label']),
          timestamp: _dateTime(map['occurred_at']),
          source: _nullableString(map['source']),
        );
      }).toList(growable: false),
    );
  }

  static PlatformEntityStatusMetricEntity? _statusMetric(dynamic value) {
    if (value is! Map<Object?, Object?>) return null;
    final map = _asMap(value);
    return PlatformEntityStatusMetricEntity(
      total: _asInt(map['total']),
      active: _asInt(map['active']),
      pending: _asInt(map['pending']),
      inactive: _asInt(map['inactive']),
      rejected: _asInt(map['rejected']),
      banned: _asInt(map['banned']),
    );
  }

  static PlatformSubscriptionMetricEntity? _subscriptionMetric(dynamic value) {
    if (value is! Map<Object?, Object?>) return null;
    final map = _asMap(value);
    return PlatformSubscriptionMetricEntity(
      total: _asInt(map['total']),
      active: _asInt(map['active']),
      queued: _asInt(map['queued']),
      expired: _asInt(map['expired']),
      expiringWithin7Days: _asInt(map['expiring_within_7_days']),
    );
  }

  static PlatformSupportMetricEntity? _supportMetric(dynamic value) {
    if (value is! Map<Object?, Object?>) return null;
    final map = _asMap(value);
    return PlatformSupportMetricEntity(
      totalTickets: _asInt(map['total_tickets']),
      unreadMessages: _asInt(map['unread_messages']),
    );
  }

  static PlatformSalesMetricEntity? _salesMetric(dynamic value) {
    if (value is! Map<Object?, Object?>) return null;
    final map = _asMap(value);
    return PlatformSalesMetricEntity(
      invoiceCount: _asInt(map['invoice_count']),
      totalAmount: map['total_amount']?.toString() ?? '0.00',
      paidAmount: map['paid_amount']?.toString() ?? '0.00',
      outstandingAmount: map['outstanding_amount']?.toString() ?? '0.00',
    );
  }

  static PlatformExpensesMetricEntity? _expensesMetric(dynamic value) {
    if (value is! Map<Object?, Object?>) return null;
    final map = _asMap(value);
    return PlatformExpensesMetricEntity(
      count: _asInt(map['count']),
      totalAmount: map['total_amount']?.toString() ?? '0.00',
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map<Object?, Object?>) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static List<dynamic> _asList(dynamic value) =>
      value is List ? value : const <dynamic>[];

  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static int? _nullableInt(dynamic value) =>
      value == null ? null : _asInt(value);

  static String? _nullableString(dynamic value) => value?.toString();

  static DateTime? _dateTime(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
