import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class GetPlatformDashboardOverviewUseCase {
  const GetPlatformDashboardOverviewUseCase(this._repository);

  final PlatformDashboardRepository _repository;

  Future<PlatformDashboardOverviewEntity> execute({String period = '30d'}) {
    return _repository.getOverview(period: period);
  }

  Future<PlatformDashboardOverviewEntity> call({String period = '30d'}) {
    return execute(period: period);
  }
}
