import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class PlatformUserDetailHeader extends StatelessWidget {
  const PlatformUserDetailHeader({super.key, required this.user, required this.l10n});
  final PlatformUserEntity user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CustomButton.secondary(
        text: l10n.text('back_to_users'),
        prefix: const Icon(Icons.arrow_back_rounded, size: 18),
        onPressed: () => Get.offNamed(AppRoutes.users),
      ),
      SizedBox(width: AppSpacing.md),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.text('user_details'), style: AppTypography.titleLarge),
          Text(user.fullName, style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
        ],
      )),
    ],
  );
}
