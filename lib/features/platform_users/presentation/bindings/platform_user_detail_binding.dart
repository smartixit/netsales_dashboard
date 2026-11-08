import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_users/data/repositories/platform_users_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_detail_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_user_sessions_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_user_detail_controller.dart';

class PlatformUserDetailBinding extends Bindings {
  @override
  void dependencies() {
    final id = int.tryParse(Get.parameters['id'] ?? '');
    if (id == null || id <= 0) {
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
    Get.lazyPut<GetPlatformUserDetailUseCase>(
      () => GetPlatformUserDetailUseCase(
        Get.find<PlatformUsersRepository>(),
      ),
    );
    Get.lazyPut<GetPlatformUserSessionsUseCase>(
      () => GetPlatformUserSessionsUseCase(
        Get.find<PlatformUsersRepository>(),
      ),
    );
    Get.lazyPut<PlatformUserDetailController>(
      () => PlatformUserDetailController(
        id,
        Get.find<GetPlatformUserDetailUseCase>(),
        Get.find<GetPlatformUserSessionsUseCase>(),
      ),
    );
  }
}
