import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_plan_feature_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.id, required super.name, required super.price,
    required super.discount, required super.validityDays, required super.isActive,
    super.uuid, super.description, super.features = const [],
    super.planFeatures = const [], super.createdAt, super.updatedAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    final features = json['features'];
    final planFeatures = json['plan_features'];
    return SubscriptionPlanModel(
      id: _int(json['plan_id']),
      uuid: json['plan_uuid']?.toString(),
      name: json['plan_name']?.toString() ?? '',
      price: json['plan_price']?.toString() ?? '0',
      discount: json['plan_discount']?.toString() ?? '0',
      validityDays: _int(json['plan_validity']),
      description: json['plan_desc']?.toString(),
      isActive: json['status'] == true || json['status'] == 1 || json['status'] == '1',
      features: features is List
          ? features.whereType<Map>().map((v) => SubscriptionFeatureModel.fromJson(_map(v))).toList(growable: false)
          : const [],
      planFeatures: planFeatures is List
          ? planFeatures.whereType<Map>().map((v) => SubscriptionPlanFeatureModel.fromJson(_map(v))).toList(growable: false)
          : const [],
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw const FormatException('Invalid subscription plan resource.');
}
