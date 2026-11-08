import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';

class SubscriptionPlanEntity {
  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.validityDays,
    required this.status,
    this.uuid,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.features = const [],
    this.planFeatures = const [],
  });

  final int id;
  final String? uuid;
  final String name;
  /// Server-provided decimal string. Never calculate a client-side price.
  final String price;
  /// Server-provided discount percentage string.
  final String discount;
  final int validityDays;
  final String? description;
  final bool status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SubscriptionFeatureEntity> features;
  final List<SubscriptionPlanFeatureEntity> planFeatures;
}