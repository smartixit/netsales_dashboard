import 'package:netsales_dashboard/core/enums/subscription_feature_value_type.dart';

class SubscriptionFeatureEntity {
  const SubscriptionFeatureEntity({
    required this.id,
    required this.name,
    required this.valueType,
    required this.isActive,
    this.defaultValue,
    this.description,
    this.valueTypeLabel,
    this.createdAt,
  });

  final int id;
  final String name;
  final String valueType;
  final String? valueTypeLabel;
  final String? defaultValue;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;

  SubscriptionFeatureValueType get typedValueType =>
      SubscriptionFeatureValueType.fromWire(valueType);
}
