import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class ApproveSubscriptionRequestUseCase {
  const ApproveSubscriptionRequestUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<void> call(int id, {String? note}) => _repository.approveRequest(id, note: note);
}