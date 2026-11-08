import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetSubscriptionPlansUseCase {
  const GetSubscriptionPlansUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<ApiResponse<List<SubscriptionPlanEntity>>> call({String? search, String? status, String? cursor, int perPage = 20}) =>
      _repository.getPlans(search: search, status: status, cursor: cursor, perPage: perPage);
}