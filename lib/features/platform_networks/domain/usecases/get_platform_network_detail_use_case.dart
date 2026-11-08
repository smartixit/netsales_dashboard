import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';

class GetPlatformNetworkDetailUseCase {
  const GetPlatformNetworkDetailUseCase(this._repository);
  final PlatformNetworksRepository _repository;

  Future<PlatformNetworkEntity> call(int networkId) =>
      _repository.getNetwork(networkId);
}
