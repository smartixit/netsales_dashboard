import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';

class UpdatePlatformNetworkPosLinkStatusUseCase {
  const UpdatePlatformNetworkPosLinkStatusUseCase(this._repository);
  final PlatformNetworkPosLinksRepository _repository;

  Future<PlatformNetworkPosLinkEntity> call({
    required int linkId,
    required bool isActive,
  }) => _repository.updateStatus(linkId: linkId, isActive: isActive);
}
