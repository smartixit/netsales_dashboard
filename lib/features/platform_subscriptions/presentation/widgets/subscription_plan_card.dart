import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/utils/amount_formatter.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation.dart';
import 'package:netsales_dashboard/core/presentation/enums/semantic_tone.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({required this.plan, required this.l10n, required this.canEdit, required this.canDelete, required this.onEdit, required this.onToggle, required this.onDelete, super.key});
  final SubscriptionPlanEntity plan;
  final AppLocalizations l10n;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(20), border: Border.all(color: colors.outlineVariant.withValues(alpha: .65))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: BorderRadius.circular(14)), child: Icon(Icons.workspace_premium_rounded, color: colors.onPrimaryContainer)),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(plan.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium)),
          CustomStatusBadge.fromPresentation(
            plan.isActive ? EnumPresentation(label: l10n.text('active'), tone: SemanticTone.success, icon: Icons.check_circle_rounded) : EnumPresentation(label: l10n.text('inactive'), tone: SemanticTone.neutral, icon: Icons.pause_circle_outline_rounded),
            isCompact: true,
          ),
        ]),
        SizedBox(height: AppSpacing.lg),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(AmountFormatter.format(plan.price), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: colors.primary)),
          SizedBox(width: AppSpacing.xs),
          Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(l10n.text('plan_price_label'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant))),
        ]),
        SizedBox(height: AppSpacing.xs),
        Text(l10n.text('plan_validity_value').replaceAll('{days}', plan.validityDays.toString()), style: Theme.of(context).textTheme.bodyMedium),
        if (plan.description?.isNotEmpty == true) ...[
          SizedBox(height: AppSpacing.sm),
          Text(plan.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
        ],
        SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
          _FeaturePill(icon: Icons.extension_rounded, label: l10n.text('plan_features_count').replaceAll('{count}', (plan.planFeatures.isNotEmpty ? plan.planFeatures.length : plan.features.length).toString())),
          _FeaturePill(icon: Icons.percent_rounded, label: l10n.text('plan_discount_value').replaceAll('{value}', AmountFormatter.format(plan.discount))),
        ]),
        if (canEdit || canDelete) ...[
          SizedBox(height: AppSpacing.md), Divider(color: colors.outlineVariant),
          Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
            if (canEdit) CustomButton.text(text: l10n.text('edit'), size: AppButtonSize.small, onPressed: onEdit),
            if (canDelete) CustomButton.text(text: l10n.text(plan.isActive ? 'deactivate' : 'activate'), size: AppButtonSize.small, onPressed: onToggle),
            if (canDelete) CustomButton.danger(text: l10n.text('delete'), size: AppButtonSize.small, onPressed: onDelete),
          ]),
        ],
      ]),
    );
  }
}
class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(30)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14), SizedBox(width: AppSpacing.xs), Text(label, style: Theme.of(context).textTheme.labelSmall)]),
  );
}
