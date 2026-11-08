import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformNetworkPosLinkDetailPanel extends StatelessWidget {
  const PlatformNetworkPosLinkDetailPanel({
    required this.link,
    required this.l10n,
    super.key,
  });

  final PlatformNetworkPosLinkEntity link;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              l10n.text('network_pos_relationship'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          CustomStatusBadge.fromPresentation(
            EnumPresentationRegistry.resolveLinkStatus(link.isActive),
          ),
        ],
      ),
      SizedBox(height: AppSpacing.sm),
      Text(
        '${l10n.text('link_reference')}: #${link.id}',
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      if (link.createdAt != null) ...[
        SizedBox(height: AppSpacing.xs),
        Text(
          '${l10n.text('created_at')}: ${link.createdAt!.toLocal()}',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
      SizedBox(height: AppSpacing.lg),
      Row(
        children: [
          CustomCachedImage.logo(
            url: link.networkLogo,
            size: 58,
            fallback: const Icon(Icons.router_outlined),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.text('network_name'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  link.networkName ?? '—',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  link.networkUuid ?? 'ID #${link.networkId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: Icon(
            Icons.link_rounded,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      Row(
        children: [
          CustomCachedImage.logo(
            url: link.posLogo,
            size: 58,
            fallback: const Icon(Icons.storefront_outlined),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.text('pos_name'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  link.posName ?? '—',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  link.posPhoneNumber ?? link.posUuid ?? '—',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
