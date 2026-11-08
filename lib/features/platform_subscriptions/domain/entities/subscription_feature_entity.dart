class SubscriptionFeatureEntity {
  const SubscriptionFeatureEntity({
    required this.id,
    required this.name,
    required this.valueType,
    required this.value,
    required this.status,
    this.valueTypeLabel,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String valueType;
  final String? valueTypeLabel;
  final String value;
  final String? description;
  final bool status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class SubscriptionPlanFeatureEntity {
  const SubscriptionPlanFeatureEntity({
    required this.id,
    required this.planId,
    required this.featureId,
    required this.value,
    required this.status,
    this.feature,
  });

  final int id;
  final int planId;
  final int featureId;
  final String value;
  final bool status;
  final SubscriptionFeatureEntity? feature;
}