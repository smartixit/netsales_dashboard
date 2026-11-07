import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:netsales_dashboard/features/splash/domain/repositories/splash_repository.dart';

/// Applies the verified startup decision to the Dashboard route graph.
class SplashRepositoryImpl implements SplashRepository {
  const SplashRepositoryImpl(this._dataSource);

  final SplashLocalDataSource _dataSource;

  @override
  Future<void> initializeServices() {
    return _dataSource.initializeInfrastructureServices();
  }

  @override
  Future<String> getBootDestination() async {
    // Platform Dashboard has no onboarding or Network/POS account-selection flow.
    // A cached session is accepted only after the API validates it.
    if (_dataSource.isAuthenticated) {
      final isValidOnServer = await _dataSource.validateSessionWithServer();
      if (isValidOnServer) {
        return AppRoutes.dashboard;
      }
    }

    return AppRoutes.login;
  }
}
