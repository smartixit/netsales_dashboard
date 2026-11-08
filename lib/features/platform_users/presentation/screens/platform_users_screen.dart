import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/models/user_model.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

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
          _UsersHeading(l10n: l10n),
          SizedBox(height: AppSpacing.lg),
          _UsersFilters(controller: controller, l10n: l10n),
          SizedBox(height: AppSpacing.md),
          Expanded(child: _UsersContent(controller: controller, l10n: l10n)),
        ],
      ),
    );
  }
}

class _UsersHeading extends StatelessWidget {
  const _UsersHeading({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l10n.text('users'), style: AppTypography.headlineSmall),
      SizedBox(height: AppSpacing.xs),
      Text(
        l10n.text('platform_users_description'),
        style: AppTypography.bodyMedium.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    ],
  );
}

class _UsersFilters extends StatelessWidget {
  const _UsersFilters({required this.controller, required this.l10n});
  final PlatformUsersController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final search = SizedBox(
          width: constraints.maxWidth >= 760 ? 360 : double.infinity,
          child: CustomTextField(
            controller: controller.searchController,
            label: l10n.text('search_users'),
            hint: l10n.text('search_users_hint'),
            prefixIcon: const Icon(Icons.search_rounded),
            isRequired: false,
            onChanged: controller.onSearchChanged,
          ),
        );
        final status = Obx(
          () => Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _StatusFilter(label: l10n.text('all'), selected: controller.selectedStatus.value.isEmpty, onPressed: () => controller.setStatus('')),
              _StatusFilter(label: l10n.text('user_status_active'), selected: controller.selectedStatus.value == 'ACTIVE', onPressed: () => controller.setStatus('ACTIVE')),
              _StatusFilter(label: l10n.text('user_status_inactive'), selected: controller.selectedStatus.value == 'INACTIVE', onPressed: () => controller.setStatus('INACTIVE')),
              _StatusFilter(label: l10n.text('user_status_pending'), selected: controller.selectedStatus.value == 'PENDING', onPressed: () => controller.setStatus('PENDING')),
              _StatusFilter(label: l10n.text('user_status_banned'), selected: controller.selectedStatus.value == 'BANNED', onPressed: () => controller.setStatus('BANNED')),
            ],
          ),
        );
        if (constraints.maxWidth >= 760) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [search, SizedBox(width: AppSpacing.md), Expanded(child: status)],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [search, SizedBox(height: AppSpacing.md), status],
        );
      },
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.label, required this.selected, required this.onPressed});
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => CustomButton(
    text: label,
    onPressed: onPressed,
    variant: selected ? AppButtonVariant.secondary : AppButtonVariant.text,
    size: AppButtonSize.small,
  );
}

class _UsersContent extends StatelessWidget {
  const _UsersContent({required this.controller, required this.l10n});
  final PlatformUsersController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.viewState.value) {
        case AppDataGridViewState.loading:
          return const Center(child: CircularProgressIndicator.adaptive());
        case AppDataGridViewState.error:
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.errorMessage.value),
                SizedBox(height: AppSpacing.md),
                CustomButton.secondary(
                  text: l10n.text('refresh'),
                  prefix: const Icon(Icons.refresh_rounded, size: 18),
                  onPressed: controller.loadUsers,
                ),
              ],
            ),
          );
        case AppDataGridViewState.empty:
          return Center(
            child: Text(
              l10n.text('users_empty'),
              style: AppTypography.bodyLarge.copyWith(color: context.colors.onSurfaceVariant),
            ),
          );
        case AppDataGridViewState.noResults:
          return Center(child: Text(l10n.text('no_results')));
        case AppDataGridViewState.success:
          return _UsersList(controller: controller, l10n: l10n);
      }
    });
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({required this.controller, required this.l10n});
  final PlatformUsersController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;
        return Column(
          children: [
            if (!compact) _UsersTableHeader(l10n: l10n),
            Expanded(
              child: ListView.separated(
                itemCount: controller.users.length + (controller.hasMore ? 1 : 0),
                separatorBuilder: (_, __) => Divider(height: 1, color: context.colors.outlineVariant),
                itemBuilder: (context, index) {
                  if (index == controller.users.length) {
                    return Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(
                        child: CustomButton.secondary(
                          text: l10n.text('load_more'),
                          loading: controller.isLoadingMore.value,
                          onPressed: controller.isLoadingMore.value
                              ? null
                              : () => controller.loadUsers(append: true),
                        ),
                      ),
                    );
                  }
                  return _UserRow(user: controller.users[index], l10n: l10n, compact: compact);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UsersTableHeader extends StatelessWidget {
  const _UsersTableHeader({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    color: context.colors.surfaceContainerHigh,
    child: Row(
      children: [
        Expanded(flex: 3, child: Text(l10n.text('user_name'), style: AppTypography.labelLarge)),
        Expanded(flex: 2, child: Text(l10n.text('user_phone'), style: AppTypography.labelLarge)),
        Expanded(flex: 2, child: Text(l10n.text('user_role'), style: AppTypography.labelLarge)),
        Expanded(flex: 1, child: Text(l10n.text('user_status'), style: AppTypography.labelLarge)),
        Expanded(flex: 2, child: Text(l10n.text('user_last_login'), style: AppTypography.labelLarge)),
      ],
    ),
  );
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.l10n, required this.compact});
  final UserModel user;
  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final status = user.status.toUpperCase();
    final statusLabel = switch (status) {
      'ACTIVE' => l10n.text('user_status_active'),
      'INACTIVE' => l10n.text('user_status_inactive'),
      'PENDING' => l10n.text('user_status_pending'),
      'BANNED' => l10n.text('user_status_banned'),
      _ => user.statusLabel ?? status,
    };
    final role = user.role?.roleName ?? user.role?.roleKeyLabel ?? user.role?.roleKey ?? '—';
    final content = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [Expanded(child: Text(user.userFullName, style: AppTypography.titleMedium)), _StatusPill(label: statusLabel)]),
              SizedBox(height: AppSpacing.xs),
              Text(user.userPhoneNumber, style: AppTypography.bodyMedium),
              Text(role, style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
              if (user.lastLoginAt != null)
                Text('${l10n.text('user_last_login')}: ${user.lastLoginAt}', style: AppTypography.caption.copyWith(color: context.colors.onSurfaceVariant)),
            ],
          )
        : Row(
            children: [
              Expanded(flex: 3, child: Text(user.userFullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium)),
              Expanded(flex: 2, child: Text(user.userPhoneNumber, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium)),
              Expanded(flex: 2, child: Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium)),
              Expanded(flex: 1, child: _StatusPill(label: statusLabel)),
              Expanded(flex: 2, child: Text(user.lastLoginAt ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall)),
            ],
          );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: content,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Text(label, style: AppTypography.badgeText.copyWith(color: context.colors.onSurface)),
      ),
    ),
  );
}
