import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/presentation/enums/semantic_tone.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_dunning_policy_editor_form.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/widgets/platform_trial_policy_editor_form.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformBillingPoliciesSection extends StatelessWidget {
  const PlatformBillingPoliciesSection({super.key, required this.controller});

  final PlatformBillingController controller;

  bool get _canManage => PermissionService.to.can(AppPermissions.billingManage);

  Future<bool?> _showTrialPolicyDialog({BillingTrialPolicyEntity? policy}) {
    controller.prepareTrialPolicyEditor(policy: policy);
    return CustomDialog.show(
      type: DialogType.custom,
      title: policy == null ? 'إنشاء سياسة تجربة' : 'إصدار جديد لسياسة التجربة',
      content: PlatformTrialPolicyEditorForm(
        controller: controller,
        showIdentityFields: policy == null,
      ),
      confirmLabel: policy == null ? 'إنشاء المسودة' : 'إنشاء الإصدار',
      cancelLabel: 'إلغاء',
      maxWidth: 760,
      onConfirm: () => unawaited(controller.saveTrialPolicy(policyId: policy?.id)),
    );
  }

  Future<bool?> _showDunningPolicyDialog({BillingDunningPolicyEntity? policy}) {
    controller.prepareDunningPolicyEditor(policy: policy);
    return CustomDialog.show(
      type: DialogType.custom,
      title: policy == null ? 'إنشاء سياسة تحصيل' : 'إصدار جديد لسياسة التحصيل',
      content: PlatformDunningPolicyEditorForm(
        controller: controller,
        showIdentityFields: policy == null,
      ),
      confirmLabel: policy == null ? 'إنشاء المسودة' : 'إنشاء الإصدار',
      cancelLabel: 'إلغاء',
      maxWidth: 680,
      onConfirm: () => unawaited(controller.saveDunningPolicy(policyId: policy?.id)),
    );
  }

  Future<bool?> _confirmPublishTrial(
    BillingTrialPolicyEntity policy,
    BillingTrialPolicyVersionEntity version,
  ) => CustomDialog.showConfirmation(
        title: 'نشر سياسة التجربة',
        message: 'سيصبح الإصدار ' + version.versionNumber.toString() +
            ' هو الإصدار الحالي للسياسة. لن يمكن تعديل شروطه بعد النشر.',
        confirmLabel: 'نشر الإصدار',
        cancelLabel: 'العودة',
        onConfirm: () => unawaited(controller.publishTrialPolicyVersion(policy.id, version.id)),
      );

  Future<bool?> _confirmPublishDunning(
    BillingDunningPolicyEntity policy,
    BillingDunningPolicyVersionEntity version,
  ) => CustomDialog.showConfirmation(
        title: 'نشر سياسة التحصيل',
        message: 'سيصبح الإصدار ' + version.versionNumber.toString() +
            ' هو الإصدار الحالي للسياسة. لن يمكن تعديل شروطه بعد النشر.',
        confirmLabel: 'نشر الإصدار',
        cancelLabel: 'العودة',
        onConfirm: () => unawaited(controller.publishDunningPolicyVersion(policy.id, version.id)),
      );

  Future<bool?> _confirmApprove(BillingTrialRedemptionEntity redemption) =>
      CustomDialog.showConfirmation(
        title: 'اعتماد طلب التجربة',
        message: 'سيُعتمد طلب التجربة للشبكة ' +
            (redemption.networkName ?? 'رقم ' + (redemption.networkId?.toString() ?? 'غير معروف')) +
            '. إذا كان بدء التجربة عند أول تفعيل فسيبقى الاشتراك محجوزاً حتى ذلك الوقت.',
        confirmLabel: 'اعتماد الطلب',
        cancelLabel: 'العودة',
        onConfirm: () => unawaited(controller.approveTrialRedemption(redemption.id)),
      );

  Future<bool?> _showRejectDialog(BillingTrialRedemptionEntity redemption) {
    controller.trialDecisionReasonController.clear();
    return CustomDialog.show(
      type: DialogType.custom,
      title: 'رفض طلب التجربة',
      content: CustomTextField(
        controller: controller.trialDecisionReasonController,
        label: 'سبب الرفض',
        hint: 'اشرح سبب رفض الطلب',
        minLines: 2,
        maxLines: 4,
      ),
      confirmLabel: 'رفض الطلب',
      cancelLabel: 'إلغاء',
      maxWidth: 520,
      onConfirm: () => unawaited(controller.rejectTrialRedemption(
        redemption.id,
        controller.trialDecisionReasonController.text.trim(),
      )),
    );
  }

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
                      'سياسات الاشتراك',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سياسات تجربة وتحصل مستقلة، ذات إصدارات ثابتة قابلة للربط بالخطة أو السعر.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (_canManage)
                CustomButton.outline(
                  text: 'سياسة تحصيل',
                  size: AppButtonSize.small,
                  prefix: const Icon(Icons.notifications_active_outlined, size: 17),
                  onPressed: () => unawaited(_showDunningPolicyDialog()),
                ),
              const SizedBox(width: 8),
              if (_canManage)
                CustomButton.primary(
                  text: 'سياسة تجربة',
                  size: AppButtonSize.small,
                  prefix: const Icon(Icons.hourglass_top_rounded, size: 17),
                  onPressed: () => unawaited(_showTrialPolicyDialog()),
                ),
            ],
          ),
          const SizedBox(height: 22),
          _buildTrialPolicies(context),
          const SizedBox(height: 24),
          _buildDunningPolicies(context),
          const SizedBox(height: 24),
          _buildPendingTrials(context),
        ],
      );

  Widget _buildTrialPolicies(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('سياسات التجربة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isTrialPoliciesLoading.value && controller.trialPolicies.isEmpty) {
              return const CustomSkeletonGrid(count: 2, crossAxisCount: 2, itemHeight: 150);
            }
            if (controller.trialPolicies.isEmpty) {
              return const _PolicyEmptyPanel(message: 'لا توجد سياسة تجربة. أنشئ سياسة ثم انشر إصدارها قبل ربطها بالخطط.');
            }
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final policy in controller.trialPolicies)
                  _TrialPolicyCard(
                    policy: policy,
                    versions: controller.trialPolicyVersions[policy.id] ?? const [],
                    isLoading: controller.isTrialPolicyVersionsLoading.contains(policy.id),
                    canManage: _canManage,
                    onLoadVersions: () => controller.loadTrialPolicyVersions(policy.id),
                    onNewVersion: () => _showTrialPolicyDialog(policy: policy),
                    onPublish: (version) => _confirmPublishTrial(policy, version),
                  ),
              ],
            );
          }),
        ],
      );

  Widget _buildDunningPolicies(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('سياسات التحصيل والتنبيهات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isDunningPoliciesLoading.value && controller.dunningPolicies.isEmpty) {
              return const CustomSkeletonGrid(count: 2, crossAxisCount: 2, itemHeight: 150);
            }
            if (controller.dunningPolicies.isEmpty) {
              return const _PolicyEmptyPanel(message: 'لا توجد سياسة تحصيل. أنشئ واحدة لضبط مهلة السماح والتنبيهات.');
            }
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final policy in controller.dunningPolicies)
                  _DunningPolicyCard(
                    policy: policy,
                    versions: controller.dunningPolicyVersions[policy.id] ?? const [],
                    isLoading: controller.isDunningPolicyVersionsLoading.contains(policy.id),
                    canManage: _canManage,
                    onLoadVersions: () => controller.loadDunningPolicyVersions(policy.id),
                    onNewVersion: () => _showDunningPolicyDialog(policy: policy),
                    onPublish: (version) => _confirmPublishDunning(policy, version),
                  ),
              ],
            );
          }),
        ],
      );

  Widget _buildPendingTrials(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'طلبات التجربة بانتظار المراجعة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              CustomButton.text(
                text: 'تحديث',
                size: AppButtonSize.small,
                icon: Icons.refresh_rounded,
                onPressed: () => controller.loadPendingTrialRedemptions(reset: true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isPendingRedemptionsLoading.value && controller.pendingTrialRedemptions.isEmpty) {
              return const CustomSkeletonGrid(count: 2, crossAxisCount: 2, itemHeight: 130);
            }
            if (controller.pendingTrialRedemptions.isEmpty) {
              return const _PolicyEmptyPanel(message: 'لا توجد طلبات تجربة معلقة.');
            }
            return Column(
              children: [
                for (final redemption in controller.pendingTrialRedemptions)
                  _RedemptionCard(
                    redemption: redemption,
                    canManage: _canManage,
                    onApprove: () => _confirmApprove(redemption),
                    onReject: () => _showRejectDialog(redemption),
                  ),
                if (controller.canLoadMorePendingRedemptions)
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: CustomButton.outline(
                      text: 'تحميل المزيد',
                      size: AppButtonSize.small,
                      onPressed: () => controller.loadPendingTrialRedemptions(),
                    ),
                  ),
              ],
            );
          }),
        ],
      );
}

