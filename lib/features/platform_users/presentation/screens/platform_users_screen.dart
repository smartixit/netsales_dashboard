import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_users_filter_bar.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_users_list.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_user_form_sheet.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformUsersScreen extends GetView<PlatformUsersController> {
  const PlatformUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardPageHeader(
            data: DashboardPageHeaderData(
              title: l10n.text('users'),
              description: l10n.text('platform_users_description'),
              icon: Icons.manage_accounts_rounded,
              actions: [
                Obx(() => CustomButton.secondary(
                  text: controller.isTrashView.value ? l10n.text('users_back_to_list') : l10n.text('users_trash'),
                  prefix: Icon(controller.isTrashView.value ? Icons.people_alt_outlined : Icons.delete_sweep_outlined, size: 18),
                  onPressed: controller.toggleTrashView,
                )),
                if (PermissionService.to.can(AppPermissions.usersCreate))
                  Obx(() => controller.isTrashView.value
                      ? const SizedBox.shrink()
                      : CustomButton.primary(
                          text: l10n.text('create_platform_user'),
                          prefix: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                          onPressed: () async {
                            final saved = await showPlatformUserForm(l10n: l10n);
                            if (saved == true) await controller.loadUsers();
                          },
                        )),
                CustomButton.secondary(
                  text: l10n.text('refresh'),
                  prefix: const Icon(Icons.refresh_rounded, size: 18),
                  onPressed: controller.loadUsers,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Obx(() => controller.isTrashView.value
              ? const SizedBox.shrink()
              : PlatformUsersFilterBar(controller: controller, l10n: l10n)),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              switch (controller.viewState.value) {
                case AppDataGridViewState.loading:
                  return const CustomSkeletonGrid(
                    count: 6,
                    crossAxisCount: 1,
                    itemHeight: 84,
                  );
                case AppDataGridViewState.error:
                  return CustomErrorState.boxed(
                    title: l10n.text('users_load_error'),
                    subtitle: controller.errorMessage.value,
                    icon: Icons.cloud_off_rounded,
                    onRetry: controller.loadUsers,
                    retryLabel: l10n.text('refresh'),
                  );
                case AppDataGridViewState.empty:
                  return CustomEmptyState.boxed(
                    title: l10n.text('users_empty'),
                    subtitle: l10n.text('users_empty_description'),
                    icon: Icons.group_outlined,
                    badgeText: l10n.text('users'),
                  );
                case AppDataGridViewState.noResults:
                  return CustomEmptyState.search(
                    query: controller.searchQuery.value,
                    onClearSearch: () {
                      controller.searchController.clear();
                      controller.onSearchChanged('');
                    },
                  );
                case AppDataGridViewState.success:
                  return PlatformUsersList(controller: controller, l10n: l10n);
              }
            }),
          ),
        ],
      ),
    );
  }
}
