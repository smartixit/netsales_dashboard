import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetSubscriptionRequestsUseCase {
  const GetSubscriptionRequestsUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<ApiResponse<List<SubscriptionRequestEntity>>> call({int? networkId, int? planId, String? status, String? paymentType, String? fromDate, String? toDate, String? search, String? cursor, int perPage = 20}) =>
      _repository.getRequests(networkId: networkId, planId: planId, status: status, paymentType: paymentType, fromDate: fromDate, toDate: toDate, search: search, cursor: cursor, perPage: perPage);
}