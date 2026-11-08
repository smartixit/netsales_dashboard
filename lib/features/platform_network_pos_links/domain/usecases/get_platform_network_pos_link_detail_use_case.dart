import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';

class GetPlatformNetworkPosLinkDetailUseCase {
  const GetPlatformNetworkPosLinkDetailUseCase(this._repository);
  final PlatformNetworkPosLinksRepository _repository;

  Future<PlatformNetworkPosLinkEntity> call(int linkId) =>
      _repository.getLink(linkId);
}
