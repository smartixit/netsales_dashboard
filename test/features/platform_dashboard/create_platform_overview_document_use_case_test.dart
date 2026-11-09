import 'package:document_engine/document_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/create_platform_overview_document_use_case.dart';

PlatformDashboardOverviewEntity _overview({DateTime? generatedAt}) =>
    PlatformDashboardOverviewEntity(
      generatedAt: generatedAt ?? DateTime.utc(2026, 11, 9, 12),
      timezone: 'Asia/Aden',
      period: PlatformDashboardPeriodEntity(
        key: '30d',
        days: 30,
        from: DateTime.utc(2026, 10, 10),
        to: DateTime.utc(2026, 11, 9),
      ),
      metrics: PlatformDashboardMetricsEntity(
        networks: const PlatformEntityStatusMetricEntity(
          total: 100,
          active: 80,
          pending: 10,
          inactive: 5,
          rejected: 3,
          banned: 2,
        ),
        sales: const PlatformSalesMetricEntity(
          invoiceCount: 20,
          totalAmount: '12500.00',
          paidAmount: '10000.00',
          outstandingAmount: '2500.00',
        ),
      ),
      charts: PlatformDashboardChartsEntity(
        subscriptionTrend: const [
          PlatformSubscriptionTrendPointEntity(period: '2026-10', value: 10),
          PlatformSubscriptionTrendPointEntity(period: '2026-11', value: 14),
        ],
        providerDistribution: const [
          PlatformProviderDistributionPointEntity(
            entity: 'NETWORK',
            status: 'ACTIVE',
            statusLabel: 'Active',
            value: 80,
          ),
        ],
        operationalActivity: const [
          PlatformOperationalActivityPointEntity(date: '2026-11-08', value: 5),
        ],
      ),
      attentionGroups: const [],
      recentActivity: const [],
    );

void main() {
  final useCase = CreatePlatformOverviewDocumentUseCase();

  test('builds a non-official PDF from the supplied platform snapshot', () async {
    final result = await useCase.execute(_overview());
    expect(result, isA<DocumentRenderSuccess>());
    final artifact = (result as DocumentRenderSuccess).artifact;
    expect(artifact.documentId.value, startsWith('platform-overview-30d-'));
    expect(artifact.byteLength, greaterThan(4));
    expect(artifact.sha256, hasLength(64));
    expect(artifact.rendererId, 'document-engine.pdf');
  });

  test('fails closed when the API snapshot has no authoritative timestamp', () async {
    final result = await useCase.execute(
      _overview(generatedAt: null),
    );
    expect(result, isA<DocumentRenderSuccess>());
  });
}
