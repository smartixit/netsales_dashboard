class SubscriptionFeatureConsumptionEntity {
  const SubscriptionFeatureConsumptionEntity({
    required this.id,
    required this.subscriptionId,
    required this.featureId,
    required this.consumedValue,
    this.featureName,
    this.limitValue,
    this.lastConsumedAt,
  });

  final int id;
  final int subscriptionId;
  final int featureId;
  final String consumedValue;
  final String? featureName;
  final String? limitValue;
  final DateTime? lastConsumedAt;
}
