import 'package:netsales_dashboard/core/enums/provider_subscription_status.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_consumption_entity.dart';

class ProviderSubscriptionEntity {
  const ProviderSubscriptionEntity({
    required this.id,
    required this.networkId,
    required this.planId,
    required this.status,
    this.statusLabel,
    this.networkName,
    this.networkUuid,
    this.planName,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.consumptions = const <SubscriptionFeatureConsumptionEntity>[],
  });

  final int id;
  final int networkId;
  final int planId;
  final String status;
  final String? statusLabel;
  final String? networkName;
  final String? networkUuid;
  final String? planName;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final List<SubscriptionFeatureConsumptionEntity> consumptions;

  ProviderSubscriptionStatus get typedStatus =>
      ProviderSubscriptionStatus.fromWire(status);
}
