import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/datasources/platform_network_pos_links_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';

class PlatformNetworkPosLinksRepositoryImpl
    implements PlatformNetworkPosLinksRepository {
  const PlatformNetworkPosLinksRepositoryImpl(this._remoteDataSource);

  final PlatformNetworkPosLinksRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResponse<List<PlatformNetworkPosLinkEntity>>> getLinks({
    String? search,
    int? networkId,
    int? posId,
    String? status,
    String? cursor,
    int perPage = 20,
  }) async {
    final response = await _remoteDataSource.getLinks(
      search: search,
      networkId: networkId,
      posId: posId,
      status: status,
      cursor: cursor,
      perPage: perPage,
    );
    return ApiResponse<List<PlatformNetworkPosLinkEntity>>(
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
  Future<PlatformNetworkPosLinkEntity> getLink(int linkId) async {
    final response = await _remoteDataSource.getLink(linkId);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<PlatformNetworkPosLinkEntity> createLink({
    required int networkId,
    required int posId,
  }) async {
    final response = await _remoteDataSource.createLink(
      networkId: networkId,
      posId: posId,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<PlatformNetworkPosLinkEntity> updateStatus({
    required int linkId,
    required bool isActive,
  }) async {
    final response = await _remoteDataSource.updateStatus(
      linkId: linkId,
      isActive: isActive,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<void> deleteLink(int linkId) async {
    final response = await _remoteDataSource.deleteLink(linkId);
    if (!response.success) {
      throw Exception(response.message);
    }
  }
}
