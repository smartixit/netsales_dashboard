import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_users/data/datasources/platform_users_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_users/data/repositories/platform_users_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_users/domain/repositories/platform_users_repository.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_users_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_trashed_platform_users_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/recover_platform_user_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_roles_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/create_platform_user_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/update_platform_user_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/update_platform_user_status_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_user_form_controller.dart';

class PlatformUsersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlatformUsersRemoteDataSource>()) {
      Get.lazyPut<PlatformUsersRemoteDataSource>(PlatformUsersRemoteDataSourceImpl.new);
    }
    if (!Get.isRegistered<PlatformUsersRepository>()) {
      Get.lazyPut<PlatformUsersRepository>(() => PlatformUsersRepositoryImpl(Get.find<PlatformUsersRemoteDataSource>()));
    }
    Get.lazyPut<GetPlatformUsersUseCase>(() => GetPlatformUsersUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<GetPlatformRolesUseCase>(() => GetPlatformRolesUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<CreatePlatformUserUseCase>(() => CreatePlatformUserUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<UpdatePlatformUserUseCase>(() => UpdatePlatformUserUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<UpdatePlatformUserStatusUseCase>(() => UpdatePlatformUserStatusUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<PlatformUserFormController>(() => PlatformUserFormController(
      getRoles: Get.find<GetPlatformRolesUseCase>(),
      createUser: Get.find<CreatePlatformUserUseCase>(),
      updateUser: Get.find<UpdatePlatformUserUseCase>(),
    ));
    Get.lazyPut<GetTrashedPlatformUsersUseCase>(() => GetTrashedPlatformUsersUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<RecoverPlatformUserUseCase>(() => RecoverPlatformUserUseCase(Get.find<PlatformUsersRepository>()));
    Get.lazyPut<PlatformUsersController>(() => PlatformUsersController(
      Get.find<GetPlatformUsersUseCase>(),
      Get.find<GetTrashedPlatformUsersUseCase>(),
      Get.find<RecoverPlatformUserUseCase>(),
    ));
  }
}
