import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformNetworkDetailHeader extends StatelessWidget {
  const PlatformNetworkDetailHeader({
    required this.network,
    required this.l10n,
    super.key,
  });

  final PlatformNetworkEntity network;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 680;
      final identity = Row(
        children: [
          CustomCachedImage.avatar(
            url: network.logo,
            radius: compact ? 25 : 30,
            fallbackText: network.name.isEmpty
                ? '?'
                : network.name.characters.first,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  network.name,
                  style: AppTypography.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  network.uuid ?? 'ID #${network.id}',
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                PlatformNetworkStatusBadge(
                  status: network.status,
                  statusLabel: network.statusLabel,
                  compact: false,
                ),
              ],
            ),
          ),
        ],
      );
      final back = CustomButton.secondary(
        text: l10n.text('back_to_networks'),
        prefix: const Icon(Icons.arrow_back_rounded, size: 18),
        onPressed: () => Get.offNamed<void>(AppRoutes.networks),
      );
      return compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                back,
                SizedBox(height: AppSpacing.md),
                identity,
              ],
            )
          : Row(
              children: [
                Expanded(child: identity),
                SizedBox(width: AppSpacing.md),
                back,
              ],
            );
    },
  );
}
