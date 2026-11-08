import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';

class SubscriptionPlanFeatureEntity {
  const SubscriptionPlanFeatureEntity({
    required this.id,
    required this.planId,
    required this.featureId,
    required this.value,
    required this.isActive,
    this.feature,
  });

  final int id;
  final int planId;
  final int featureId;
  final String value;
  final bool isActive;
  final SubscriptionFeatureEntity? feature;
}
