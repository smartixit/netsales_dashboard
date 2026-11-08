import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetSubscriptionRequestUseCase {
  const GetSubscriptionRequestUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<SubscriptionRequestEntity> call(int id) => _repository.getRequest(id);
}