import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_feature_entity.dart';

class SubscriptionPlanEntity {
  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.validityDays,
    required this.isActive,
    this.uuid,
    this.description,
    this.features = const <SubscriptionFeatureEntity>[],
    this.planFeatures = const <SubscriptionPlanFeatureEntity>[],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? uuid;
  final String name;
  final String price;
  final String discount;
  final int validityDays;
  final String? description;
  final bool isActive;
  final List<SubscriptionFeatureEntity> features;
  final List<SubscriptionPlanFeatureEntity> planFeatures;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
