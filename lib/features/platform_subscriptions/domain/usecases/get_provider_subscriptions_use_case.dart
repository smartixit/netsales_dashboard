import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetProviderSubscriptionsUseCase {
  const GetProviderSubscriptionsUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<ApiResponse<List<ProviderSubscriptionEntity>>> call({int? networkId, int? planId, String? status, bool? activeOnly, String? cursor, int perPage = 20}) =>
      _repository.getProviderSubscriptions(networkId: networkId, planId: planId, status: status, activeOnly: activeOnly, cursor: cursor, perPage: perPage);
}