import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class ProviderSubscriptionCard extends StatelessWidget {
  const ProviderSubscriptionCard({required this.subscription, required this.l10n, required this.canEdit, required this.onExtend, super.key});
  final ProviderSubscriptionEntity subscription;
  final AppLocalizations l10n;
  final bool canEdit;
  final VoidCallback onExtend;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(16), border: Border.all(color: colors.outlineVariant.withValues(alpha: .65))),
      child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: colors.secondaryContainer, borderRadius: BorderRadius.circular(13)), child: Icon(Icons.router_rounded, color: colors.onSecondaryContainer)),
        SizedBox(width: AppSpacing.md),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(subscription.networkName ?? l10n.text('network_id_value').replaceAll('{id}', subscription.networkId.toString()), style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 3),
          Text(subscription.planName ?? l10n.text('plan_id_value').replaceAll('{id}', subscription.planId.toString()), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
          SizedBox(height: AppSpacing.xs),
          Text('${_date(subscription.startDate)}  →  ${_date(subscription.endDate)}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
        ])),
        CustomStatusBadge.fromPresentation(EnumPresentationRegistry.resolveProviderSubscriptionStatus(subscription.typedStatus, serverLabel: subscription.statusLabel), isCompact: true),
        if (canEdit) ...[SizedBox(width: AppSpacing.sm), CustomButton.text(text: l10n.text('extend'), size: AppButtonSize.small, onPressed: onExtend)],
      ]),
    );
  }
  String _date(DateTime? date) => date == null ? '—' : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
