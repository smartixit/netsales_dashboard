import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';

class UpdatePlatformNetworkUseCase {
  const UpdatePlatformNetworkUseCase(this._repository);
  final PlatformNetworksRepository _repository;

  Future<PlatformNetworkEntity> call(
    int networkId, {
    required Map<String, dynamic> data,
  }) => _repository.updateNetwork(networkId, data: data);
}
