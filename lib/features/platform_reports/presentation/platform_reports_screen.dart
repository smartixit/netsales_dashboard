import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('تقارير فوترة المنصة', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('تقارير الاشتراكات وفواتيرها والتحصيلات والقيود المحاسبية. النتائج المالية لا تدمج عملات مختلفة.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
          AppSpacing.vLg,
          _Filters(controller: controller),
          AppSpacing.vLg,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: controller.catalog.map((report) => SizedBox(
              width: 360,
              child: _ReportCard(
                report: report,
                busy: controller.isCreating.value,
                onRun: () => controller.create(report),
              ),
            )).toList(growable: false),
          ),
          if (controller.activeRun.value != null) ...[
            AppSpacing.vLg,
            _RunPanel(
              run: controller.activeRun.value!,
              refreshing: controller.isRefreshing.value,
              downloading: controller.isDownloading.value,
              onRefresh: controller.refreshRun,
              onDownload: controller.downloadRun,
            ),
          ],
        ],
      ),
    );
  });
}

class _Filters extends StatelessWidget {
  const _Filters({required this.controller});
  final PlatformReportsController controller;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          SizedBox(width: 210, child: CustomTextField(controller: controller.networkIdController, label: 'معرّف الشبكة', hint: 'اختياري', keyboardType: TextInputType.number, isRequired: false)),
          SizedBox(width: 210, child: CustomTextField(controller: controller.accountIdController, label: 'حساب الفوترة', hint: 'اختياري', keyboardType: TextInputType.number, isRequired: false)),
          SizedBox(width: 180, child: CustomTextField(controller: controller.currencyIdController, label: 'العملة', hint: 'Currency ID', keyboardType: TextInputType.number, isRequired: false)),
          SizedBox(width: 180, child: CustomTextField(controller: controller.statusController, label: 'الحالة', hint: 'ACTIVE / PAID ...', isRequired: false)),
          SizedBox(width: 220, child: CustomTextField(controller: controller.searchController, label: 'بحث', hint: 'رقم الفاتورة أو الحساب', isRequired: false)),
          SizedBox(width: 180, child: CustomTextField(controller: controller.fromDateController, label: 'من تاريخ', hint: 'YYYY-MM-DD', isRequired: false)),
          SizedBox(width: 180, child: CustomTextField(controller: controller.toDateController, label: 'إلى تاريخ', hint: 'YYYY-MM-DD', isRequired: false)),
        ],
      ),
    ),
  );
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
              text: 'إنشاء التقرير',
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
  const _RunPanel({required this.run, required this.refreshing, required this.downloading, required this.onRefresh, required this.onDownload});
  final PlatformReportRun run;
  final bool refreshing;
  final bool downloading;
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
          ]),
        ],
      ),
    ),
  );
}
