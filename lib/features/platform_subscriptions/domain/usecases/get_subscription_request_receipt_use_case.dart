import 'dart:typed_data';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';

class GetSubscriptionRequestReceiptUseCase {
  const GetSubscriptionRequestReceiptUseCase(this._repository);
  final PlatformSubscriptionsRepository _repository;
  Future<Uint8List> call(int requestId) => _repository.getRequestReceipt(requestId);
}
