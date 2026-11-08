import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';

class GetPlatformNetworksUseCase {
  const GetPlatformNetworksUseCase(this._repository);
  final PlatformNetworksRepository _repository;

  Future<ApiResponse<List<PlatformNetworkEntity>>> call({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) => _repository.getNetworks(
    search: search,
    status: status,
    cursor: cursor,
    perPage: perPage,
  );
}
