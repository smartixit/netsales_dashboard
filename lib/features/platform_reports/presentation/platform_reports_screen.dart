import 'package:flutter/material.dart';
import 'package:document_engine/document_engine.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/features/platform_reports/domain/entities/platform_report_models.dart';
import 'package:netsales_dashboard/features/platform_reports/presentation/platform_reports_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformReportsScreen extends GetView<PlatformReportsController> {
  const PlatformReportsScreen({super.key});

  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isLoading.value) return const CustomSkeletonGrid(itemCount: 6);
    if (controller.error.value != null) {
      return CustomErrorState.compact(
        title: 'تعذر تحميل تقارير الفوترة',
        subtitle: controller.error.value,
        onRetry: controller.loadCatalog,
      );
    }
    if (controller.engineDefinition.value != null &&
        controller.selectedReport.value != null) {
      return _PlatformReportConfiguration(controller: controller);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('تقارير فوترة المنصة', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('تقارير الاشتراكات وفواتيرها والتحصيلات والقيود المحاسبية. النتائج المالية لا تدمج عملات مختلفة.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
          AppSpacing.vLg,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: controller.catalog.map((report) => SizedBox(
              width: 360,
              child: _ReportCard(
                report: report,
                busy: controller.isCreating.value,
                onRun: () => controller.configure(report),
              ),
            )).toList(growable: false),
          ),
          if (controller.activeRun.value != null) ...[
            AppSpacing.vLg,
            _RunPanel(
              run: controller.activeRun.value!,
              refreshing: controller.isRefreshing.value,
              downloading: controller.isDownloading.value,
              sharing: controller.isSharing.value,
              onShare: controller.shareRun,
              onRefresh: controller.refreshRun,
              onDownload: controller.downloadRun,
            ),
          ],
        ],
      ),
    );
  });
}

class _PlatformReportConfiguration extends StatelessWidget {
  const _PlatformReportConfiguration({required this.controller});
  final PlatformReportsController controller;

