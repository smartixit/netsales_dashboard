import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class SaveSubscriptionPlanUseCase {
  const SaveSubscriptionPlanUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<SubscriptionPlanEntity> create(Map<String, dynamic> data) => _repository.createPlan(data);
  Future<SubscriptionPlanEntity> update(int id, Map<String, dynamic> data) => _repository.updatePlan(id, data);
}