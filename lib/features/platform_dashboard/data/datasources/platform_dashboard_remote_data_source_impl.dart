import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/datasources/platform_dashboard_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_activity_model.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_notification_model.dart';

class PlatformDashboardRemoteDataSourceImpl implements PlatformDashboardRemoteDataSource {
  PlatformDashboardRemoteDataSourceImpl({ApiService? apiService})
      : _api = apiService ?? ApiService.instance;
  final ApiService _api;

  @override
  Future<List<PlatformNotificationModel>> getUnreadNotifications({required int limit}) async {
    final response = await _api.getList<PlatformNotificationModel>(
      ApiConstants.notificationsMy,
      fromJson: (json) => PlatformNotificationModel.fromJson(Map<String, dynamic>.from(json as Map)),
      queryParameters: const {'is_read': false},
      perPage: limit,
    );
    if (!response.success) {
      throw Exception(response.message.isEmpty ? 'Unable to load notifications.' : response.message);
    }
    return response.data ?? const <PlatformNotificationModel>[];
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    final response = await _api.get<int>(
      ApiConstants.notificationsUnreadCount,
      fromJson: (json) {
        if (json is Map) {
          final value = json['unread_count'];
          return value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
        }
        return 0;
      },
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message.isEmpty ? 'Unable to load notification count.' : response.message);
    }
    return response.data!;
  }

  @override
  Future<void> markNotificationRead(int notificationId) async {
    final response = await _api.post<dynamic>(
      ApiConstants.notificationMarkAsRead(notificationId),
    );
    if (!response.success) {
      throw Exception(response.message.isEmpty ? 'Unable to mark notification as read.' : response.message);
    }
  }

  @override
  Future<void> markAllNotificationsRead() async {
    final response = await _api.post<dynamic>(ApiConstants.notificationsMarkAllRead);
    if (!response.success) {
      throw Exception(response.message.isEmpty ? 'Unable to mark notifications as read.' : response.message);
    }
  }

  @override
  Future<List<PlatformActivityModel>> getRecentActivity({required int limit}) async {
    final response = await _api.getList<PlatformActivityModel>(
      ApiConstants.systemLogs,
      fromJson: (json) => PlatformActivityModel.fromJson(Map<String, dynamic>.from(json as Map)),
      perPage: limit,
    );
    if (!response.success) {
      throw Exception(response.message.isEmpty ? 'Unable to load activity.' : response.message);
    }
    return response.data ?? const <PlatformActivityModel>[];
  }
}
