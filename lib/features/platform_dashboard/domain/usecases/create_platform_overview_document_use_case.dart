import 'package:document_engine/document_engine.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';

/// Builds a non-official operational PDF from values already returned by the
/// platform overview endpoint. It performs no financial or business math.
class CreatePlatformOverviewDocumentUseCase {
  const CreatePlatformOverviewDocumentUseCase();

  Future<DocumentRenderResult> execute(
    PlatformDashboardOverviewEntity overview,
  ) async {
    final generatedAt = overview.generatedAt;
    if (generatedAt == null) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.renderingFailure,
        message: 'The server snapshot timestamp is required for export.',
      );
    }

    final charts = overview.charts;
    if (charts.subscriptionTrend.length > 100 ||
        charts.providerDistribution.length > 100 ||
        charts.operationalActivity.length > 100 ||
        overview.attentionGroups.length > 100) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.layoutFailure,
        message: 'The overview snapshot exceeds the bounded report input limit.',
      );
    }

    final sections = <DocumentSection>[];
    sections.addAll(_metricSections(overview.metrics));

    final chartNodes = _chartAndTableNodes(charts);
    if (chartNodes.isNotEmpty) {
      sections.add(
        DocumentSection(
          id: 'trends',
          title: 'Operational trends',
          nodes: chartNodes,
        ),
      );
    }

    final attentionRows = overview.attentionGroups;
    if (attentionRows.isNotEmpty) {
      sections.add(
        DocumentSection(
          id: 'attention',
          title: 'Items requiring attention',
          nodes: [
            DocumentTable(
              columns: [
                DocumentTableColumn(id: 'group', label: 'Queue'),
                DocumentTableColumn(id: 'count', label: 'Items'),
              ],
              rows: [
                for (var index = 0; index < attentionRows.length; index++)
                  DocumentTableRow(
                    id: 'attention-$index',
                    cells: [
                      DocumentTableCell(
                        value: DocumentTextValue(attentionRows[index].key),
                      ),
                      DocumentTableCell(
                        value: DocumentIntegerValue(attentionRows[index].count),
                      ),
                    ],
                  ),
              ],
              style: DocumentTableStyle(stripedRows: true, compact: true),
            ),
          ],
        ),
      );
    }

    if (sections.isEmpty) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.renderingFailure,
        message: 'The server returned no reportable overview values.',
      );
    }

    final snapshot = DocumentSnapshot(
      metadata: DocumentMetadata(
        id: DocumentId(
          'platform-overview-${overview.period.key}-${generatedAt.millisecondsSinceEpoch}',
        ),
        documentTypeId: DocumentTypeId('platform.overview'),
        title: 'Platform Overview',
        subtitle:
            'Period: ${overview.period.key} • Time zone: ${overview.timezone}',
        locale: DocumentLocale(
          languageTag: 'en',
          direction: DocumentTextDirection.leftToRight,
        ),
        reference: overview.period.key,
        createdAt: generatedAt,
        timeZoneId: overview.timezone,
        sourceRevision: generatedAt.toIso8601String(),
      ),
      sections: sections,
      schemaVersion: 1,
    );

    final template = DocumentTemplateDefinition(
      id: TemplateId('platform.overview.standard'),
      version: TemplateVersion(major: 1, minor: 0, patch: 0),
      documentTypeId: DocumentTypeId('platform.overview'),
      displayName: 'Platform Overview — Standard',
      supportedLocaleTags: const ['en'],
      capabilities: TemplateCapabilities([
        TemplateCapability.metrics,
        TemplateCapability.charts,
        TemplateCapability.tables,
        TemplateCapability.pageNumbering,
        TemplateCapability.portraitPage,
      ]),
      isDefault: true,
    );

    return const PdfDocumentRenderer().render(
      snapshot: snapshot,
      template: template,
      options: DocumentRenderOptions(
        pageProfile: DocumentPageProfile.a4Portrait(),
        generatedAt: generatedAt,
        showPageNumbers: true,
        maxPages: 20,
      ),
    );
  }

  List<DocumentSection> _metricSections(PlatformDashboardMetricsEntity metrics) {
    final sections = <DocumentSection>[];

    void addSection(String id, String title, List<DocumentMetric> values) {
      if (values.isEmpty) return;
      sections.add(
        DocumentSection(
          id: id,
          title: title,
          nodes: [DocumentMetricGrid(metrics: values, columns: 3)],
        ),
      );
    }

    if (metrics.networks case final value?) {
      addSection('networks', 'Network providers', [
        _integerMetric('Total networks', value.total),
        _integerMetric('Active networks', value.active),
        _integerMetric('Pending networks', value.pending),
        _integerMetric('Inactive networks', value.inactive),
        _integerMetric('Rejected networks', value.rejected),
        _integerMetric('Banned networks', value.banned),
      ]);
    }
    if (metrics.pos case final value?) {
      addSection('pos', 'Points of sale', [
        _integerMetric('Total POS', value.total),
        _integerMetric('Active POS', value.active),
        _integerMetric('Pending POS', value.pending),
        _integerMetric('Inactive POS', value.inactive),
        _integerMetric('Rejected POS', value.rejected),
        _integerMetric('Banned POS', value.banned),
      ]);
    }
    if (metrics.subscriptions case final value?) {
      addSection('subscriptions', 'Subscriptions', [
        _integerMetric('Total subscriptions', value.total),
        _integerMetric('Active subscriptions', value.active),
        _integerMetric('Queued subscriptions', value.queued),
        _integerMetric('Expired subscriptions', value.expired),
        _integerMetric('Expiring within 7 days', value.expiringWithin7Days),
      ]);
    }
    if (metrics.support case final value?) {
      addSection('support', 'Support', [
        _integerMetric('Total tickets', value.totalTickets),
        _integerMetric('Unread messages', value.unreadMessages),
      ]);
    }
    if (metrics.sales case final value?) {
      addSection('sales', 'Sales snapshot', [
        _integerMetric('Invoice count', value.invoiceCount),
        _textMetric('Total amount (server value)', value.totalAmount),
        _textMetric('Paid amount (server value)', value.paidAmount),
        _textMetric('Outstanding amount (server value)', value.outstandingAmount),
      ]);
    }
    if (metrics.expenses case final value?) {
      addSection('expenses', 'Expenses snapshot', [
        _integerMetric('Expense count', value.count),
        _textMetric('Total expenses (server value)', value.totalAmount),
      ]);
    }
    return sections;
  }

  List<DocumentNode> _chartAndTableNodes(
    PlatformDashboardChartsEntity charts,
  ) {
    final nodes = <DocumentNode>[];

    if (charts.subscriptionTrend.isNotEmpty) {
      if (charts.subscriptionTrend.length <= 24) {
        nodes.add(
          DocumentChart(
            title: 'Subscription trend',
            type: DocumentChartType.line,
            series: [
              DocumentChartSeries(
                id: 'subscription-count',
                label: 'Subscriptions',
                points: [
                  for (final point in charts.subscriptionTrend)
                    DocumentChartPoint(
                      label: point.period,
                      value: point.value.toDouble(),
                      displayValue: point.value.toString(),
                    ),
                ],
              ),
            ],
          ),
        );
      } else {
        nodes.add(_twoColumnTable(
          idPrefix: 'subscription-point',
          firstColumnId: 'period',
          firstColumnLabel: 'Period',
          secondColumnId: 'value',
          secondColumnLabel: 'Value',
          rows: [
            for (final point in charts.subscriptionTrend)
              (point.period, point.value.toString()),
          ],
        ));
      }
    }

    if (charts.providerDistribution.isNotEmpty) {
      if (charts.providerDistribution.length <= 24) {
        nodes.add(
          DocumentChart(
            title: 'Provider distribution',
            type: DocumentChartType.bar,
            series: [
              DocumentChartSeries(
                id: 'provider-status-count',
                label: 'Providers',
                points: [
                  for (final point in charts.providerDistribution)
                    DocumentChartPoint(
                      label: '${point.entity}-${point.status}',
                      value: point.value.toDouble(),
                      displayValue: point.value.toString(),
                    ),
                ],
              ),
            ],
          ),
        );
      } else {
        nodes.add(_twoColumnTable(
          idPrefix: 'provider-point',
          firstColumnId: 'category',
          firstColumnLabel: 'Category',
          secondColumnId: 'value',
          secondColumnLabel: 'Value',
          rows: [
            for (final point in charts.providerDistribution)
              ('${point.entity}-${point.status}', point.value.toString()),
          ],
        ));
      }
    }

    if (charts.operationalActivity.isNotEmpty) {
      if (charts.operationalActivity.length <= 24) {
        nodes.add(
          DocumentChart(
            title: 'Operational activity',
            type: DocumentChartType.line,
            series: [
              DocumentChartSeries(
                id: 'activity-count',
                label: 'Activity',
                points: [
                  for (final point in charts.operationalActivity)
                    DocumentChartPoint(
                      label: point.date,
                      value: point.value.toDouble(),
                      displayValue: point.value.toString(),
                    ),
                ],
              ),
            ],
          ),
        );
      } else {
        nodes.add(_twoColumnTable(
          idPrefix: 'activity-point',
          firstColumnId: 'date',
          firstColumnLabel: 'Date',
          secondColumnId: 'value',
          secondColumnLabel: 'Value',
          rows: [
            for (final point in charts.operationalActivity)
              (point.date, point.value.toString()),
          ],
        ));
      }
    }

    return nodes;
  }

  DocumentTable _twoColumnTable({
    required String idPrefix,
    required String firstColumnId,
    required String firstColumnLabel,
    required String secondColumnId,
    required String secondColumnLabel,
    required List<(String, String)> rows,
  }) => DocumentTable(
    columns: [
      DocumentTableColumn(id: firstColumnId, label: firstColumnLabel),
      DocumentTableColumn(id: secondColumnId, label: secondColumnLabel),
    ],
    rows: [
      for (var index = 0; index < rows.length; index++)
        DocumentTableRow(
          id: '${idPrefix}-${index}',
          cells: [
            DocumentTableCell(value: DocumentTextValue(rows[index].$1)),
            DocumentTableCell(value: DocumentTextValue(rows[index].$2)),
          ],
        ),
    ],
    style: DocumentTableStyle(stripedRows: true, compact: true),
  );

  DocumentMetric _integerMetric(String label, int value) => DocumentMetric(
    label: label,
    value: DocumentIntegerValue(value),
  );

  DocumentMetric _textMetric(String label, String value) => DocumentMetric(
    label: label,
    value: DocumentTextValue(value),
  );
}
