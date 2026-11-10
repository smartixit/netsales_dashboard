import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/presentation/enums/semantic_tone.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_plan_editor_form.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_policy_assignment_form.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_draft_price_editor_form.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_draft_feature_editor_form.dart';
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

  bool get _canEditDraft => PermissionService.to.can(AppPermissions.billingEdit);

  Future<bool?> _showProductDialog() => CustomDialog.show(
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

  Future<bool?> _showPlanDialog() => CustomDialog.show(
        type: DialogType.custom,
        title: controller.hasPendingPlanWorkflow ? 'استكمال إنشاء الخطة' : 'إنشاء خطة وإصدار مسودة',
        content: PlatformPlanEditorForm(controller: controller),
        confirmLabel: controller.hasPendingPlanWorkflow ? 'استكمال الحفظ' : 'إنشاء الخطة كمسودة',
        cancelLabel: 'إلغاء',
        maxWidth: 760,
        onConfirm: () => unawaited(controller.createPlanWithInitialPrice()),
      );

  Future<bool?> _showDraftPriceDialog(BillingPlanEntity plan, BillingPlanVersionEntity version) {
    controller.prepareDraftPriceEditor();
    return CustomDialog.show(
      type: DialogType.custom,
      title: 'إضافة سعر إلى الإصدار ' + version.versionNumber.toString(),
      content: PlatformDraftPriceEditorForm(controller: controller),
      confirmLabel: 'إضافة السعر',
      cancelLabel: 'إلغاء',
      maxWidth: 620,
      onConfirm: () {
        final currencyId = controller.selectedPlanCurrencyId.value;
        final interval = controller.selectedPlanBillingInterval.value;
        if (currencyId == null || interval == null) return;
        unawaited(controller.addPriceToDraft(
          planId: plan.id,
          versionId: version.id,
          currencyId: currencyId,
          billingInterval: interval,
          unitAmount: controller.planUnitAmountController.text,
          setupFee: controller.planSetupFeeController.text,
        ));
      },
    );
  }

  Future<bool?> _showDraftFeatureDialog(BillingPlanEntity plan, BillingPlanVersionEntity version) {
    controller.prepareDraftFeatureEditor();
    return CustomDialog.show(
      type: DialogType.custom,
      title: 'إضافة ميزة إلى الإصدار ' + version.versionNumber.toString(),
      content: PlatformDraftFeatureEditorForm(controller: controller),
      confirmLabel: 'إضافة الميزة',
      cancelLabel: 'إلغاء',
      maxWidth: 620,
      onConfirm: () => unawaited(controller.addFeatureToDraft(
        planId: plan.id,
        versionId: version.id,
        featureKey: controller.planFeatureKeyController.text,
        name: controller.planFeatureNameController.text,
        featureType: controller.selectedPlanFeatureType.value ?? 'RESOURCE_LIMIT',
        value: controller.planFeatureValueController.text,
        unit: controller.planFeatureUnitController.text,
      )),
    );
  }

  Future<bool?> _showVersionPolicyAssignment(BillingPlanEntity plan, BillingPlanVersionEntity version) {
    controller.selectedTrialPolicyVersionId.value = version.trialPolicyVersionId;
    controller.selectedDunningPolicyVersionId.value = version.dunningPolicyVersionId;
    return CustomDialog.show(
      type: DialogType.custom,
      title: 'ربط السياسات بإصدار الخطة ' + version.versionNumber.toString(),
      content: PlatformPolicyAssignmentForm(controller: controller),
      confirmLabel: 'حفظ الارتباط',
      cancelLabel: 'إلغاء',
      maxWidth: 620,
      onConfirm: () => unawaited(controller.assignPoliciesToPlanVersion(
        plan.id,
        version.id,
        trialPolicyVersionId: controller.selectedTrialPolicyVersionId.value,
        dunningPolicyVersionId: controller.selectedDunningPolicyVersionId.value,
      )),
    );
  }

  Future<bool?> _showPricePolicyAssignment(BillingPlanEntity plan, BillingPlanVersionEntity version, BillingPriceEntity price) {
    controller.selectedTrialPolicyVersionId.value = price.trialPolicyVersionId;
    controller.selectedDunningPolicyVersionId.value = price.dunningPolicyVersionId;
    return CustomDialog.show(
      type: DialogType.custom,
      title: 'ربط السياسات بسعر ' + (price.currency?.code ?? ''),
      content: PlatformPolicyAssignmentForm(controller: controller),
      confirmLabel: 'حفظ الارتباط',
      cancelLabel: 'إلغاء',
      maxWidth: 620,
      onConfirm: () => unawaited(controller.assignPoliciesToPrice(
        plan.id,
        version.id,
        price.id,
        trialPolicyVersionId: controller.selectedTrialPolicyVersionId.value,
        dunningPolicyVersionId: controller.selectedDunningPolicyVersionId.value,
      )),
    );
  }

  Future<bool?> _confirmPublish(BillingPlanEntity plan, BillingPlanVersionEntity version) =>
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
          Obx(() => Row(
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
          )),
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
                    controller: controller,
                    versions: controller.planVersions[plan.id] ?? const [],
                    isLoadingVersions: controller.loadingPlanVersions.contains(plan.id),
                    canPublish: _canPublish,
                    canEditDraft: _canEditDraft,
                    onLoadVersions: () => controller.loadPlanVersions(plan.id),
                    onPublish: (version) => _confirmPublish(plan, version),
                    onAddPrice: (version) => _showDraftPriceDialog(plan, version),
                    onAddFeature: (version) => _showDraftFeatureDialog(plan, version),
                    onAssignVersionPolicies: (version) => _showVersionPolicyAssignment(plan, version),
                    onAssignPricePolicies: (version, price) => _showPricePolicyAssignment(plan, version, price),
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
    required this.controller,
    required this.versions,
    required this.isLoadingVersions,
    required this.canPublish,
    required this.canEditDraft,
    required this.onLoadVersions,
    required this.onPublish,
    required this.onAddPrice,
    required this.onAddFeature,
    required this.onAssignVersionPolicies,
    required this.onAssignPricePolicies,
  });

  final BillingPlanEntity plan;
  final PlatformBillingController controller;
  final List<BillingPlanVersionEntity> versions;
  final bool isLoadingVersions;
  final bool canPublish;
  final bool canEditDraft;
  final VoidCallback onLoadVersions;
  final ValueChanged<BillingPlanVersionEntity> onPublish;
  final ValueChanged<BillingPlanVersionEntity> onAddPrice;
  final ValueChanged<BillingPlanVersionEntity> onAddFeature;
  final ValueChanged<BillingPlanVersionEntity> onAssignVersionPolicies;
  final void Function(BillingPlanVersionEntity, BillingPriceEntity) onAssignPricePolicies;

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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (price.currency?.code ?? '') + ' · ' + (price.unitAmount ?? '—') + ' / ' + price.billingInterval,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              if (version.typedStatus == BillingPlanVersionStatus.draft && canEditDraft)
                                CustomButton.text(
                                  text: 'السياسات',
                                  size: AppButtonSize.small,
                                  onPressed: () => onAssignPricePolicies(version, price),
                                ),
                            ],
                          ),
                        ),
                      for (final feature in version.features)
                        Text(
                          feature.name + ': ' + (feature.value ?? '—'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (version.typedStatus == BillingPlanVersionStatus.draft && canEditDraft) ...[
                        const SizedBox(height: 8),
                        CustomButton.text(
                          text: 'ربط سياسات الاشتراك',
                          size: AppButtonSize.small,
                          icon: Icons.rule_folder_outlined,
                          onPressed: () => onAssignVersionPolicies(version),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            CustomButton.outline(
                              text: 'إضافة سعر',
                              size: AppButtonSize.small,
                              prefix: const Icon(Icons.add_card_outlined, size: 16),
                              onPressed: () => onAddPrice(version),
                            ),
                            CustomButton.outline(
                              text: 'إضافة ميزة',
                              size: AppButtonSize.small,
                              prefix: const Icon(Icons.extension_outlined, size: 16),
                              onPressed: () => onAddFeature(version),
                            ),
                          ],
                        ),
                      ],
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
