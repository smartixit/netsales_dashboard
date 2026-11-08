import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/datasources/platform_subscriptions_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/provider_subscription_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_plan_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_request_model.dart';

class PlatformSubscriptionsRemoteDataSourceImpl implements PlatformSubscriptionsRemoteDataSource {
  PlatformSubscriptionsRemoteDataSourceImpl({ApiService? apiService}) : _api = apiService ?? ApiService.instance;
  final ApiService _api;

  @override
  Future<ApiResponse<List<SubscriptionPlanModel>>> getPlans({String? search, String? status, String? cursor, int perPage = 20}) =>
      _api.getList<SubscriptionPlanModel>(
        ApiConstants.subscriptionPlans,
        fromJson: (json) => SubscriptionPlanModel.fromJson(_map(json)),
        queryParameters: {if (search?.trim().isNotEmpty == true) 'search': search!.trim(), if (status != null && status.isNotEmpty) 'status': status},
        cursor: cursor, perPage: perPage,
      );

  @override
  Future<ApiResponse<SubscriptionPlanModel>> getPlan(int id) => _api.get<SubscriptionPlanModel>(
    ApiConstants.subscriptionPlan(id), fromJson: (json) => SubscriptionPlanModel.fromJson(_map(json)),
  );

  @override
  Future<ApiResponse<SubscriptionPlanModel>> createPlan(Map<String, dynamic> data) => _api.post<SubscriptionPlanModel>(
    ApiConstants.subscriptionPlans, data: data, fromJson: (json) => SubscriptionPlanModel.fromJson(_map(json)),
  );

  @override
  Future<ApiResponse<SubscriptionPlanModel>> updatePlan(int id, Map<String, dynamic> data) => _api.put<SubscriptionPlanModel>(
    ApiConstants.subscriptionPlan(id), data: data, fromJson: (json) => SubscriptionPlanModel.fromJson(_map(json)),
  );

  @override
  Future<ApiResponse<void>> togglePlanStatus(int id) => _api.post<void>(ApiConstants.subscriptionPlanToggleStatus(id));

  @override
  Future<ApiResponse<void>> deletePlan(int id) => _api.delete<void>(ApiConstants.subscriptionPlan(id));

  @override
  Future<ApiResponse<List<SubscriptionFeatureModel>>> getFeatures({String? search, String? status, String? cursor, int perPage = 50}) =>
      _api.getList<SubscriptionFeatureModel>(
        ApiConstants.features,
        fromJson: (json) => SubscriptionFeatureModel.fromJson(_map(json)),
        queryParameters: {if (search?.trim().isNotEmpty == true) 'search': search!.trim(), if (status != null && status.isNotEmpty) 'status': status},
        cursor: cursor, perPage: perPage,
      );

  @override
  Future<ApiResponse<List<ProviderSubscriptionModel>>> getProviderSubscriptions({int? networkId, int? planId, String? status, bool? activeOnly, String? cursor, int perPage = 20}) =>
      _api.getList<ProviderSubscriptionModel>(
        ApiConstants.providerSubscriptions,
        fromJson: (json) => ProviderSubscriptionModel.fromJson(_map(json)),
        queryParameters: {'network_id': ?networkId, 'plan_id': ?planId, if (status != null && status.isNotEmpty) 'status': status, 'active_only': ?activeOnly},
        cursor: cursor, perPage: perPage,
      );

  @override
  Future<ApiResponse<ProviderSubscriptionModel>> getProviderSubscription(int id) => _api.get<ProviderSubscriptionModel>(
    ApiConstants.providerSubscription(id), fromJson: (json) => ProviderSubscriptionModel.fromJson(_map(json)),
  );


  @override
  Future<ApiResponse<ProviderSubscriptionModel>> extendSubscription(int id, int additionalDays) => _api.post<ProviderSubscriptionModel>(
    ApiConstants.providerSubscriptionExtend(id),
    data: <String, dynamic>{'additional_days': additionalDays},
    fromJson: (json) => ProviderSubscriptionModel.fromJson(_map(json)),
  );

  @override
  Future<ApiResponse<List<SubscriptionRequestModel>>> getRequests({int? networkId, int? planId, String? status, String? paymentType, String? fromDate, String? toDate, String? search, String? cursor, int perPage = 20}) =>
      _api.getList<SubscriptionRequestModel>(
        ApiConstants.subscriptionPlanRequests,
        fromJson: (json) => SubscriptionRequestModel.fromJson(_map(json)),
        queryParameters: {
          'network_id': ?networkId, 'plan_id': ?planId,
          if (status != null && status.isNotEmpty) 'status': status,
          if (paymentType != null && paymentType.isNotEmpty) 'request_payment_type': paymentType,
          if (fromDate != null && fromDate.isNotEmpty) 'from_date': fromDate,
          if (toDate != null && toDate.isNotEmpty) 'to_date': toDate,
          if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
        },
        cursor: cursor, perPage: perPage,
      );

  @override
  Future<ApiResponse<SubscriptionRequestModel>> getRequest(int id) => _api.get<SubscriptionRequestModel>(
    ApiConstants.subscriptionPlanRequest(id), fromJson: (json) => SubscriptionRequestModel.fromJson(_map(json)),
  );

  @override
  Future<ApiResponse<void>> approveRequest(int id, {String? note}) => _api.post<void>(
    ApiConstants.subscriptionPlanRequestApprove(id),
    data: <String, dynamic>{if (note != null && note.trim().isNotEmpty) 'request_note': note.trim()},
  );

  @override
  Future<ApiResponse<void>> rejectRequest(int id, {required String reason, String? note}) => _api.post<void>(
    ApiConstants.subscriptionPlanRequestReject(id),
    data: <String, dynamic>{
      'rejection_reason': reason.trim(),
      if (note != null && note.trim().isNotEmpty) 'request_note': note.trim(),
    },
  );
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw const FormatException('Unexpected subscription API resource payload.');
}
