import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class ExtendProviderSubscriptionUseCase {
  const ExtendProviderSubscriptionUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<ProviderSubscriptionEntity> call(int id, int additionalDays) => _repository.extendSubscription(id, additionalDays);
}