import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_consumption_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class ProviderSubscriptionCard extends StatelessWidget {
  const ProviderSubscriptionCard({
    required this.subscription,
    required this.l10n,
    required this.canEdit,
    required this.consumptions,
    required this.isLoadingConsumptions,
    required this.onExpand,
    required this.onExtend,
    required this.onActivateQueued,
    super.key,
  });

  final ProviderSubscriptionEntity subscription;
  final AppLocalizations l10n;
  final bool canEdit;
  final List<SubscriptionFeatureConsumptionEntity>? consumptions;
  final bool isLoadingConsumptions;
  final ValueChanged<bool> onExpand;
  final VoidCallback onExtend;
  final VoidCallback onActivateQueued;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .65)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          childrenPadding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          onExpansionChanged: onExpand,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: colors.secondaryContainer, borderRadius: BorderRadius.circular(13)),
            child: Icon(Icons.router_rounded, color: colors.onSecondaryContainer),
          ),
          title: Text(
            subscription.networkName ?? l10n.text('network_id_value').replaceAll('{id}', subscription.networkId.toString()),
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(subscription.planName ?? l10n.text('plan_id_value').replaceAll('{id}', subscription.planId.toString()), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
              SizedBox(height: AppSpacing.xs),
              Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
                CustomStatusBadge.fromPresentation(EnumPresentationRegistry.resolveProviderSubscriptionStatus(subscription.typedStatus, serverLabel: subscription.statusLabel), isCompact: true),
                Text('${_date(subscription.startDate)}  →  ${_date(subscription.endDate)}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
              ]),
            ]),
          ),
          trailing: const Icon(Icons.expand_more_rounded),
          children: [
            Divider(color: colors.outlineVariant),
            Row(children: [
              Expanded(child: Text(l10n.text('subscription_feature_consumption'), style: Theme.of(context).textTheme.titleSmall)),
              if (canEdit && subscription.status == 'QUEUED')
                CustomButton.secondary(text: l10n.text('activate_queued_subscription'), size: AppButtonSize.small, onPressed: onActivateQueued),
              if (canEdit)
                CustomButton.text(text: l10n.text('extend'), size: AppButtonSize.small, onPressed: onExtend),
            ]),
            SizedBox(height: AppSpacing.sm),
            if (isLoadingConsumptions)
              const LinearProgressIndicator(minHeight: 2)
            else if (consumptions == null)
              Text(l10n.text('expand_to_load_consumption'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant))
            else if (consumptions!.isEmpty)
              Text(l10n.text('no_feature_consumption'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant))
            else
              ...consumptions!.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(children: [
                  Expanded(child: Text(item.featureName ?? l10n.text('feature_id_value').replaceAll('{id}', item.featureId.toString()), style: Theme.of(context).textTheme.bodySmall)),
                  Text(
                    '${item.consumedValue} / ${item.limitValue == '-1' ? l10n.text('unlimited') : (item.limitValue ?? '—')}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ]),
              )),
          ],
        ),
      ),
    );
  }

  String _date(DateTime? date) => date == null ? '—' : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
