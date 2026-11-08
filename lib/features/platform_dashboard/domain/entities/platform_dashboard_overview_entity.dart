import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';

class PlatformDashboardOverviewEntity {
  const PlatformDashboardOverviewEntity({
    required this.generatedAt,
    required this.timezone,
    required this.period,
    required this.metrics,
    required this.charts,
    required this.attentionGroups,
    required this.recentActivity,
  });

  final DateTime? generatedAt;
  final String timezone;
  final PlatformDashboardPeriodEntity period;
  final PlatformDashboardMetricsEntity metrics;
  final PlatformDashboardChartsEntity charts;
  final List<PlatformDashboardAttentionGroupEntity> attentionGroups;
  final List<PlatformActivityEntity> recentActivity;
}

class PlatformDashboardPeriodEntity {
  const PlatformDashboardPeriodEntity({
    required this.key,
    required this.days,
    required this.from,
    required this.to,
  });

  final String key;
  final int days;
  final DateTime? from;
  final DateTime? to;
}

class PlatformDashboardMetricsEntity {
  const PlatformDashboardMetricsEntity({
    this.networks,
    this.pos,
    this.subscriptions,
    this.support,
    this.sales,
    this.expenses,
  });

  final PlatformEntityStatusMetricEntity? networks;
  final PlatformEntityStatusMetricEntity? pos;
  final PlatformSubscriptionMetricEntity? subscriptions;
  final PlatformSupportMetricEntity? support;
  final PlatformSalesMetricEntity? sales;
  final PlatformExpensesMetricEntity? expenses;
}

class PlatformEntityStatusMetricEntity {
  const PlatformEntityStatusMetricEntity({
    required this.total,
    required this.active,
    required this.pending,
    required this.inactive,
    required this.rejected,
    required this.banned,
  });

  final int total;
  final int active;
  final int pending;
  final int inactive;
  final int rejected;
  final int banned;
}

class PlatformSubscriptionMetricEntity {
  const PlatformSubscriptionMetricEntity({
    required this.total,
    required this.active,
    required this.queued,
    required this.expired,
    required this.expiringWithin7Days,
  });

  final int total;
  final int active;
  final int queued;
  final int expired;
  final int expiringWithin7Days;
}

class PlatformSupportMetricEntity {
  const PlatformSupportMetricEntity({
    required this.totalTickets,
    required this.unreadMessages,
  });

  final int totalTickets;
  final int unreadMessages;
}

class PlatformSalesMetricEntity {
  const PlatformSalesMetricEntity({
    required this.invoiceCount,
    required this.totalAmount,
    required this.paidAmount,
    required this.outstandingAmount,
  });

  final int invoiceCount;
  final String totalAmount;
  final String paidAmount;
  final String outstandingAmount;
}

class PlatformExpensesMetricEntity {
  const PlatformExpensesMetricEntity({
    required this.count,
    required this.totalAmount,
  });

  final int count;
  final String totalAmount;
}

class PlatformDashboardChartsEntity {
  const PlatformDashboardChartsEntity({
    required this.subscriptionTrend,
    required this.providerDistribution,
    required this.operationalActivity,
  });

  final List<PlatformSubscriptionTrendPointEntity> subscriptionTrend;
  final List<PlatformProviderDistributionPointEntity> providerDistribution;
  final List<PlatformOperationalActivityPointEntity> operationalActivity;
}

class PlatformSubscriptionTrendPointEntity {
  const PlatformSubscriptionTrendPointEntity({
    required this.period,
    required this.value,
  });

  final String period;
  final int value;
}

class PlatformProviderDistributionPointEntity {
  const PlatformProviderDistributionPointEntity({
    required this.entity,
    required this.status,
    required this.statusLabel,
    required this.value,
  });

  final String entity;
  final String status;
  final String statusLabel;
  final int value;
}

class PlatformOperationalActivityPointEntity {
  const PlatformOperationalActivityPointEntity({
    required this.date,
    required this.value,
  });

  final String date;
  final int value;
}

class PlatformDashboardAttentionGroupEntity {
  const PlatformDashboardAttentionGroupEntity({
    required this.key,
    required this.count,
    required this.items,
  });

  final String key;
  final int count;
  final List<PlatformDashboardAttentionItemEntity> items;
}

class PlatformDashboardAttentionItemEntity {
  const PlatformDashboardAttentionItemEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.routeKey,
    required this.occurredAt,
    required this.dueAt,
  });

  final int id;
  final String title;
  final String subtitle;
  final String routeKey;
  final DateTime? occurredAt;
  final DateTime? dueAt;
}
