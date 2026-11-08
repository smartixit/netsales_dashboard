import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/controllers/platform_network_pos_link_detail_controller.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/widgets/platform_network_pos_link_detail_panel.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';

class PlatformNetworkPosLinkDetailScreen
    extends GetView<PlatformNetworkPosLinkDetailController> {
  const PlatformNetworkPosLinkDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canEdit = PermissionService.to.isSuperAdmin;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Obx(() {
        final link = controller.link.value;
        if (controller.isLoading.value) {
          return const CustomSkeletonGrid(count: 3);
        }
        if (link == null) {
          return CustomErrorState.boxed(
            title: l10n.text('network_pos_link_detail_error'),
            subtitle: controller.errorMessage.value,
            icon: Icons.link_off_rounded,
            retryLabel: l10n.text('refresh'),
            onRetry: controller.load,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardPageHeader(
              data: DashboardPageHeaderData(
                title: l10n.text('network_pos_relationship'),
                description: l10n.text('network_pos_link_detail_description'),
                icon: Icons.hub_outlined,
                actions: [
                  CustomButton.secondary(
                    text: l10n.text('back'),
                    onPressed: () => Get.back<void>(),
                  ),
                  if (canEdit)
                    CustomButton.outline(
                      text: link.isActive
                          ? l10n.text('deactivate_link')
                          : l10n.text('activate_link'),
                      loading: controller.isMutating.value,
                      onPressed: controller.isMutating.value
                          ? null
                          : () => _toggle(l10n, link.isActive),
                    ),
                  if (canEdit)
                    CustomButton.danger(
                      text: l10n.text('unlink_network_pos'),
                      loading: controller.isMutating.value,
                      onPressed: controller.isMutating.value
                          ? null
                          : () => _unlink(l10n),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 880),
                    child: PlatformNetworkPosLinkDetailPanel(
                      link: link,
                      l10n: l10n,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _toggle(AppLocalizations l10n, bool active) async {
    final accepted = await CustomDialog.confirmation(
      title: l10n.text(active ? 'deactivate_link' : 'activate_link'),
      message: l10n.text(
        active ? 'deactivate_link_confirmation' : 'activate_link_confirmation',
      ),
      confirmLabel: l10n.text('confirm'),
      cancelLabel: l10n.text('cancel'),
      onConfirm: () => Get.back<bool>(result: true),
    ).showDialog();
    if (accepted != true) return;
    await _runMutation(
      l10n,
      () => controller.setStatus(!active),
      l10n.text('network_pos_link_status_updated'),
    );
  }

  Future<void> _unlink(AppLocalizations l10n) async {
    final accepted = await CustomDialog.danger(
      title: l10n.text('unlink_network_pos'),
      message: l10n.text('unlink_network_pos_confirmation'),
      confirmLabel: l10n.text('unlink_network_pos'),
      cancelLabel: l10n.text('cancel'),
      onConfirm: () => Get.back<bool>(result: true),
    ).showDialog();
    if (accepted != true) return;
    final removed = await _runMutation(
      l10n,
      controller.unlink,
      l10n.text('network_pos_link_removed'),
    );
    if (removed) await Get.offNamed<void>(AppRoutes.networkPosLinks);
  }

  Future<bool> _runMutation(
    AppLocalizations l10n,
    Future<void> Function() action,
    String success,
  ) async {
    try {
      await CustomAnimationOverlay.showLoading(message: l10n.text('saving'));
      await action();
      if (CustomAnimationOverlay.isShowing) await CustomAnimationOverlay.hide();
      await CustomAnimationOverlay.showSuccess(message: success);
      return true;
    } catch (error) {
      if (CustomAnimationOverlay.isShowing) await CustomAnimationOverlay.hide();
      CustomSnackbar.show(
        title: l10n.text('error'),
        message: error.toString(),
        type: SnackType.error,
      );
      return false;
    }
  }
}
