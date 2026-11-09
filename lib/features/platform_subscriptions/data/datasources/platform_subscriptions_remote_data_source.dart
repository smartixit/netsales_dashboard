import 'dart:typed_data';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/provider_subscription_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_plan_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_request_model.dart';

abstract interface class PlatformSubscriptionsRemoteDataSource {
  Future<ApiResponse<List<SubscriptionPlanModel>>> getPlans({String? search, String? status, String? cursor, int perPage = 20});
  Future<ApiResponse<SubscriptionPlanModel>> getPlan(int id);
  Future<ApiResponse<SubscriptionPlanModel>> createPlan(Map<String, dynamic> data);
  Future<ApiResponse<SubscriptionPlanModel>> updatePlan(int id, Map<String, dynamic> data);
  Future<ApiResponse<void>> togglePlanStatus(int id);
  Future<ApiResponse<void>> deletePlan(int id);
  Future<ApiResponse<List<SubscriptionFeatureModel>>> getFeatures({String? search, String? status, String? cursor, int perPage = 50});
  Future<ApiResponse<List<ProviderSubscriptionModel>>> getProviderSubscriptions({int? networkId, int? planId, String? status, bool? activeOnly, String? cursor, int perPage = 20});
  Future<ApiResponse<ProviderSubscriptionModel>> getProviderSubscription(int id);
  Future<ApiResponse<ProviderSubscriptionModel>> extendSubscription(int id, int additionalDays);
  Future<ApiResponse<List<SubscriptionRequestModel>>> getRequests({int? networkId, int? planId, String? status, String? paymentType, String? fromDate, String? toDate, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<SubscriptionRequestModel>> getRequest(int id);
  Future<Uint8List> getRequestReceipt(int id);
  Future<ApiResponse<void>> approveRequest(int id, {String? note});
  Future<ApiResponse<void>> rejectRequest(int id, {required String reason, String? note});
}
