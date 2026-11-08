import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/models/platform_network_pos_link_model.dart';

abstract interface class PlatformNetworkPosLinksRemoteDataSource {
  Future<ApiResponse<List<PlatformNetworkPosLinkModel>>> getLinks({
    String? search,
    int? networkId,
    int? posId,
    String? status,
    String? cursor,
    int perPage = 20,
  });

  Future<ApiResponse<PlatformNetworkPosLinkModel>> getLink(int linkId);

  Future<ApiResponse<PlatformNetworkPosLinkModel>> createLink({
    required int networkId,
    required int posId,
  });

  Future<ApiResponse<PlatformNetworkPosLinkModel>> updateStatus({
    required int linkId,
    required bool isActive,
  });

  Future<ApiResponse<void>> deleteLink(int linkId);
}
