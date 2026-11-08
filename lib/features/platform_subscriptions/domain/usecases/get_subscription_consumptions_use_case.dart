import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_consumption_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetSubscriptionConsumptionsUseCase {
  const GetSubscriptionConsumptionsUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<List<SubscriptionFeatureConsumptionEntity>> call(int id) => _repository.getConsumptions(id);
}