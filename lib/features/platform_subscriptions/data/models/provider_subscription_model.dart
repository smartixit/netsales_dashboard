import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_consumption_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';

class ProviderSubscriptionModel extends ProviderSubscriptionEntity {
  const ProviderSubscriptionModel({
    required super.id, required super.networkId, required super.planId,
    required super.status, super.statusLabel, super.networkName, super.networkUuid,
    super.planName, super.startDate, super.endDate, super.createdAt,
    super.consumptions = const <SubscriptionFeatureConsumptionEntity>[],
  });

  factory ProviderSubscriptionModel.fromJson(Map<String, dynamic> json) {
    final rawNetwork = json['network'];
    final rawPlan = json['plan'];
    final network = rawNetwork is Map<Object?, Object?>
        ? Map<String, dynamic>.from(rawNetwork)
        : const <String, dynamic>{};
    final plan = rawPlan is Map<Object?, Object?>
        ? Map<String, dynamic>.from(rawPlan)
        : const <String, dynamic>{};
    final consumptions = json['consumptions'];
    return ProviderSubscriptionModel(
      id: _int(json['subscription_id']),
      networkId: _int(json['network_id']),
      planId: _int(json['plan_id']),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      networkName: network['network_name']?.toString(),
      networkUuid: network['network_uuid']?.toString(),
      planName: plan['plan_name']?.toString(),
      startDate: _date(json['subscription_start_date']),
      endDate: _date(json['subscription_end_date']),
      createdAt: _date(json['created_at']),
      consumptions: consumptions is List
          ? consumptions.whereType<Map<Object?, Object?>>().map((v) => SubscriptionFeatureConsumptionModel.fromJson(Map<String, dynamic>.from(v))).toList(growable: false)
          : const [],
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
