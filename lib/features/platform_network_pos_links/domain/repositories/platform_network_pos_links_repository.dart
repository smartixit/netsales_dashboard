import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';

abstract interface class PlatformNetworkPosLinksRepository {
  Future<ApiResponse<List<PlatformNetworkPosLinkEntity>>> getLinks({
    String? search,
    int? networkId,
    int? posId,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<PlatformNetworkPosLinkEntity> getLink(int linkId);

  Future<PlatformNetworkPosLinkEntity> createLink({
    required int networkId,
    required int posId,
  });

  Future<PlatformNetworkPosLinkEntity> updateStatus({
    required int linkId,
    required bool isActive,
  });

  Future<void> deleteLink(int linkId);
}
