import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class DeleteSubscriptionPlanUseCase {
  const DeleteSubscriptionPlanUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<void> call(int id) => _repository.deletePlan(id);
}