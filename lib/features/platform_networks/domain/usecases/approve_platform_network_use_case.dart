import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';

class ApprovePlatformNetworkUseCase {
  const ApprovePlatformNetworkUseCase(this._repository);
  final PlatformNetworksRepository _repository;

  Future<void> call(int networkId) => _repository.approveNetwork(networkId);
}
