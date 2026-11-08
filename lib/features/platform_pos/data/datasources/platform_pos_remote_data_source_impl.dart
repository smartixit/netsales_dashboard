import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_pos/data/datasources/platform_pos_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_pos/data/models/platform_pos_model.dart';

class PlatformPosRemoteDataSourceImpl implements PlatformPosRemoteDataSource {
  PlatformPosRemoteDataSourceImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService.instance;

  final ApiService _apiService;

  @override
  Future<ApiResponse<List<PlatformPosModel>>> getPosList({
    String? search,
    String? status,
    String? cursor,
    int perPage = 20,
  }) {
    return _apiService.getList<PlatformPosModel>(
      ApiConstants.pos,
      fromJson: (json) => PlatformPosModel.fromJson(_asJsonMap(json)),
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (status != null && status.isNotEmpty) 'status': status,
      },
      cursor: cursor,
      perPage: perPage,
    );
  }

  @override
  Future<ApiResponse<PlatformPosModel>> getPos(int posId) {
    return _apiService.get<PlatformPosModel>(
      ApiConstants.posItem(posId),
      fromJson: (json) => PlatformPosModel.fromJson(_asJsonMap(json)),
    );
  }

  @override
  Future<ApiResponse<PlatformPosModel>> updatePos(
    int posId, {
    required String name,
    required int governorateId,
    required int directorateId,
    String? email,
    String? address,
  }) {
    return _apiService.put<PlatformPosModel>(
      ApiConstants.posItem(posId),
      data: <String, dynamic>{
        'pos_name': name,
        'governorate_id': governorateId,
        'directorate_id': directorateId,
        'pos_email': ?email,
        'pos_address': ?address,
      },
      fromJson: (json) => PlatformPosModel.fromJson(_asJsonMap(json)),
    );
  }

  @override
  Future<ApiResponse<PlatformPosModel>> approvePos(int posId) {
    return _apiService.post<PlatformPosModel>(
      ApiConstants.posApprove(posId),
      fromJson: (json) => PlatformPosModel.fromJson(_asJsonMap(json)),
    );
  }

  @override
  Future<ApiResponse<PlatformPosModel>> rejectPos(
    int posId, {
    required String reason,
  }) {
    return _apiService.post<PlatformPosModel>(
      ApiConstants.posReject(posId),
      data: <String, dynamic>{'rejection_reason': reason},
      fromJson: (json) => PlatformPosModel.fromJson(_asJsonMap(json)),
    );
  }
}

Map<String, dynamic> _asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map<Object?, Object?>) return Map<String, dynamic>.from(value);
  throw const FormatException('Unexpected POS resource payload.');
}
