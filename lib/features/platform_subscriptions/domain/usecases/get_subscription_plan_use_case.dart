import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetSubscriptionPlanUseCase {
  const GetSubscriptionPlanUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<SubscriptionPlanEntity> call(int id) => _repository.getPlan(id);
}