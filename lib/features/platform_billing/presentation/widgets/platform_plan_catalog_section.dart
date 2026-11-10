import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/presentation/enums/semantic_tone.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_plan_editor_form.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_product_editor_form.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';

class PlatformPlanCatalogSection extends StatelessWidget {
  const PlatformPlanCatalogSection({super.key, required this.controller});

  final PlatformBillingController controller;

  bool get _canCreatePlan => PermissionService.to.canAll(const [
        AppPermissions.billingCreate,
        AppPermissions.billingEdit,
      ]);

  bool get _canCreateProduct => PermissionService.to.can(AppPermissions.billingCreate);

  bool get _canPublish => PermissionService.to.can(AppPermissions.billingManage);

  Future<void> _showProductDialog() => CustomDialog.show(
        type: DialogType.custom,
        title: 'إضافة منتج فوترة',
        content: PlatformProductEditorForm(controller: controller),
        confirmLabel: 'إنشاء المنتج',
        cancelLabel: 'إلغاء',
        maxWidth: 560,
        onConfirm: () => unawaited(controller.createBillingProduct(
          key: controller.productKeyController.text,
          name: controller.productNameController.text,
          description: controller.productDescriptionController.text,
        )),
      );

  Future<void> _showPlanDialog() => CustomDialog.show(
        type: DialogType.custom,
        title: controller.hasPendingPlanWorkflow ? 'استكمال إنشاء الخطة' : 'إنشاء خطة وإصدار مسودة',
        content: PlatformPlanEditorForm(controller: controller),
        confirmLabel: controller.hasPendingPlanWorkflow ? 'استكمال الحفظ' : 'إنشاء الخطة كمسودة',
        cancelLabel: 'إلغاء',
        maxWidth: 760,
        onConfirm: () => unawaited(controller.createPlanWithInitialPrice()),
      );

  Future<void> _confirmPublish(BillingPlanEntity plan, BillingPlanVersionEntity version) =>
      CustomDialog.showConfirmation(
        title: 'نشر إصدار الخطة',
        message: 'سيتم اعتماد الإصدار ' +
            version.versionNumber.toString() +
            ' وتثبيت أسعاره ومزاياه. أي تغيير لاحق يتطلب إنشاء إصدار مسودة جديد. هل تريد المتابعة؟',
        confirmLabel: 'نشر الإصدار',
        cancelLabel: 'العودة',
        onConfirm: () => unawaited(controller.publishPlanDraft(plan.id, version.id)),
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'كتالوج الخطط',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'منتجات وخطط بإصدارات تجارية ثابتة وأسعار مستقلة لكل عملة.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (_canCreateProduct)
                CustomButton.outline(
                  text: 'منتج جديد',
                  size: AppButtonSize.small,
                  prefix: const Icon(Icons.inventory_2_outlined, size: 17),
                  onPressed: () => unawaited(_showProductDialog()),
                ),
              const SizedBox(width: 8),
              if (_canCreatePlan)
                CustomButton.primary(
                  text: controller.hasPendingPlanWorkflow ? 'استكمال المسودة' : 'خطة جديدة',
                  size: AppButtonSize.small,
                  prefix: const Icon(Icons.add_rounded, size: 18),
                  onPressed: () => unawaited(_showPlanDialog()),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Obx(() {
            if (controller.isPlansLoading.value && controller.plans.isEmpty) {
              return const CustomSkeletonGrid(count: 4, crossAxisCount: 2, itemHeight: 170);
            }
            if (controller.plans.isEmpty) {
              return _EmptyPlansPanel(
                message: controller.isProductsLoading.value
                    ? 'جارٍ تحميل المنتجات والتهيئة لإنشاء أول خطة.'
                    : 'لا توجد خطط بعد. ابدأ بإنشاء منتج ثم أنشئ خطتك الأولى.',
              );
            }
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final plan in controller.plans)
                  _PlanCard(
                    plan: plan,
                    versions: controller.planVersions[plan.id] ?? const [],
                    isLoadingVersions: controller.loadingPlanVersions.contains(plan.id),
                    canPublish: _canPublish,
                    onLoadVersions: () => controller.loadPlanVersions(plan.id),
                    onPublish: (version) => _confirmPublish(plan, version),
                  ),
              ],
            );
          }),
        ],
      );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.versions,
    required this.isLoadingVersions,
    required this.canPublish,
    required this.onLoadVersions,
    required this.onPublish,
  });

  final BillingPlanEntity plan;
  final List<BillingPlanVersionEntity> versions;
  final bool isLoadingVersions;
  final bool canPublish;
  final VoidCallback onLoadVersions;
  final ValueChanged<BillingPlanVersionEntity> onPublish;

  @override
  Widget build(BuildContext context) => Container(
        width: 390,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                CustomStatusBadge(
                  label: plan.isActive ? 'نشطة' : 'متوقفة',
                  tone: plan.isActive ? SemanticTone.success : SemanticTone.neutral,
                  isCompact: true,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              plan.key + ' · ' + (plan.productName ?? 'منتج غير محدد'),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 14),
            if (plan.currentVersion != null) ...[
              Text(
                'الإصدار الحالي ' + plan.currentVersion!.versionNumber.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final price in plan.currentVersion!.prices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    (price.currency?.code ?? '') + ' · ' + (price.unitAmount ?? '—') + ' / ' + price.billingInterval,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              if (plan.currentVersion!.trialPolicy case final trial?)
                Text(
                  trial.isEnabled
                      ? 'تجربة: ' + trial.durationValue.toString() + ' ' + trial.durationUnit
                      : 'التجربة غير مفعلة',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ] else
              Text(
                'لم يُنشر إصدار بعد. أنشئ إصداراً مسودة وأضف سعره قبل نشره.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            const SizedBox(height: 12),
            CustomButton.outline(
              text: isLoadingVersions ? 'تحميل السجل...' : 'سجل الإصدارات',
              size: AppButtonSize.small,
              loading: isLoadingVersions,
              onPressed: onLoadVersions,
            ),
            if (versions.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                'الإصدارات',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final version in versions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('الإصدار ' + version.versionNumber.toString())),
                          CustomStatusBadge(
                            label: version.statusLabel ?? version.status,
                            tone: switch (version.typedStatus) {
                              BillingPlanVersionStatus.published => SemanticTone.success,
                              BillingPlanVersionStatus.draft => SemanticTone.warning,
                              _ => SemanticTone.neutral,
                            },
                            isCompact: true,
                          ),
                        ],
                      ),
                      for (final price in version.prices)
                        Text(
                          (price.currency?.code ?? '') + ' · ' + (price.unitAmount ?? '—') + ' / ' + price.billingInterval,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      for (final feature in version.features)
                        Text(
                          feature.name + ': ' + (feature.value ?? '—'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (canPublish && version.typedStatus == BillingPlanVersionStatus.draft)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: CustomButton.primary(
                            text: 'نشر الإصدار',
                            size: AppButtonSize.small,
                            onPressed: () => onPublish(version),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      );
}

class _EmptyPlansPanel extends StatelessWidget {
  const _EmptyPlansPanel({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
}
