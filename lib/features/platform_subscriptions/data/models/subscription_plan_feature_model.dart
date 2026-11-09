import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_feature_entity.dart';

class SubscriptionPlanFeatureModel extends SubscriptionPlanFeatureEntity {
  const SubscriptionPlanFeatureModel({
    required super.id, required super.planId, required super.featureId,
    required super.value, required super.isActive, super.feature,
  });

  factory SubscriptionPlanFeatureModel.fromJson(Map<String, dynamic> json) {
    final raw = json['feature'];
    return SubscriptionPlanFeatureModel(
      id: _int(json['subscription_plan_feature_id']),
      planId: _int(json['plan_id']),
      featureId: _int(json['feature_id']),
      value: json['plan_feature_value']?.toString() ?? '',
      isActive: json['status'] == true || json['status'] == 1 || json['status'] == '1',
      feature: raw is Map ? SubscriptionFeatureModel.fromJson(_map(raw)) : null,
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw const FormatException('Invalid feature resource.');
}
