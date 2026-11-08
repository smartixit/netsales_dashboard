import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformNetworkPosLinkCard extends StatelessWidget {
  const PlatformNetworkPosLinkCard({
    required this.item,
    required this.l10n,
    super.key,
  });

  final PlatformNetworkPosLinkEntity item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CustomCachedImage.logo(
              url: item.networkLogo,
              size: 42,
              fallback: const Icon(Icons.router_outlined),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                item.networkName ?? '—',
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CustomStatusBadge.fromPresentation(
              EnumPresentationRegistry.resolveLinkStatus(item.isActive),
              isCompact: true,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.link_rounded, size: 18),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.posName ?? '—',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        CustomButton.text(
          text: l10n.text('view_details'),
          onPressed: () => Get.toNamed<void>(
            AppRoutes.networkPosLinkDetail(item.id),
          ),
        ),
      ],
    ),
  );
}
