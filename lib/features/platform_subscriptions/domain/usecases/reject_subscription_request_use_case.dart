import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
class RejectSubscriptionRequestUseCase {
  const RejectSubscriptionRequestUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<void> call(int id, {required String reason, String? note}) => _repository.rejectRequest(id, reason: reason, note: note);
}