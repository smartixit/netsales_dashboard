import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_users_filter_bar.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_users_list.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformUsersScreen extends GetView<PlatformUsersController> {
  const PlatformUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.text('users'), style: AppTypography.headlineSmall),
          SizedBox(height: AppSpacing.xs),
          Text(l10n.text('platform_users_description'), style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant)),
        ]),
        SizedBox(height: AppSpacing.lg),
        PlatformUsersFilterBar(controller: controller, l10n: l10n),
        SizedBox(height: AppSpacing.md),
        Expanded(child: Obx(() {
          switch (controller.viewState.value) {
            case AppDataGridViewState.loading:
              return const Center(child: CircularProgressIndicator.adaptive());
            case AppDataGridViewState.error:
              return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(controller.errorMessage.value),
                SizedBox(height: AppSpacing.md),
                CustomButton.secondary(text: l10n.text('refresh'), prefix: const Icon(Icons.refresh_rounded, size: 18), onPressed: controller.loadUsers),
              ]));
            case AppDataGridViewState.empty:
              return Center(child: Text(l10n.text('users_empty'), style: AppTypography.bodyLarge.copyWith(color: context.colors.onSurfaceVariant)));
            case AppDataGridViewState.noResults:
              return Center(child: Text(l10n.text('no_results')));
            case AppDataGridViewState.success:
              return PlatformUsersList(controller: controller, l10n: l10n);
          }
        })),
      ]),
    );
  }
}
