import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformPosDetailHeader extends StatelessWidget {
  const PlatformPosDetailHeader({required this.pos, required this.l10n, super.key});
  final PlatformPosEntity pos;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final compact = constraints.maxWidth < 680;
    final identity = Row(children: [
      CustomCachedImage.avatar(url: pos.logo, radius: compact ? 25 : 30, fallbackText: pos.name.isEmpty ? '?' : pos.name.characters.first),
      SizedBox(width: AppSpacing.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(pos.name, style: AppTypography.headlineSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(pos.uuid ?? 'ID #${pos.id}', style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
        SizedBox(height: AppSpacing.xs),
        PlatformPosStatusBadge(status: pos.status, statusLabel: pos.statusLabel, compact: false),
      ])),
    ]);
    final back = CustomButton.secondary(text: l10n.text('back_to_pos'), prefix: const Icon(Icons.arrow_back_rounded, size: 18), onPressed: () => Get.offNamed<void>(AppRoutes.pos));
    return compact
      ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [back, SizedBox(height: AppSpacing.md), identity])
      : Row(children: [Expanded(child: identity), SizedBox(width: AppSpacing.md), back]);
  });
}
