import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_users/data/repositories/platform_users_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_users_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';

/// تسجيل سلسلة اعتماديات دليل مستخدمي المنصة.
class PlatformUsersBinding extends Bindings {
  @override
  void dependencies() {
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

    if (!Get.isRegistered<GetPlatformUsersUseCase>()) {
      Get.lazyPut<GetPlatformUsersUseCase>(
        () => GetPlatformUsersUseCase(
          Get.find<PlatformUsersRepository>(),
        ),
      );
    }

    Get.lazyPut<PlatformUsersController>(
      () => PlatformUsersController(
        getPlatformUsers: Get.find<GetPlatformUsersUseCase>(),
      ),
    );
  }
}
