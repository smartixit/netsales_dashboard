import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_networks/data/datasources/platform_networks_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/repositories/platform_networks_repository.dart';

/// Returns inherited Models as Domain entities without mapping or toEntity().
class PlatformNetworksRepositoryImpl implements PlatformNetworksRepository {
  const PlatformNetworksRepositoryImpl(this._remoteDataSource);

  final PlatformNetworksRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResponse<List<PlatformNetworkEntity>>> getNetworks({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) async {
    final response = await _remoteDataSource.getNetworks(
      search: search,
      status: status,
      cursor: cursor,
      perPage: perPage,
    );

    return ApiResponse<List<PlatformNetworkEntity>>(
      success: response.success,
      message: response.message,
      data: response.data,
      errors: response.errors,
      nextCursor: response.nextCursor,
      prevCursor: response.prevCursor,
      meta: response.meta,
      isIdempotentHit: response.isIdempotentHit,
      idempotencyKey: response.idempotencyKey,
    );
  }

  @override
  Future<PlatformNetworkEntity> getNetwork(int networkId) async {
    final response = await _remoteDataSource.getNetwork(networkId);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<PlatformNetworkEntity> updateNetwork(
    int networkId, {
    required Map<String, dynamic> data,
  }) async {
    final response = await _remoteDataSource.updateNetwork(
      networkId,
      data: data,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<void> approveNetwork(int networkId) async {
    final response = await _remoteDataSource.approveNetwork(networkId);
    if (!response.success) throw Exception(response.message);
  }

  @override
  Future<void> rejectNetwork(int networkId, {required String reason}) async {
    final response = await _remoteDataSource.rejectNetwork(
      networkId,
      reason: reason,
    );
    if (!response.success) throw Exception(response.message);
  }
}
