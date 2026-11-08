import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:netsales_dashboard/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:netsales_dashboard/features/auth/domain/repositories/auth_repository.dart';
import 'package:netsales_dashboard/features/auth/domain/usecases/login_use_case.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/login_controller.dart';

/// Registers the existing authentication dependency chain for the login route.
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRemoteDataSource>()) {
      Get.lazyPut<AuthRemoteDataSource>(() => const AuthRemoteDataSourceImpl());
    }

    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      );
    }

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<LoginController>(
      () => LoginController(loginUseCase: Get.find<LoginUseCase>()),
    );
  }
}
