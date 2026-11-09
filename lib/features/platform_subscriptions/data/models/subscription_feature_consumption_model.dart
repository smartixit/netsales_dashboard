import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_consumption_entity.dart';

class SubscriptionFeatureConsumptionModel extends SubscriptionFeatureConsumptionEntity {
  const SubscriptionFeatureConsumptionModel({
    required super.id, required super.subscriptionId, required super.featureId,
    required super.consumedValue, super.featureName, super.limitValue, super.lastConsumedAt,
  });

  factory SubscriptionFeatureConsumptionModel.fromJson(Map<String, dynamic> json) {
    final featurePlan = json['plan_feature'];
    final featurePlanMap = featurePlan is Map ? Map<String, dynamic>.from(featurePlan) : null;
    final feature = featurePlanMap?['feature'];
    return SubscriptionFeatureConsumptionModel(
      id: _int(json['consumption_id']),
      subscriptionId: _int(json['subscription_id']),
      featureId: _int(json['feature_id']),
      consumedValue: json['consumption_value']?.toString() ?? '0',
      featureName: feature is Map ? feature['feature_name']?.toString() : null,
      limitValue: featurePlanMap?['plan_feature_value']?.toString(),
      lastConsumedAt: _date(json['last_consumption_at']),
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
