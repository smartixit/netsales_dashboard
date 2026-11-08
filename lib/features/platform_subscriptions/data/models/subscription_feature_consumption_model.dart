import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_consumption_entity.dart';

class SubscriptionFeatureConsumptionModel extends SubscriptionFeatureConsumptionEntity {
  const SubscriptionFeatureConsumptionModel({
    required super.id, required super.subscriptionId, required super.featureId,
    required super.consumedValue, super.featureName, super.limitValue, super.lastConsumedAt,
  });

  factory SubscriptionFeatureConsumptionModel.fromJson(Map<String, dynamic> json) {
    final feature = json['plan_feature'];
    final featureMap = feature is Map ? Map<String, dynamic>.from(feature) : null;
    final nestedFeature = featureMap?['feature'];
    return SubscriptionFeatureConsumptionModel(
      id: _int(json['consumption_id']),
      subscriptionId: _int(json['subscription_id']),
      featureId: _int(json['feature_id']),
      consumedValue: json['consumption_value']?.toString() ?? '0',
      featureName: nestedFeature is Map ? nestedFeature['feature_name']?.toString() : null,
      limitValue: featureMap?['plan_feature_value']?.toString(),
      lastConsumedAt: _date(json['last_consumption_at']),
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
