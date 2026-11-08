import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class ActivateQueuedSubscriptionUseCase {
  const ActivateQueuedSubscriptionUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<ProviderSubscriptionEntity> call(int networkId) => _repository.activateQueuedSubscription(networkId);
}