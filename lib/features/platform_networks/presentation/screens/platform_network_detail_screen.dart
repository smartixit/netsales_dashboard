import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/controllers/platform_network_detail_controller.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_detail_header.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_information_section.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';
import 'package:netsales_dashboard/widgets/platform_workspace/platform_workspace.dart';

class PlatformNetworkDetailScreen
    extends GetView<PlatformNetworkDetailController> {
  const PlatformNetworkDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PlatformWorkspaceFrame(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const CustomSkeletonGrid(
            count: 4,
            crossAxisCount: 1,
            itemHeight: 100,
          );
        }
        final network = controller.network.value;
        if (network == null) {
          return CustomErrorState.boxed(
            title: l10n.text('network_detail_load_error'),
            subtitle: controller.errorMessage.value,
            icon: Icons.cloud_off_rounded,
            retryLabel: l10n.text('retry'),
            onRetry: controller.load,
          );
        }

        final canEdit = PermissionService.to.can(AppPermissions.networksEdit);
        final canApprove = PermissionService.to.can(
          AppPermissions.networksApprove,
        );
        final canReject = PermissionService.to.can(
          AppPermissions.networksReject,
        );
        final isPending = network.status == 'PENDING';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlatformNetworkDetailHeader(network: network, l10n: l10n),
            SizedBox(height: AppSpacing.lg),
            DashboardPageHeader(
              data: DashboardPageHeaderData(
                title: l10n.text('network_information'),
                description: l10n.text('network_information_description'),
                icon: Icons.hub_outlined,
                actions: [
                  if (canEdit)
                    CustomButton.secondary(
                      text: l10n.text('edit_network'),
                      prefix: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () => _edit(
                        context,
                        l10n,
                        network.name,
                        network.address ?? '',
                      ),
                    ),
                  if (canApprove && isPending)
                    CustomButton.primary(
                      text: l10n.text('approve_network'),
                      prefix: const Icon(Icons.check_rounded, size: 18),
                      loading: controller.isApproving.value,
                      onPressed: controller.isApproving.value
                          ? null
                          : () => _approve(context, l10n),
                    ),
                  if (canReject && isPending)
                    CustomButton.danger(
                      text: l10n.text('reject_network'),
                      prefix: const Icon(Icons.close_rounded, size: 18),
                      loading: controller.isRejecting.value,
                      onPressed: controller.isRejecting.value
                          ? null
                          : () => _reject(context, l10n),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                child: PlatformNetworkInformationSection(
                  network: network,
                  l10n: l10n,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _edit(
    BuildContext context,
    AppLocalizations l10n,
    String currentName,
    String currentAddress,
  ) async {
    final name = TextEditingController(text: currentName);
    final address = TextEditingController(text: currentAddress);
    final confirmed = await CustomDialog.show(
      type: DialogType.custom,
      title: l10n.text('edit_network'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: name,
            label: l10n.text('network_name'),
            isRequired: true,
          ),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: address,
            label: l10n.text('network_address'),
            isRequired: false,
          ),
        ],
      ),
      confirmLabel: l10n.text('save_changes'),
      cancelLabel: l10n.text('cancel'),
    );
    if (confirmed == true) {
      try {
        if (name.text.trim().isEmpty) {
          throw Exception(l10n.text('network_name_required'));
        }
        await controller.save(name: name.text, address: address.text);
        CustomSnackbar.show(
          title: l10n.text('success'),
          message: l10n.text('network_updated'),
          type: SnackType.success,
        );
      } catch (error) {
        CustomSnackbar.show(
          title: l10n.text('error'),
          message: error.toString(),
          type: SnackType.error,
        );
      }
    }
    name.dispose();
    address.dispose();
  }

  Future<void> _approve(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await CustomDialog.showConfirmation(
      title: l10n.text('approve_network'),
      message: l10n.text('approve_network_confirmation'),
      confirmLabel: l10n.text('approve'),
      cancelLabel: l10n.text('cancel'),
    );
    if (confirmed != true) return;
    try {
      await controller.approve();
      CustomSnackbar.show(
        title: l10n.text('success'),
        message: l10n.text('network_approved'),
        type: SnackType.success,
      );
    } catch (error) {
      CustomSnackbar.show(
        title: l10n.text('error'),
        message: error.toString(),
        type: SnackType.error,
      );
    }
  }

  Future<void> _reject(BuildContext context, AppLocalizations l10n) async {
    final reason = TextEditingController();
    final confirmed = await CustomDialog.show(
      type: DialogType.custom,
      title: l10n.text('reject_network'),
      content: CustomTextField(
        controller: reason,
        label: l10n.text('rejection_reason'),
        hint: l10n.text('rejection_reason_hint'),
        maxLines: 3,
        isRequired: true,
      ),
      confirmLabel: l10n.text('reject'),
      cancelLabel: l10n.text('cancel'),
    );
    if (confirmed == true) {
      try {
        if (reason.text.trim().length < 3) {
          throw Exception(l10n.text('rejection_reason_required'));
        }
        await controller.reject(reason.text);
        CustomSnackbar.show(
          title: l10n.text('success'),
          message: l10n.text('network_rejected'),
          type: SnackType.success,
        );
      } catch (error) {
        CustomSnackbar.show(
          title: l10n.text('error'),
          message: error.toString(),
          type: SnackType.error,
        );
      }
    }
    reason.dispose();
  }
}
