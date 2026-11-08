import 'package:netsales_dashboard/features/platform_network_pos_links/domain/repositories/platform_network_pos_links_repository.dart';

class DeletePlatformNetworkPosLinkUseCase {
  const DeletePlatformNetworkPosLinkUseCase(this._repository);
  final PlatformNetworkPosLinksRepository _repository;

  Future<void> call(int linkId) => _repository.deleteLink(linkId);
}
