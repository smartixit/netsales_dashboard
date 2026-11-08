import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_activity_timeline.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';
import 'package:netsales_dashboard/widgets/data_grid/app_data_grid.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_card.dart';

class PlatformRecentActivitySection extends StatelessWidget {
  const PlatformRecentActivitySection({super.key, required this.controller});
  final PlatformDashboardController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final loading = controller.isLoadingActivity.value;
      final failed = controller.hasActivityError.value;
      final source = controller.activityGridSource.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSectionHeader(
            title: l10n.text('recent_activity'),
            description: l10n.text('recent_activity'),
          ),
          AppSpacing.vMd,
          if (loading)
            const CustomSkeletonCard(height: 220)
          else if (failed)
            CustomErrorState(
              title: l10n.text('network_error'),
              subtitle: l10n.text('network_error'),
              retryLabel: l10n.text('refresh'),
              onRetry: controller.loadActivity,
              type: ErrorStateType.connection,
              variant: ErrorStateVariant.boxed,
            )
          else
            CustomActivityTimeline(
              items: controller.activityItems,
              emptyTitle: l10n.text('no_activity'),
              emptyMessage: l10n.text('no_activity'),
            ),
          AppSpacing.vXl,
          CustomSectionHeader(
            title: l10n.text('audit_logs'),
            description: l10n.text('recent_activity'),
          ),
          AppSpacing.vMd,
          if (loading)
            const CustomSkeletonCard(height: 320)
          else if (failed)
            CustomErrorState(
              title: l10n.text('network_error'),
              subtitle: l10n.text('network_error'),
              retryLabel: l10n.text('refresh'),
              onRetry: controller.loadActivity,
              type: ErrorStateType.connection,
              variant: ErrorStateVariant.boxed,
            )
          else if (source == null || source.items.isEmpty)
            CustomEmptyState.compact(
              title: l10n.text('no_activity'),
              subtitle: l10n.text('no_activity'),
              icon: Icons.history_toggle_off_rounded,
            )
          else
            SizedBox(
              height: 340,
              child: AppDataGrid<PlatformActivityEntity>(
                source: source,
                title: l10n.text('audit_logs'),
                subtitle: l10n.text('recent_activity'),
                emptyTitle: l10n.text('no_activity'),
                emptyMessage: l10n.text('no_activity'),
              ),
            ),
          AppSpacing.vXl,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CustomButton.text(
              text: l10n.text('refresh'),
              prefix: const Icon(Icons.refresh_rounded, size: 18),
              onPressed: controller.loadActivity,
            ),
          ),
        ],
      );
    });
  }
}