  @override
  Widget build(BuildContext context) {
    final report = controller.selectedReport.value!;
    final definition = controller.engineDefinition.value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: CustomButton.secondary(
            text: 'العودة إلى كتالوج التقارير',
            prefix: Icons.arrow_back_rounded,
            onPressed: () {
              controller.clearConfiguration();
            },
          ),
        ),
        AppSpacing.vMd,
        Expanded(
          child: ReportConfigurationStudio(
            definition: definition,
            criteria: controller.criteria.value,
            presentation: controller.presentation.value,
            resolveLabel: (context, key) => _platformReportLabel(report, key),
            onCriteriaChanged: controller.updateCriteria,
            onPresentationChanged: controller.updatePresentation,
            onPreview: controller.createConfiguredReport,
            isBusy: controller.isCreating.value,
            actionBuilder: (
              context, {
              required label,
              required icon,
              required onPressed,
              required secondary,
            }) => secondary
                ? CustomButton.secondary(
                    text: _platformReportLabel(report, label),
                    prefix: icon,
                    onPressed: onPressed,
                  )
                : CustomButton.primary(
                    text: _platformReportLabel(report, label),
                    prefix: icon,
                    loading: controller.isCreating.value,
                    onPressed: onPressed,
                  ),
            filterSectionBuilder: (
              context, {
              required definition,
              required criteria,
              required resolveLabel,
              required onChanged,
            }) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('مرشحات التقرير', style: Theme.of(context).textTheme.titleMedium),
                    AppSpacing.vSm,
                    for (final filter in definition.filters) ...[
                      CustomTextField(
                        controller: controller.textControllerFor(filter.id),
                        label: _platformReportLabel(report, filter.labelKey),
                        hint: filter.kind == ReportFilterKind.date ? 'YYYY-MM-DD' : null,
                        keyboardType: filter.kind == ReportFilterKind.integer
                            ? TextInputType.number
                            : TextInputType.text,
                        isRequired: filter.required,
                        onChanged: (value) {
                          ReportFilterValue? parsed;
                          if (value.trim().isNotEmpty) {
                            switch (filter.kind) {
                              case ReportFilterKind.integer:
                                final number = int.tryParse(value.trim());
                                if (number != null) parsed = ReportIntegerFilterValue(number);
                                break;
                              case ReportFilterKind.date:
                                final date = DateTime.tryParse(value.trim());
                                if (date != null) parsed = ReportDateFilterValue(date);
                                break;
                              case ReportFilterKind.text:
                                parsed = ReportTextFilterValue(value.trim());
                                break;
                              default:
                                parsed = ReportTextFilterValue(value.trim());
                                break;
                            }
                          }
                          controller.updateFilter(filter.id, parsed);
                        },
                      ),
                      AppSpacing.vSm,
                    ],
                    if (criteria.validateAgainst(definition).isNotEmpty)
                      Text(
                        'توجد مرشحات غير مكتملة أو غير صالحة.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            presentationSectionBuilder: (
              context, {
              required definition,
              required presentation,
              required resolveLabel,
              required onChanged,
            }) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إعدادات الإخراج', style: Theme.of(context).textTheme.titleMedium),
                    AppSpacing.vSm,
                    const Text('تُنتج النتائج حالياً كلقطات JSON محفوظة في الخادم. ستتاح قوالب PDF بعد اكتمال ربط المستندات ودعم RTL الإنتاجي.'),
                    AppSpacing.vSm,
                    Text('صيغة الإخراج: ${report.format}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _platformReportLabel(PlatformReportCatalogItem report, String key) {
  if (key == 'report_title.${report.key}') return report.title;
  if (key == 'report_description.${report.key}') return report.description;
  if (key.startsWith('report_filter.')) {
    final field = key.substring('report_filter.'.length);
    return switch (field) {
      'billing_account_id' => 'معرّف حساب الفوترة',
      'network_id' => 'معرّف الشبكة',
      'currency_id' => 'معرّف العملة',
      'status' => 'الحالة',
      'search' => 'بحث',
      'from' || 'from_date' => 'من تاريخ',
      'to' || 'to_date' => 'إلى تاريخ',
      'invoice_id' => 'معرّف الفاتورة',
      'source_type' => 'نوع المصدر',
      _ => field,
    };
  }
  return switch (key) {
    'report_configuration.authorization_notice' => 'الصلاحيات ونطاق البيانات يحددهما الخادم ولا تغيّرهما خيارات العرض.',
    'report_configuration.schema_version' => 'مخطط',
    'report_configuration.server_execution' => 'تنفيذ على الخادم',
    'report_configuration.client_limit' => 'حد العميل',
    'report_configuration.data_criteria' => 'مرشحات التقرير',
    'report_configuration.data_criteria_hint' => 'حدد معايير التنفيذ المعتمدة لهذا التقرير.',
    'report_configuration.no_filters' => 'لا توجد مرشحات لهذا التقرير.',
    'report_configuration.output_design' => 'إعدادات الإخراج',
    'report_configuration.output_design_hint' => 'خيارات العرض والتنسيق.',
    'report_configuration.output_columns' => 'الأعمدة',
    'report_configuration.include_metrics' => 'تضمين المؤشرات',
    'report_configuration.include_charts' => 'تضمين الرسوم',
    'report_configuration.sort_by' => 'ترتيب حسب',
    'report_configuration.sort_direction' => 'اتجاه الترتيب',
    'report_configuration.ascending' => 'تصاعدي',
    'report_configuration.descending' => 'تنازلي',
    'report_configuration.group_by' => 'تجميع حسب',
    'report_configuration.no_grouping' => 'بدون تجميع',
    'report_configuration.template' => 'قالب المستند',
    'report_configuration.language' => 'لغة التقرير',
    'report_configuration.page_profile' => 'حجم الصفحة',
    'report_configuration.save_preset' => 'حفظ الإعداد',
    'report_configuration.preview' => 'إنشاء التقرير',
    'report_configuration.from_date' => 'من تاريخ',
    'report_configuration.to_date' => 'إلى تاريخ',
    'common.required' => 'مطلوب',
    'report_configuration.records_count' => 'عدد السجلات',
    _ => key,
  };
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report, required this.busy, required this.onRun});
  final PlatformReportCatalogItem report;
  final bool busy;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(report.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.vXs,
          Text(report.description, style: Theme.of(context).textTheme.bodyMedium),
          AppSpacing.vSm,
          Wrap(spacing: 8, children: [
            Chip(label: Text('v${report.version}')),
            Chip(label: Text('${report.maxRecords} سجل كحد أقصى')),
            Chip(label: Text(report.format)),
          ]),
          AppSpacing.vSm,
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CustomButton.primary(
              text: 'إعداد التقرير',
              prefix: Icons.play_arrow_rounded,
              loading: busy,
              onPressed: busy ? null : onRun,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RunPanel extends StatelessWidget {
  const _RunPanel({required this.run, required this.refreshing, required this.downloading, required this.sharing, required this.onShare, required this.onRefresh, required this.onDownload});
  final PlatformReportRun run;
  final bool refreshing;
  final bool downloading;
  final bool sharing;
  final VoidCallback onShare;
  final VoidCallback onRefresh;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('نتيجة التقرير: ${run.title}', style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.vXs,
          Text(run.isFailed ? (run.errorMessage ?? 'فشل التنفيذ') : run.status),
          if (run.isCompleted) Text('السجلات: ${run.recordsCount}${run.isTruncated ? ' (النتيجة محدودة)' : ''}'),
          AppSpacing.vSm,
          Wrap(spacing: 8, children: [
            CustomButton.secondary(text: 'تحديث الحالة', prefix: Icons.refresh_rounded, loading: refreshing, onPressed: refreshing ? null : onRefresh),
            if (run.isCompleted) CustomButton.primary(text: 'تنزيل JSON', prefix: Icons.download_rounded, loading: downloading, onPressed: downloading ? null : onDownload),
            if (run.isCompleted) CustomButton.secondary(text: 'مشاركة JSON', prefix: Icons.share_rounded, loading: sharing, onPressed: sharing ? null : onShare),
          ]),
        ],
      ),
    ),
  );
}
