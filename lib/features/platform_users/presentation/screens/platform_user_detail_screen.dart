import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_user_detail_controller.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_user_detail_header.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_user_form_sheet.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_user_identity_panel.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_user_information_section.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/widgets/platform_user_security_section.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';

class PlatformUserDetailScreen extends GetView<PlatformUserDetailController> {
  const PlatformUserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const CustomSkeletonGrid(count: 4, crossAxisCount: 1, itemHeight: 112);
        }
        final detail = controller.detail.value;
        if (detail == null) {
          return CustomErrorState.boxed(
            title: l10n.text('user_detail_load_error'),
            subtitle: controller.errorMessage.value,
            retryLabel: l10n.text('refresh'),
            onRetry: controller.load,
            icon: Icons.person_off_outlined,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlatformUserDetailHeader(
              user: detail.user,
              l10n: l10n,
              isActive: detail.user.status == 'ACTIVE',
              isStatusUpdating: controller.isStatusUpdating.value,
              onToggleStatus: controller.canChangeStatus ? controller.changeStatus : null,
              onEdit: controller.canEditUser
                  ? () async {
                      final saved = await showPlatformUserForm(l10n: l10n, detail: detail);
                      if (saved == true) await controller.load();
                    }
                  : null,
            ),
            SizedBox(height: AppSpacing.lg),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PlatformUserIdentityPanel(detail: detail, l10n: l10n),
                    SizedBox(height: AppSpacing.lg),
                    PlatformUserInformationSection(detail: detail, l10n: l10n),
                    if (controller.canViewSecurity) ...[
                      SizedBox(height: AppSpacing.lg),
                      PlatformUserSecuritySection(
                        detail: detail,
                        sessions: controller.sessions,
                        isLoading: controller.isSessionsLoading.value,
                        error: controller.sessionsError.value,
                        onRetry: controller.loadSessions,
                        l10n: l10n,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
