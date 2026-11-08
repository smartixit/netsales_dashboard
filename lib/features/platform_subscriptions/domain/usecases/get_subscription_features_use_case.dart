import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class GetSubscriptionFeaturesUseCase {
  const GetSubscriptionFeaturesUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<ApiResponse<List<SubscriptionFeatureEntity>>> call({String? search, String? status, String? cursor, int perPage = 50}) =>
      _repository.getFeatures(search: search, status: status, cursor: cursor, perPage: perPage);
}