class _TrialPolicyCard extends StatelessWidget {
  const _TrialPolicyCard({
    required this.policy,
    required this.versions,
    required this.isLoading,
    required this.canManage,
    required this.onLoadVersions,
    required this.onNewVersion,
    required this.onPublish,
  });

  final BillingTrialPolicyEntity policy;
  final List<BillingTrialPolicyVersionEntity> versions;
  final bool isLoading;
  final bool canManage;
  final VoidCallback onLoadVersions;
  final VoidCallback onNewVersion;
  final ValueChanged<BillingTrialPolicyVersionEntity> onPublish;

  @override
  Widget build(BuildContext context) => _PolicyCardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PolicyCardHeader(
              title: policy.name,
              keyText: policy.key,
              status: policy.currentVersion?.status ?? 'لا يوجد إصدار منشور',
              isPublished: policy.currentVersion?.isPublished == true,
            ),
            const SizedBox(height: 12),
            if (policy.currentVersion != null) ...[
              Text('المدة: ' + policy.currentVersion!.durationValue.toString() + ' ' + policy.currentVersion!.durationUnit, style: Theme.of(context).textTheme.bodySmall),
              Text('البداية: ' + policy.currentVersion!.startTrigger + ' · النطاق: ' + policy.currentVersion!.redemptionScope, style: Theme.of(context).textTheme.bodySmall),
              Text(
                policy.currentVersion!.requiresManualApproval ? 'يتطلب اعتماداً يدوياً' : 'يبدأ تلقائياً عند تحقق الاستحقاق',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomButton.outline(
                  text: isLoading ? 'تحميل الإصدارات...' : 'سجل الإصدارات',
                  size: AppButtonSize.small,
                  loading: isLoading,
                  onPressed: onLoadVersions,
                ),
                if (canManage)
                  CustomButton.text(text: 'إصدار جديد', size: AppButtonSize.small, icon: Icons.add_rounded, onPressed: onNewVersion),
              ],
            ),
            if (versions.isNotEmpty) ...[
              const Divider(height: 22),
              for (final version in versions)
                _TrialVersionRow(version: version, canPublish: canManage, onPublish: () => onPublish(version)),
            ],
          ],
        ),
      );
}

