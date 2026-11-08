import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/presentation/controllers/platform_subscriptions_controller.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/presentation/widgets/provider_subscription_card.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/presentation/widgets/subscription_plan_card.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/presentation/widgets/subscription_request_card.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

enum SubscriptionWorkspaceSection { plans, subscriptions, requests }

class PlatformSubscriptionsScreen extends GetView<PlatformSubscriptionsController> {
  const PlatformSubscriptionsScreen({required this.section, super.key});
  final SubscriptionWorkspaceSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canCreate = PermissionService.to.can(AppPermissions.subscriptionsCreate);
    final canEdit = PermissionService.to.can(AppPermissions.subscriptionsEdit);
    final canDelete = PermissionService.to.can(AppPermissions.subscriptionsDelete);
    final canApprove = PermissionService.to.can(AppPermissions.subscriptionsApprove);
    final canReject = PermissionService.to.can(AppPermissions.subscriptionsReject);
    final title = switch (section) {
      SubscriptionWorkspaceSection.plans => l10n.text('subscription_plans'),
      SubscriptionWorkspaceSection.subscriptions => l10n.text('provider_subscriptions'),
      SubscriptionWorkspaceSection.requests => l10n.text('subscription_requests'),
    };
    final description = switch (section) {
      SubscriptionWorkspaceSection.plans => l10n.text('subscription_plans_description'),
      SubscriptionWorkspaceSection.subscriptions => l10n.text('provider_subscriptions_description'),
      SubscriptionWorkspaceSection.requests => l10n.text('subscription_requests_description'),
    };
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        DashboardPageHeader(data: DashboardPageHeaderData(
          title: title,
          description: description,
          icon: switch (section) {
            SubscriptionWorkspaceSection.plans => Icons.sell_outlined,
            SubscriptionWorkspaceSection.subscriptions => Icons.card_membership_outlined,
            SubscriptionWorkspaceSection.requests => Icons.assignment_outlined,
          },
          actions: [
            Obx(() => CustomButton.secondary(
              text: l10n.text('refresh'),
              prefix: const Icon(Icons.refresh_rounded, size: 18),
              loading: _loading,
              onPressed: _loading ? null : _refresh,
            )),
            if (section == SubscriptionWorkspaceSection.plans && canCreate)
              CustomButton.primary(text: l10n.text('create_subscription_plan'), prefix: const Icon(Icons.add_rounded, size: 18), onPressed: () => _showPlanForm(context, l10n)),
          ],
        )),
        SizedBox(height: AppSpacing.lg),
        _SectionSwitcher(section: section, l10n: l10n),
        SizedBox(height: AppSpacing.md),
        _buildFilters(l10n),
        SizedBox(height: AppSpacing.md),
        Expanded(child: _buildContent(context, l10n, canEdit, canDelete, canApprove, canReject)),
      ]),
    );
  }

  bool get _loading => switch (section) {
    SubscriptionWorkspaceSection.plans => controller.plansLoading.value,
    SubscriptionWorkspaceSection.subscriptions => controller.subscriptionsLoading.value,
    SubscriptionWorkspaceSection.requests => controller.requestsLoading.value,
  };

  Future<void> _refresh() {
    return switch (section) {
      SubscriptionWorkspaceSection.plans => controller.loadPlans(),
      SubscriptionWorkspaceSection.subscriptions => controller.loadSubscriptions(),
      SubscriptionWorkspaceSection.requests => controller.loadRequests(),
    };
  }

  Widget _buildFilters(AppLocalizations l10n) => LayoutBuilder(builder: (context, constraints) {
    final search = switch (section) {
      SubscriptionWorkspaceSection.plans => CustomTextField(controller: controller.planSearchController, label: l10n.text('search_subscription_plans'), prefixIcon: const Icon(Icons.search_rounded), isRequired: false, onChanged: controller.onPlanSearchChanged),
      SubscriptionWorkspaceSection.subscriptions => CustomTextField(controller: controller.subscriptionSearchController, label: l10n.text('search_provider_subscriptions'), prefixIcon: const Icon(Icons.search_rounded), isRequired: false, onChanged: controller.onSubscriptionSearchChanged),
      SubscriptionWorkspaceSection.requests => CustomTextField(controller: controller.requestSearchController, label: l10n.text('search_subscription_requests'), prefixIcon: const Icon(Icons.search_rounded), isRequired: false, onChanged: controller.onRequestSearchChanged),
    };
    final chips = switch (section) {
      SubscriptionWorkspaceSection.plans => Obx(() => _filters([
        _FilterChip(label: l10n.text('all'), selected: controller.planStatus.value.isEmpty, onTap: () { controller.planStatus.value = ''; controller.loadPlans(); }),
        _FilterChip(label: l10n.text('active'), selected: controller.planStatus.value == '1', onTap: () { controller.planStatus.value = '1'; controller.loadPlans(); }),
        _FilterChip(label: l10n.text('inactive'), selected: controller.planStatus.value == '0', onTap: () { controller.planStatus.value = '0'; controller.loadPlans(); }),
      ])),
      SubscriptionWorkspaceSection.subscriptions => Obx(() => _filters([
        _FilterChip(label: l10n.text('all'), selected: controller.subscriptionStatus.value.isEmpty, onTap: () { controller.subscriptionStatus.value = ''; controller.loadSubscriptions(); }),
        _FilterChip(label: l10n.text('active'), selected: controller.subscriptionStatus.value == 'ACTIVE', onTap: () { controller.subscriptionStatus.value = 'ACTIVE'; controller.loadSubscriptions(); }),
        _FilterChip(label: l10n.text('queued'), selected: controller.subscriptionStatus.value == 'QUEUED', onTap: () { controller.subscriptionStatus.value = 'QUEUED'; controller.loadSubscriptions(); }),
        _FilterChip(label: l10n.text('expired'), selected: controller.subscriptionStatus.value == 'EXPIRED', onTap: () { controller.subscriptionStatus.value = 'EXPIRED'; controller.loadSubscriptions(); }),
        _FilterChip(label: l10n.text('suspended'), selected: controller.subscriptionStatus.value == 'SUSPENDED', onTap: () { controller.subscriptionStatus.value = 'SUSPENDED'; controller.loadSubscriptions(); }),
      ])),
      SubscriptionWorkspaceSection.requests => Obx(() => _filters([
        _FilterChip(label: l10n.text('pending'), selected: controller.requestStatus.value == 'PENDING', onTap: () { controller.requestStatus.value = 'PENDING'; controller.loadRequests(); }),
        _FilterChip(label: l10n.text('approved'), selected: controller.requestStatus.value == 'APPROVED', onTap: () { controller.requestStatus.value = 'APPROVED'; controller.loadRequests(); }),
        _FilterChip(label: l10n.text('rejected'), selected: controller.requestStatus.value == 'REJECTED', onTap: () { controller.requestStatus.value = 'REJECTED'; controller.loadRequests(); }),
        _FilterChip(label: l10n.text('all'), selected: controller.requestStatus.value.isEmpty, onTap: () { controller.requestStatus.value = ''; controller.loadRequests(); }),
      ])),
    };
    return constraints.maxWidth > 900
      ? Row(children: [SizedBox(width: 340, child: search), SizedBox(width: AppSpacing.md), Expanded(child: chips)])
      : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [search, SizedBox(height: AppSpacing.sm), chips]);
  });

  Widget _filters(List<Widget> children) => Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: children);

  Widget _buildContent(BuildContext context, AppLocalizations l10n, bool canEdit, bool canDelete, bool canApprove, bool canReject) {
    return switch (section) {
      SubscriptionWorkspaceSection.plans => Obx(() {
        if (controller.plansLoading.value && controller.plans.isEmpty) return const CustomSkeletonGrid(count: 6, crossAxisCount: 3, itemHeight: 220);
        if (controller.plansError.value.isNotEmpty && controller.plans.isEmpty) return CustomErrorState.boxed(title: l10n.text('subscription_plans_load_error'), subtitle: controller.plansError.value, icon: Icons.cloud_off_rounded, retryLabel: l10n.text('refresh'), onRetry: controller.loadPlans);
        if (controller.plans.isEmpty) return CustomEmptyState.boxed(title: l10n.text('subscription_plans_empty'), subtitle: l10n.text('subscription_plans_empty_description'), icon: Icons.sell_outlined, badgeText: l10n.text('subscription_plans'));
        return LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1250 ? 3 : constraints.maxWidth >= 780 ? 2 : 1;
          return GridView.builder(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: AppSpacing.md, mainAxisSpacing: AppSpacing.md, mainAxisExtent: 270),
            itemCount: controller.plans.length + (controller.hasMorePlans ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.plans.length) return Center(child: CustomButton.outline(text: l10n.text('load_more'), loading: controller.plansLoading.value, onPressed: controller.plansLoading.value ? null : () => controller.loadPlans(append: true)));
              final plan = controller.plans[index];
              return SubscriptionPlanCard(plan: plan, l10n: l10n, canEdit: canEdit || canDelete, onEdit: () => _showPlanForm(context, l10n, plan), onToggle: () => _togglePlan(context, l10n, plan), onDelete: () => _deletePlan(context, l10n, plan));
            },
          );
        });
      }),
      SubscriptionWorkspaceSection.subscriptions => Obx(() {
        if (controller.subscriptionsLoading.value && controller.subscriptions.isEmpty) return const CustomSkeletonGrid(count: 6, crossAxisCount: 1, itemHeight: 92);
        if (controller.subscriptionsError.value.isNotEmpty && controller.subscriptions.isEmpty) return CustomErrorState.boxed(title: l10n.text('provider_subscriptions_load_error'), subtitle: controller.subscriptionsError.value, icon: Icons.cloud_off_rounded, retryLabel: l10n.text('refresh'), onRetry: controller.loadSubscriptions);
        if (controller.subscriptions.isEmpty) return CustomEmptyState.boxed(title: l10n.text('provider_subscriptions_empty'), subtitle: l10n.text('provider_subscriptions_empty_description'), icon: Icons.card_membership_outlined, badgeText: l10n.text('provider_subscriptions'));
        return ListView.separated(
          itemCount: controller.subscriptions.length + (controller.hasMoreSubscriptions ? 1 : 0),
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (index == controller.subscriptions.length) return Center(child: CustomButton.outline(text: l10n.text('load_more'), loading: controller.subscriptionsLoading.value, onPressed: controller.subscriptionsLoading.value ? null : () => controller.loadSubscriptions(append: true)));
            final item = controller.subscriptions[index];
            return ProviderSubscriptionCard(subscription: item, l10n: l10n, canEdit: canEdit, onExtend: () => _extend(context, l10n, item));
          },
        );
      }),
      SubscriptionWorkspaceSection.requests => Obx(() {
        if (controller.requestsLoading.value && controller.requests.isEmpty) return const CustomSkeletonGrid(count: 5, crossAxisCount: 1, itemHeight: 150);
        if (controller.requestsError.value.isNotEmpty && controller.requests.isEmpty) return CustomErrorState.boxed(title: l10n.text('subscription_requests_load_error'), subtitle: controller.requestsError.value, icon: Icons.cloud_off_rounded, retryLabel: l10n.text('refresh'), onRetry: controller.loadRequests);
        if (controller.requests.isEmpty) return CustomEmptyState.boxed(title: l10n.text('subscription_requests_empty'), subtitle: l10n.text('subscription_requests_empty_description'), icon: Icons.assignment_outlined, badgeText: l10n.text('subscription_requests'));
        return ListView.separated(
          itemCount: controller.requests.length + (controller.hasMoreRequests ? 1 : 0),
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (index == controller.requests.length) return Center(child: CustomButton.outline(text: l10n.text('load_more'), loading: controller.requestsLoading.value, onPressed: controller.requestsLoading.value ? null : () => controller.loadRequests(append: true)));
            final item = controller.requests[index];
            return SubscriptionRequestCard(request: item, l10n: l10n, canReview: canApprove || canReject, onApprove: () => _approve(context, l10n, item), onReject: () => _reject(context, l10n, item));
          },
        );
      }),
    };
  }

  Future<void> _showPlanForm(BuildContext context, AppLocalizations l10n, [SubscriptionPlanEntity? plan]) async {
    controller.resetPlanForm(plan);
    final accepted = await CustomDialog.custom(
      title: l10n.text(plan == null ? 'create_subscription_plan' : 'edit_subscription_plan'),
      confirmLabel: l10n.text('save'),
      cancelLabel: l10n.text('cancel'),
      maxWidth: 620,
      content: SingleChildScrollView(child: Column(children: [
        CustomTextField(controller: controller.planNameController, label: l10n.text('plan_name')),
        SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(child: CustomTextField(controller: controller.planPriceController, label: l10n.text('plan_price'), keyboardType: TextInputType.number)),
          SizedBox(width: AppSpacing.md),
          Expanded(child: CustomTextField(controller: controller.planDiscountController, label: l10n.text('plan_discount'), keyboardType: TextInputType.number, isRequired: false)),
        ]),
        SizedBox(height: AppSpacing.md),
        CustomTextField(controller: controller.planValidityController, label: l10n.text('plan_validity_days'), keyboardType: TextInputType.number),
        SizedBox(height: AppSpacing.md),
        CustomTextField(controller: controller.planDescriptionController, label: l10n.text('description'), maxLines: 3, isRequired: false),
      ])),
      onConfirm: () => Get.back<bool>(result: true),
      onCancel: () => Get.back<bool>(result: false),
    ).showDialog(context);
    if (accepted != true) return;
    try {
      await controller.savePlan(id: plan?.id);
      CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('subscription_plan_saved'), type: SnackType.success);
    } catch (e) { CustomSnackbar.show(title: l10n.text('error'), message: e.toString(), type: SnackType.error); }
  }

  Future<void> _togglePlan(BuildContext context, AppLocalizations l10n, SubscriptionPlanEntity plan) async {
    final accepted = await CustomDialog.confirmation(title: l10n.text(plan.isActive ? 'deactivate_plan' : 'activate_plan'), message: l10n.text('subscription_plan_status_confirmation'), confirmLabel: l10n.text('confirm'), cancelLabel: l10n.text('cancel'), onConfirm: () => Get.back<bool>(result: true)).showDialog(context);
    if (accepted != true) return;
    try { await controller.togglePlan(plan); CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('subscription_plan_status_updated'), type: SnackType.success); }
    catch (e) { CustomSnackbar.show(title: l10n.text('error'), message: e.toString(), type: SnackType.error); }
  }

  Future<void> _deletePlan(BuildContext context, AppLocalizations l10n, SubscriptionPlanEntity plan) async {
    final accepted = await CustomDialog.danger(title: l10n.text('delete_subscription_plan'), message: l10n.text('delete_subscription_plan_confirmation'), confirmLabel: l10n.text('delete'), cancelLabel: l10n.text('cancel'), onConfirm: () => Get.back<bool>(result: true)).showDialog(context);
    if (accepted != true) return;
    try { await controller.removePlan(plan.id); CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('subscription_plan_deleted'), type: SnackType.success); }
    catch (e) { CustomSnackbar.show(title: l10n.text('error'), message: e.toString(), type: SnackType.error); }
  }

  Future<void> _approve(BuildContext context, AppLocalizations l10n, SubscriptionRequestEntity request) async {
    final accepted = await CustomDialog.confirmation(title: l10n.text('approve_request'), message: l10n.text('approve_subscription_request_confirmation'), confirmLabel: l10n.text('approve'), cancelLabel: l10n.text('cancel'), onConfirm: () => Get.back<bool>(result: true)).showDialog(context);
    if (accepted != true) return;
    try { controller.reviewNoteController.clear(); await controller.approve(request); CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('subscription_request_approved'), type: SnackType.success); }
    catch (e) { CustomSnackbar.show(title: l10n.text('error'), message: e.toString(), type: SnackType.error); }
  }

  Future<void> _reject(BuildContext context, AppLocalizations l10n, SubscriptionRequestEntity request) async {
    controller.rejectReasonController.clear(); controller.reviewNoteController.clear();
    final accepted = await CustomDialog.custom(
      title: l10n.text('reject_subscription_request'),
      confirmLabel: l10n.text('reject_request'),
      cancelLabel: l10n.text('cancel'),
      maxWidth: 560,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomTextField(controller: controller.rejectReasonController, label: l10n.text('rejection_reason'), maxLines: 3),
        SizedBox(height: AppSpacing.md),
        CustomTextField(controller: controller.reviewNoteController, label: l10n.text('review_note_optional'), maxLines: 2, isRequired: false),
      ]),
      onConfirm: () => Get.back<bool>(result: true),
      onCancel: () => Get.back<bool>(result: false),
    ).showDialog(context);
    if (accepted != true) return;
    try { await controller.reject(request); CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('subscription_request_rejected'), type: SnackType.success); }
    catch (e) { CustomSnackbar.show(title: l10n.text('error'), message: e.toString(), type: SnackType.error); }
  }

  Future<void> _extend(BuildContext context, AppLocalizations l10n, ProviderSubscriptionEntity item) async {
    controller.extensionDaysController.text = '30';
    final accepted = await CustomDialog.custom(
      title: l10n.text('extend_subscription'),
      confirmLabel: l10n.text('confirm'),
      cancelLabel: l10n.text('cancel'),
      content: CustomTextField(controller: controller.extensionDaysController, label: l10n.text('additional_days'), keyboardType: TextInputType.number),
      onConfirm: () => Get.back<bool>(result: true),
      onCancel: () => Get.back<bool>(result: false),
    ).showDialog(context);
    if (accepted != true) return;
    try { await controller.extend(item); CustomSnackbar.show(title: l10n.text('success'), message: l10n.text('subscription_extended'), type: SnackType.success); }
    catch (e) { CustomSnackbar.show(title: l10n.text('error'), message: e.toString(), type: SnackType.error); }
  }
}

