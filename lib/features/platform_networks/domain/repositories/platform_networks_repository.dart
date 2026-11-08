import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';

abstract interface class PlatformNetworksRepository {
  Future<ApiResponse<List<PlatformNetworkEntity>>> getNetworks({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<PlatformNetworkEntity> getNetwork(int networkId);

  Future<PlatformNetworkEntity> updateNetwork(
    int networkId, {
    required String name,
    String? address,
  });

  Future<void> approveNetwork(int networkId);

  Future<void> rejectNetwork(int networkId, {required String reason});
}
