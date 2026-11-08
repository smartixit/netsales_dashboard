import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:netsales_dashboard/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:netsales_dashboard/features/auth/domain/repositories/auth_repository.dart';
import 'package:netsales_dashboard/features/auth/domain/usecases/logout_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/datasources/platform_dashboard_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/datasources/platform_dashboard_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/repositories/platform_dashboard_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_notification_count_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_platform_notifications_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_recent_platform_activity_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/mark_notification_read_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';

class PlatformDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRemoteDataSource>()) {
      Get.lazyPut<AuthRemoteDataSource>(() => const AuthRemoteDataSourceImpl(), fenix: true);
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()), fenix: true);
    }
    if (!Get.isRegistered<PlatformDashboardRemoteDataSource>()) {
      Get.lazyPut<PlatformDashboardRemoteDataSource>(() => PlatformDashboardRemoteDataSourceImpl());
    }
    if (!Get.isRegistered<PlatformDashboardRepository>()) {
      Get.lazyPut<PlatformDashboardRepository>(
        () => PlatformDashboardRepositoryImpl(Get.find<PlatformDashboardRemoteDataSource>()),
      );
    }
    final repository = Get.find<PlatformDashboardRepository>();
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => GetPlatformNotificationsUseCase(repository));
    Get.lazyPut(() => GetNotificationCountUseCase(repository));
    Get.lazyPut(() => MarkNotificationReadUseCase(repository));
    Get.lazyPut(() => MarkAllNotificationsReadUseCase(repository));
    Get.lazyPut(() => GetRecentPlatformActivityUseCase(repository));
    Get.lazyPut<PlatformDashboardController>(
      () => PlatformDashboardController(
        logoutUseCase: Get.find<LogoutUseCase>(),
        getNotifications: Get.find(),
        getNotificationCount: Get.find(),
        markNotificationRead: Get.find(),
        markAllNotificationsRead: Get.find(),
        getRecentActivity: Get.find(),
      ),
    );
  }
}
