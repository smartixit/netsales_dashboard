import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_networks/data/datasources/platform_networks_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_networks/data/models/platform_network_model.dart';

/// API implementation kept separate from the remote-data contract.
class PlatformNetworksRemoteDataSourceImpl
    implements PlatformNetworksRemoteDataSource {
  PlatformNetworksRemoteDataSourceImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService.instance;

  final ApiService _apiService;

  @override
  Future<ApiResponse<List<PlatformNetworkModel>>> getNetworks({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) {
    return _apiService.getList<PlatformNetworkModel>(
      ApiConstants.networks,
      fromJson: (json) => PlatformNetworkModel.fromJson(_asJsonMap(json)),
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (status != null && status.isNotEmpty) 'status': status,
      },
      cursor: cursor,
      perPage: perPage,
    );
  }

  @override
  Future<ApiResponse<PlatformNetworkModel>> getNetwork(int networkId) {
    return _apiService.get<PlatformNetworkModel>(
      ApiConstants.network(networkId),
      fromJson: (json) => PlatformNetworkModel.fromJson(_asJsonMap(json)),
    );
  }

  @override
  Future<ApiResponse<PlatformNetworkModel>> updateNetwork(
    int networkId, {
    required Map<String, dynamic> data,
  }) {
    return _apiService.put<PlatformNetworkModel>(
      ApiConstants.network(networkId),
      data: data,
      fromJson: (json) => PlatformNetworkModel.fromJson(_asJsonMap(json)),
    );
  }

  @override
  Future<ApiResponse<void>> approveNetwork(int networkId) {
    return _apiService.post<void>(ApiConstants.networkApprove(networkId));
  }

  @override
  Future<ApiResponse<void>> rejectNetwork(
    int networkId, {
    required String reason,
  }) {
    return _apiService.post<void>(
      ApiConstants.networkReject(networkId),
      data: <String, dynamic>{'rejection_reason': reason},
    );
  }
}

Map<String, dynamic> _asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map<Object?, Object?>) return Map<String, dynamic>.from(value);
  throw const FormatException('Unexpected network resource payload.');
}
