import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class ToggleSubscriptionPlanStatusUseCase {
  const ToggleSubscriptionPlanStatusUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<bool> call(int id) => _repository.togglePlanStatus(id);
}