class _SectionSwitcher extends StatelessWidget {
  const _SectionSwitcher({required this.section, required this.l10n});
  final SubscriptionWorkspaceSection section;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    final entries = [
      (SubscriptionWorkspaceSection.plans, 'subscription_plans', Icons.sell_outlined),
      (SubscriptionWorkspaceSection.subscriptions, 'provider_subscriptions', Icons.card_membership_outlined),
      (SubscriptionWorkspaceSection.requests, 'subscription_requests', Icons.assignment_outlined),
    ];
    return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.xs, children: entries.map((entry) => CustomButton(
      text: l10n.text(entry.$2),
      prefix: Icon(entry.$3, size: 17),
      size: AppButtonSize.medium,
      variant: section == entry.$1 ? AppButtonVariant.secondary : AppButtonVariant.text,
      onPressed: () => Get.offNamed<void>(switch (entry.$1) {
        SubscriptionWorkspaceSection.plans => '/dashboard/subscription-plans',
        SubscriptionWorkspaceSection.subscriptions => '/dashboard/provider-subscriptions',
        SubscriptionWorkspaceSection.requests => '/dashboard/subscription-requests',
      }),
    )).toList());
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => CustomButton(text: label, size: AppButtonSize.small, variant: selected ? AppButtonVariant.secondary : AppButtonVariant.text, onPressed: onTap);
}
