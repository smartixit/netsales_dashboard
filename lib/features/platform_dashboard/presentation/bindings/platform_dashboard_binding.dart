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
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_platform_dashboard_overview_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_platform_notifications_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_recent_platform_activity_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/mark_notification_read_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';

/// Composition root لاعتماديات غلاف لوحة المنصة.
class PlatformDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRemoteDataSource>()) {
      Get.lazyPut<AuthRemoteDataSource>(
        () => const AuthRemoteDataSourceImpl(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<LogoutUseCase>()) {
      Get.lazyPut<LogoutUseCase>(
        () => LogoutUseCase(Get.find<AuthRepository>()),
      );
    }

    if (!Get.isRegistered<PlatformDashboardRemoteDataSource>()) {
      Get.lazyPut<PlatformDashboardRemoteDataSource>(
        PlatformDashboardRemoteDataSourceImpl.new,
      );
    }
    if (!Get.isRegistered<PlatformDashboardRepository>()) {
      Get.lazyPut<PlatformDashboardRepository>(
        () => PlatformDashboardRepositoryImpl(
          Get.find<PlatformDashboardRemoteDataSource>(),
        ),
      );
    }

    if (!Get.isRegistered<GetPlatformDashboardOverviewUseCase>()) {
      Get.lazyPut<GetPlatformDashboardOverviewUseCase>(
        () => GetPlatformDashboardOverviewUseCase(
          Get.find<PlatformDashboardRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<GetPlatformNotificationsUseCase>()) {
      Get.lazyPut<GetPlatformNotificationsUseCase>(
        () => GetPlatformNotificationsUseCase(
          Get.find<PlatformDashboardRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<GetNotificationCountUseCase>()) {
      Get.lazyPut<GetNotificationCountUseCase>(
        () => GetNotificationCountUseCase(
          Get.find<PlatformDashboardRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<MarkNotificationReadUseCase>()) {
      Get.lazyPut<MarkNotificationReadUseCase>(
        () => MarkNotificationReadUseCase(
          Get.find<PlatformDashboardRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<MarkAllNotificationsReadUseCase>()) {
      Get.lazyPut<MarkAllNotificationsReadUseCase>(
        () => MarkAllNotificationsReadUseCase(
          Get.find<PlatformDashboardRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<GetRecentPlatformActivityUseCase>()) {
      Get.lazyPut<GetRecentPlatformActivityUseCase>(
        () => GetRecentPlatformActivityUseCase(
          Get.find<PlatformDashboardRepository>(),
        ),
      );
    }

    Get.lazyPut<PlatformDashboardController>(
      () => PlatformDashboardController(
        logoutUseCase: Get.find<LogoutUseCase>(),
        getOverview: Get.find<GetPlatformDashboardOverviewUseCase>(),
        getNotifications: Get.find<GetPlatformNotificationsUseCase>(),
        getNotificationCount: Get.find<GetNotificationCountUseCase>(),
        markNotificationRead: Get.find<MarkNotificationReadUseCase>(),
        markAllNotificationsRead: Get.find<MarkAllNotificationsReadUseCase>(),
      ),
    );
  }
}
