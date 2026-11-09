import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_consumption_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';

class ProviderSubscriptionModel extends ProviderSubscriptionEntity {
  const ProviderSubscriptionModel({
    required super.id, required super.networkId, required super.planId,
    required super.status, super.statusLabel, super.networkName, super.networkUuid,
    super.planName, super.startDate, super.endDate, super.createdAt,
    super.consumptions = const [],
  });

  factory ProviderSubscriptionModel.fromJson(Map<String, dynamic> json) {
    final network = json['network'];
    final plan = json['plan'];
    final consumptions = json['consumptions'];
    return ProviderSubscriptionModel(
      id: _int(json['subscription_id']),
      networkId: _int(json['network_id']),
      planId: _int(json['plan_id']),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      networkName: network is Map ? network['network_name']?.toString() : null,
      networkUuid: network is Map ? network['network_uuid']?.toString() : null,
      planName: plan is Map ? plan['plan_name']?.toString() : null,
      startDate: _date(json['subscription_start_date']),
      endDate: _date(json['subscription_end_date']),
      createdAt: _date(json['created_at']),
      consumptions: consumptions is List
          ? consumptions.whereType<Map>().map((v) => SubscriptionFeatureConsumptionModel.fromJson(Map<String, dynamic>.from(v))).toList(growable: false)
          : const [],
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