class _DunningPolicyCard extends StatelessWidget {
  const _DunningPolicyCard({
    required this.policy,
    required this.versions,
    required this.isLoading,
    required this.canManage,
    required this.onLoadVersions,
    required this.onNewVersion,
    required this.onPublish,
  });

  final BillingDunningPolicyEntity policy;
  final List<BillingDunningPolicyVersionEntity> versions;
  final bool isLoading;
  final bool canManage;
  final VoidCallback onLoadVersions;
  final VoidCallback onNewVersion;
  final ValueChanged<BillingDunningPolicyVersionEntity> onPublish;

  @override
  Widget build(BuildContext context) => _PolicyCardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PolicyCardHeader(
              title: policy.name,
              keyText: policy.key,
              status: policy.currentVersion?.status ?? 'لا يوجد إصدار منشور',
              isPublished: policy.currentVersion?.isPublished == true,
            ),
            const SizedBox(height: 12),
            if (policy.currentVersion != null) ...[
              Text('مهلة السماح: ' + policy.currentVersion!.gracePeriodDays.toString() + ' يوم', style: Theme.of(context).textTheme.bodySmall),
              Text(
                policy.currentVersion!.autoSuspendAfterGrace ? 'الإيقاف التلقائي بعد المهلة مفعل' : 'الإيقاف التلقائي بعد المهلة معطل',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'التذكيرات: ' + policy.currentVersion!.reminderScheduleDays.join(', ') +
                    ' · قبل التجديد: ' + policy.currentVersion!.preRenewalAlertDays.join(', '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomButton.outline(
                  text: isLoading ? 'تحميل الإصدارات...' : 'سجل الإصدارات',
                  size: AppButtonSize.small,
                  loading: isLoading,
                  onPressed: onLoadVersions,
                ),
                if (canManage)
                  CustomButton.text(text: 'إصدار جديد', size: AppButtonSize.small, icon: Icons.add_rounded, onPressed: onNewVersion),
              ],
            ),
            if (versions.isNotEmpty) ...[
              const Divider(height: 22),
              for (final version in versions)
                _DunningVersionRow(version: version, canPublish: canManage, onPublish: () => onPublish(version)),
            ],
          ],
        ),
      );
}

