import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_users/data/repositories/platform_users_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_sessions_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_user_detail_controller.dart';

/// تسجيل اعتماديات شاشة تفاصيل مستخدم المنصة.
class PlatformUserDetailBinding extends Bindings {
  @override
  void dependencies() {
    final userId = int.tryParse(Get.parameters['id'] ?? '');
    if (userId == null || userId <= 0) {
      throw ArgumentError.value(
        Get.parameters['id'],
        'id',
        'Invalid platform user ID',
      );
    }

    if (!Get.isRegistered<PlatformUsersRemoteDataSource>()) {
      Get.lazyPut<PlatformUsersRemoteDataSource>(
        PlatformUsersRemoteDataSourceImpl.new,
      );
    }
    if (!Get.isRegistered<PlatformUsersRepository>()) {
      Get.lazyPut<PlatformUsersRepository>(
        () => PlatformUsersRepositoryImpl(
          Get.find<PlatformUsersRemoteDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<GetPlatformUserDetailUseCase>()) {
      Get.lazyPut<GetPlatformUserDetailUseCase>(
        () => GetPlatformUserDetailUseCase(
          Get.find<PlatformUsersRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<GetPlatformUserSessionsUseCase>()) {
      Get.lazyPut<GetPlatformUserSessionsUseCase>(
        () => GetPlatformUserSessionsUseCase(
          Get.find<PlatformUsersRepository>(),
        ),
      );
    }

    Get.lazyPut<PlatformUserDetailController>(
      () => PlatformUserDetailController(
        userId: userId,
        getUserDetail: Get.find<GetPlatformUserDetailUseCase>(),
        getUserSessions: Get.find<GetPlatformUserSessionsUseCase>(),
      ),
    );
  }
}
