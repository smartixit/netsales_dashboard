import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';

class GetPlatformNetworkPosLinksUseCase {
  const GetPlatformNetworkPosLinksUseCase(this._repository);
  final PlatformNetworkPosLinksRepository _repository;

  Future<ApiResponse<List<PlatformNetworkPosLinkEntity>>> call({
    String? search,
    int? networkId,
    int? posId,
    String? status,
    String? cursor,
    int perPage = 20,
  }) => _repository.getLinks(
    search: search,
    networkId: networkId,
    posId: posId,
    status: status,
    cursor: cursor,
    perPage: perPage,
  );
}
