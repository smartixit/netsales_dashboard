import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';

class RejectPlatformNetworkUseCase {
  const RejectPlatformNetworkUseCase(this._repository);
  final PlatformNetworksRepository _repository;

  Future<void> call(int networkId, {required String reason}) =>
      _repository.rejectNetwork(networkId, reason: reason);
}
