import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';

class CreatePlatformNetworkPosLinkUseCase {
  const CreatePlatformNetworkPosLinkUseCase(this._repository);
  final PlatformNetworkPosLinksRepository _repository;

  Future<PlatformNetworkPosLinkEntity> call({
    required int networkId,
    required int posId,
  }) => _repository.createLink(networkId: networkId, posId: posId);
}
