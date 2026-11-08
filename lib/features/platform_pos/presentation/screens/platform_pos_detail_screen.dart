import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/controllers/platform_pos_detail_controller.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_detail_header.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_information_section.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

class PlatformPosDetailScreen extends GetView<PlatformPosDetailController> {
  const PlatformPosDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Obx(() {
        if (controller.isLoading.value) return const CustomSkeletonGrid(count: 4, crossAxisCount: 1, itemHeight: 100);
        final pos = controller.detail.value;
        if (pos == null) return CustomErrorState.boxed(title: l10n.text('pos_detail_load_error'), subtitle: controller.errorMessage.value, icon: Icons.cloud_off_rounded, retryLabel: l10n.text('retry'), onRetry: controller.load);
        final isPending = pos.status == 'PENDING';
        final canEdit = PermissionService.to.can(AppPermissions.posEdit);
        final canApprove = PermissionService.to.isSuperAdmin && canEdit;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          PlatformPosDetailHeader(pos: pos, l10n: l10n),
          SizedBox(height: AppSpacing.lg),
          DashboardPageHeader(data: DashboardPageHeaderData(
            title: l10n.text('pos_information'), description: l10n.text('pos_information_description'), icon: Icons.storefront_outlined,
            actions: [
              if (canEdit)
                CustomButton.secondary(
                  text: l10n.text('edit_pos'),
                  prefix: const Icon(Icons.edit_outlined, size: 18),
                  loading: controller.isSaving.value,
                  onPressed: controller.isSaving.value ? null : () => _edit(context, l10n, pos),
                ),
              if (canApprove && isPending) ...[
                CustomButton.primary(text: l10n.text('approve_pos'), prefix: const Icon(Icons.check_rounded, size: 18), loading: controller.isApproving.value, onPressed: controller.isApproving.value ? null : () => _approve(context, l10n)),
                CustomButton.danger(text: l10n.text('reject_pos'), prefix: const Icon(Icons.close_rounded, size: 18), loading: controller.isRejecting.value, onPressed: controller.isRejecting.value ? null : () => _reject(context, l10n)),
              ],
            ],
          )),
          SizedBox(height: AppSpacing.md),
          Expanded(child: SingleChildScrollView(child: PlatformPosInformationSection(pos: pos, l10n: l10n))),
        ]);
      }),
    );
  }

  Future<void> _edit(
    BuildContext context,
    AppLocalizations l10n,
    dynamic pos,
  ) async {
    final name = TextEditingController(text: pos.name as String);
    final email = TextEditingController(text: (pos.email as String?) ?? '');
    final address = TextEditingController(text: (pos.address as String?) ?? '');
    final confirmed = await CustomDialog.show(
      type: DialogType.custom,
      title: l10n.text('edit_pos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(controller: name, label: l10n.text('pos_name'), isRequired: true),
          SizedBox(height: AppSpacing.md),
          CustomTextField(controller: email, label: l10n.text('email'), keyboardType: TextInputType.emailAddress, isRequired: false),
          SizedBox(height: AppSpacing.md),
          CustomTextField(controller: address, label: l10n.text('pos_address'), isRequired: false),
        ],
      ),
      confirmLabel: l10n.text('save_changes'),
      cancelLabel: l10n.text('cancel'),
    );
    if (confirmed == true) {
      try {
        if (name.text.trim().isEmpty) throw Exception(l10n.text('pos_name_required'));
        await controller.save(name: name.text, email: email.text, address: address.text);
        CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('pos_updated'), type: SnackType.success);
      } catch (error) {
        CustomSnackbar.show(title: l10n.text('error'), message: error.toString(), type: SnackType.error);
      }
    }
    name.dispose();
    email.dispose();
    address.dispose();
  }

  Future<void> _approve(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await CustomDialog.showConfirmation(title: l10n.text('approve_pos'), message: l10n.text('approve_pos_confirmation'), confirmLabel: l10n.text('approve'), cancelLabel: l10n.text('cancel'));
    if (confirmed != true) return;
    try {
      await controller.approve();
      CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('pos_approved'), type: SnackType.success);
    } catch (error) {
      CustomSnackbar.show(title: l10n.text('error'), message: error.toString(), type: SnackType.error);
    }
  }

  Future<void> _reject(BuildContext context, AppLocalizations l10n) async {
    final reason = TextEditingController();
    final confirmed = await CustomDialog.show(type: DialogType.custom, title: l10n.text('reject_pos'),
      content: CustomTextField(controller: reason, label: l10n.text('rejection_reason'), hint: l10n.text('rejection_reason_hint'), maxLines: 3, isRequired: true),
      confirmLabel: l10n.text('reject'), cancelLabel: l10n.text('cancel'));
    if (confirmed == true) {
      try {
        if (reason.text.trim().length < 3) throw Exception(l10n.text('rejection_reason_required'));
        await controller.reject(reason.text);
        CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('pos_rejected'), type: SnackType.success);
      } catch (error) {
        CustomSnackbar.show(title: l10n.text('error'), message: error.toString(), type: SnackType.error);
      }
    }
    reason.dispose();
  }
}
