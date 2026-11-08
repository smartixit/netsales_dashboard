import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/datasources/platform_network_pos_links_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/data/models/platform_network_pos_link_model.dart';

class PlatformNetworkPosLinksRemoteDataSourceImpl
    implements PlatformNetworkPosLinksRemoteDataSource {
  PlatformNetworkPosLinksRemoteDataSourceImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService.instance;

  final ApiService _apiService;

  @override
  Future<ApiResponse<List<PlatformNetworkPosLinkModel>>> getLinks({
    String? search,
    int? networkId,
    int? posId,
    String? status,
    String? cursor,
    int perPage = 20,
  }) => _apiService.getList<PlatformNetworkPosLinkModel>(
    ApiConstants.networkPos,
    fromJson: (json) => PlatformNetworkPosLinkModel.fromJson(_asJsonMap(json)),
    queryParameters: {
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (networkId != null) 'network_id': networkId,
      if (posId != null) 'pos_id': posId,
      if (status != null && status.isNotEmpty) 'status': status,
    },
    cursor: cursor,
    perPage: perPage,
  );

  @override
  Future<ApiResponse<PlatformNetworkPosLinkModel>> getLink(int linkId) =>
      _apiService.get<PlatformNetworkPosLinkModel>(
        ApiConstants.networkPosItem(linkId),
        fromJson: (json) =>
            PlatformNetworkPosLinkModel.fromJson(_asJsonMap(json)),
      );

  @override
  Future<ApiResponse<PlatformNetworkPosLinkModel>> createLink({
    required int networkId,
    required int posId,
  }) => _apiService.post<PlatformNetworkPosLinkModel>(
    ApiConstants.networkPos,
    data: <String, dynamic>{
      'network_id': networkId,
      'pos_id': posId,
      'status': true,
    },
    fromJson: (json) =>
        PlatformNetworkPosLinkModel.fromJson(_asJsonMap(json)),
  );

  @override
  Future<ApiResponse<PlatformNetworkPosLinkModel>> updateStatus({
    required int linkId,
    required bool isActive,
  }) => _apiService.put<PlatformNetworkPosLinkModel>(
    ApiConstants.networkPosItem(linkId),
    data: <String, dynamic>{'status': isActive},
    fromJson: (json) =>
        PlatformNetworkPosLinkModel.fromJson(_asJsonMap(json)),
  );

  @override
  Future<ApiResponse<void>> deleteLink(int linkId) =>
      _apiService.delete<void>(ApiConstants.networkPosItem(linkId));
}

Map<String, dynamic> _asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map<Object?, Object?>) return Map<String, dynamic>.from(value);
  throw const FormatException('Unexpected network-POS link resource payload.');
}
