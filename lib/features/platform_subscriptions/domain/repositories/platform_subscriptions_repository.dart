import 'dart:typed_data';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';

abstract interface class PlatformSubscriptionsRepository {
  Future<ApiResponse<List<SubscriptionPlanEntity>>> getPlans({
    String? search, String? status, String? cursor, int perPage = 20,
  });
  Future<SubscriptionPlanEntity> getPlan(int id);
  Future<SubscriptionPlanEntity> createPlan(Map<String, dynamic> data);
  Future<SubscriptionPlanEntity> updatePlan(int id, Map<String, dynamic> data);
  Future<bool> togglePlanStatus(int id);
  Future<void> deletePlan(int id);

  Future<ApiResponse<List<SubscriptionFeatureEntity>>> getFeatures({
    String? search, String? status, String? cursor, int perPage = 50,
  });

  Future<ApiResponse<List<ProviderSubscriptionEntity>>> getProviderSubscriptions({
    int? networkId, int? planId, String? status, bool? activeOnly,
    String? cursor, int perPage = 20,
  });
  Future<ProviderSubscriptionEntity> getProviderSubscription(int id);
  Future<ProviderSubscriptionEntity> extendSubscription(int id, int additionalDays);

  Future<ApiResponse<List<SubscriptionRequestEntity>>> getRequests({
    int? networkId, int? planId, String? status, String? paymentType,
    String? fromDate, String? toDate, String? search, String? cursor,
    int perPage = 20,
  });
  Future<SubscriptionRequestEntity> getRequest(int id);
  Future<Uint8List> getRequestReceipt(int id);
  Future<void> approveRequest(int id, {String? note});
  Future<void> rejectRequest(int id, {required String reason, String? note});
}