class _TrialVersionRow extends StatelessWidget {
  const _TrialVersionRow({required this.version, required this.canPublish, required this.onPublish});

  final BillingTrialPolicyVersionEntity version;
  final bool canPublish;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الإصدار ' + version.versionNumber.toString() + ' · ' + version.durationValue.toString() + ' ' + version.durationUnit),
                  Text(
                    version.startTrigger + ' · ' + version.redemptionScope + ' · ' + version.eligibilityMode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            CustomStatusBadge(
              label: version.status,
              tone: version.isPublished ? SemanticTone.success : SemanticTone.warning,
              isCompact: true,
            ),
            if (canPublish && version.isDraft) ...[
              const SizedBox(width: 8),
              CustomButton.primary(text: 'نشر', size: AppButtonSize.small, onPressed: onPublish),
            ],
          ],
        ),
      );
}

class _DunningVersionRow extends StatelessWidget {
  const _DunningVersionRow({required this.version, required this.canPublish, required this.onPublish});

  final BillingDunningPolicyVersionEntity version;
  final bool canPublish;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'الإصدار ' + version.versionNumber.toString() + ' · سماح ' +
                    version.gracePeriodDays.toString() + ' يوم · ' +
                    version.reminderScheduleDays.join(', '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            CustomStatusBadge(
              label: version.status,
              tone: version.isPublished ? SemanticTone.success : SemanticTone.warning,
              isCompact: true,
            ),
            if (canPublish && version.isDraft) ...[
              const SizedBox(width: 8),
              CustomButton.primary(text: 'نشر', size: AppButtonSize.small, onPressed: onPublish),
            ],
          ],
        ),
      );
}

class _RedemptionCard extends StatelessWidget {
  const _RedemptionCard({
    required this.redemption,
    required this.canManage,
    required this.onApprove,
    required this.onReject,
  });

  final BillingTrialRedemptionEntity redemption;
  final bool canManage;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) => _PolicyCardShell(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.hourglass_top_rounded, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    redemption.networkName ?? 'شبكة ' + (redemption.networkId?.toString() ?? 'غير معروفة'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'حساب ' + (redemption.accountNumber ?? redemption.billingAccountId?.toString() ?? '—') +
                        ' · ' + (redemption.policyName ?? redemption.policyKey ?? 'سياسة تجربة') +
                        ' · ' + redemption.redemptionScope,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  if (redemption.reservedAt != null)
                    Text('تاريخ الطلب: ' + redemption.reservedAt.toString(), style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            CustomStatusBadge(label: redemption.status, tone: SemanticTone.warning, isCompact: true),
            if (canManage) ...[
              const SizedBox(width: 8),
              CustomButton.primary(text: 'اعتماد', size: AppButtonSize.small, onPressed: onApprove),
              const SizedBox(width: 6),
              CustomButton.danger(text: 'رفض', size: AppButtonSize.small, onPressed: onReject),
            ],
          ],
        ),
      );
}

class _PolicyCardHeader extends StatelessWidget {
  const _PolicyCardHeader({
    required this.title,
    required this.keyText,
    required this.status,
    required this.isPublished,
  });

  final String title;
  final String keyText;
  final String status;
  final bool isPublished;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                Text(keyText, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          CustomStatusBadge(
            label: status,
            tone: isPublished ? SemanticTone.success : SemanticTone.neutral,
            isCompact: true,
          ),
        ],
      );
}

class _PolicyCardShell extends StatelessWidget {
  const _PolicyCardShell({required this.child, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Container(
        width: 520,
        margin: margin,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .45)),
        ),
        child: child,
      );
}

class _PolicyEmptyPanel extends StatelessWidget {
  const _PolicyEmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
}
