import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';

class SubscriptionFeatureModel extends SubscriptionFeatureEntity {
  const SubscriptionFeatureModel({
    required super.id, required super.name, required super.valueType,
    required super.isActive, super.defaultValue, super.description,
    super.valueTypeLabel, super.createdAt,
  });

  factory SubscriptionFeatureModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionFeatureModel(
        id: _int(json['feature_id']),
        name: json['feature_name']?.toString() ?? '',
        valueType: json['feature_value_type']?.toString() ?? 'UNKNOWN',
        valueTypeLabel: json['feature_value_type_label']?.toString(),
        defaultValue: json['feature_value']?.toString(),
        description: json['feature_desc']?.toString(),
        isActive: json['status'] == true || json['status'] == 1 || json['status'] == '1',
        createdAt: _date(json['created_at']),
      );
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
