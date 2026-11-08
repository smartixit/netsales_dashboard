import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_networks/data/models/platform_network_model.dart';

/// Remote contract for platform-level network management.
abstract interface class PlatformNetworksRemoteDataSource {
  Future<ApiResponse<List<PlatformNetworkModel>>> getNetworks({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<ApiResponse<PlatformNetworkModel>> getNetwork(int networkId);

  Future<ApiResponse<PlatformNetworkModel>> updateNetwork(
    int networkId, {
    required Map<String, dynamic> data,
  });

  Future<ApiResponse<void>> approveNetwork(int networkId);

  Future<ApiResponse<void>> rejectNetwork(
    int networkId, {
    required String reason,
  });
}
