import 'dart:typed_data';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/datasources/platform_subscriptions_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/provider_subscription_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_feature_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/models/subscription_request_model.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';

class PlatformSubscriptionsRepositoryImpl implements PlatformSubscriptionsRepository {
  const PlatformSubscriptionsRepositoryImpl(this._remote);
  final PlatformSubscriptionsRemoteDataSource _remote;

  @override
  Future<ApiResponse<List<SubscriptionPlanEntity>>> getPlans({String? search, String? status, String? cursor, int perPage = 20}) async {
    final response = await _remote.getPlans(search: search, status: status, cursor: cursor, perPage: perPage);
    return ApiResponse<List<SubscriptionPlanEntity>>(success: response.success, message: response.message, data: response.data, errors: response.errors, nextCursor: response.nextCursor, prevCursor: response.prevCursor, meta: response.meta);
  }
  @override
  Future<SubscriptionPlanEntity> getPlan(int id) => _required(_remote.getPlan(id));
  @override
  Future<SubscriptionPlanEntity> createPlan(Map<String, dynamic> data) => _required(_remote.createPlan(data));
  @override
  Future<SubscriptionPlanEntity> updatePlan(int id, Map<String, dynamic> data) => _required(_remote.updatePlan(id, data));
  @override
  Future<bool> togglePlanStatus(int id) async { final r = await _remote.togglePlanStatus(id); _ensure(r.success, r.message); return true; }
  @override
  Future<void> deletePlan(int id) async { final r = await _remote.deletePlan(id); _ensure(r.success, r.message); }
  @override
  Future<ApiResponse<List<SubscriptionFeatureEntity>>> getFeatures({String? search, String? status, String? cursor, int perPage = 50}) {
    return _mapList<SubscriptionFeatureModel, SubscriptionFeatureEntity>(_remote.getFeatures(search: search, status: status, cursor: cursor, perPage: perPage));
  }
  @override
  Future<ApiResponse<List<ProviderSubscriptionEntity>>> getProviderSubscriptions({int? networkId, int? planId, String? status, bool? activeOnly, String? cursor, int perPage = 20}) =>
    _mapList<ProviderSubscriptionModel, ProviderSubscriptionEntity>(_remote.getProviderSubscriptions(networkId: networkId, planId: planId, status: status, activeOnly: activeOnly, cursor: cursor, perPage: perPage));
  @override
  Future<ProviderSubscriptionEntity> getProviderSubscription(int id) => _required(_remote.getProviderSubscription(id));

  @override
  Future<ProviderSubscriptionEntity> extendSubscription(int id, int additionalDays) => _required(_remote.extendSubscription(id, additionalDays));
  @override
  Future<ApiResponse<List<SubscriptionRequestEntity>>> getRequests({int? networkId, int? planId, String? status, String? paymentType, String? fromDate, String? toDate, String? search, String? cursor, int perPage = 20}) =>
    _mapList<SubscriptionRequestModel, SubscriptionRequestEntity>(_remote.getRequests(networkId: networkId, planId: planId, status: status, paymentType: paymentType, fromDate: fromDate, toDate: toDate, search: search, cursor: cursor, perPage: perPage));
  @override
  Future<SubscriptionRequestEntity> getRequest(int id) => _required(_remote.getRequest(id));
  @override
  Future<Uint8List> getRequestReceipt(int id) => _remote.getRequestReceipt(id);
  @override
  Future<void> approveRequest(int id, {String? note}) async { final r = await _remote.approveRequest(id, note: note); _ensure(r.success, r.message); }
  @override
  Future<void> rejectRequest(int id, {required String reason, String? note}) async { final r = await _remote.rejectRequest(id, reason: reason, note: note); _ensure(r.success, r.message); }

  Future<T> _required<T>(Future<ApiResponse<T>> future) async {
    final r = await future; _ensure(r.success && r.data != null, r.message); return r.data as T;
  }
  Future<ApiResponse<List<E>>> _mapList<M extends E, E>(Future<ApiResponse<List<M>>> future) async {
    final r = await future;
    return ApiResponse<List<E>>(success: r.success, message: r.message, data: r.data, errors: r.errors, nextCursor: r.nextCursor, prevCursor: r.prevCursor, meta: r.meta);
  }
  void _ensure(bool success, String message) {
    if (!success) throw Exception(message.isEmpty ? 'Subscription request failed.' : message);
  }
}
