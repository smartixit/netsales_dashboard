import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/enums/request_status.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/utils/amount_formatter.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class SubscriptionRequestCard extends StatelessWidget {
  const SubscriptionRequestCard({required this.request, required this.l10n, required this.canReview, required this.onApprove, required this.onReject, super.key});
  final SubscriptionRequestEntity request;
  final AppLocalizations l10n;
  final bool canReview;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final pending = request.typedStatus == RequestStatus.pending;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(16), border: Border.all(color: colors.outlineVariant.withValues(alpha: .65))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(request.networkName ?? l10n.text('network_id_value').replaceAll('{id}', request.networkId.toString()), style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 3),
            Text(request.planName ?? l10n.text('plan_id_value').replaceAll('{id}', request.planId.toString()), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
          ])),
          CustomStatusBadge.fromPresentation(EnumPresentationRegistry.resolveRequestStatus(request.typedStatus, serverLabel: request.statusLabel), isCompact: true),
        ]),
        SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.lg, runSpacing: AppSpacing.sm, children: [
          _Meta(icon: Icons.payments_outlined, text: '${AmountFormatter.format(request.totalAmount)} · ${request.paymentTypeLabel ?? request.paymentType}'),
          if (request.transactionReference?.isNotEmpty == true) _Meta(icon: Icons.tag_rounded, text: request.transactionReference!),
          _Meta(icon: Icons.calendar_today_outlined, text: _date(request.createdAt)),
        ]),
        if (request.rejectionReason?.isNotEmpty == true) ...[
          SizedBox(height: AppSpacing.sm),
          Text('${l10n.text('rejection_reason')}: ${request.rejectionReason}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.error)),
        ],
        if (canReview && pending) ...[
          SizedBox(height: AppSpacing.md), Divider(color: colors.outlineVariant),
          Wrap(spacing: AppSpacing.sm, children: [
            CustomButton.secondary(text: l10n.text('approve_request'), size: AppButtonSize.small, prefix: const Icon(Icons.check_rounded, size: 16), onPressed: onApprove),
            CustomButton.text(text: l10n.text('reject_request'), size: AppButtonSize.small, variant: AppButtonVariant.danger, onPressed: onReject),
          ]),
        ],
      ]),
    );
  }
  String _date(DateTime? value) => value == null ? '—' : '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 15, color: Theme.of(context).colorScheme.onSurfaceVariant), SizedBox(width: AppSpacing.xs), Text(text, style: Theme.of(context).textTheme.bodySmall)]);
}
