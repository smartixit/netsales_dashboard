import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/enums/user_status.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class PlatformUsersList extends StatelessWidget {
  const PlatformUsersList({super.key, required this.controller, required this.l10n});
  final PlatformUsersController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final compact = constraints.maxWidth < 650;
    return Column(children: [
      if (!compact) _UsersTableHeader(l10n: l10n),
      Expanded(child: ListView.separated(
        itemCount: controller.users.length + (controller.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.outlineVariant),
        itemBuilder: (context, index) {
          if (index == controller.users.length) {
            return Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CustomButton.secondary(
                text: l10n.text('load_more'),
                loading: controller.isLoadingMore.value,
                onPressed: controller.isLoadingMore.value ? null : () => controller.loadUsers(append: true),
              )),
            );
          }
          return _UserRow(user: controller.users[index], compact: compact);
        },
      )),
    ]);
  });
}

class _UsersTableHeader extends StatelessWidget {
  const _UsersTableHeader({required this.l10n});
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    color: context.colors.surfaceContainerHigh,
    child: Row(children: [
      Expanded(flex: 3, child: Text(l10n.text('user_name'), style: AppTypography.labelLarge)),
      Expanded(flex: 2, child: Text(l10n.text('user_phone'), style: AppTypography.labelLarge)),
      Expanded(flex: 2, child: Text(l10n.text('user_role'), style: AppTypography.labelLarge)),
      Expanded(flex: 1, child: Text(l10n.text('user_status'), style: AppTypography.labelLarge)),
      Expanded(flex: 2, child: Text(l10n.text('user_last_login'), style: AppTypography.labelLarge)),
    ]),
  );
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.compact});
  final PlatformUserEntity user;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final presentation = EnumPresentationRegistry.resolveUserStatus(UserStatus.fromWire(user.status), serverLabel: user.statusLabel);
    final badge = CustomStatusBadge.fromPresentation(presentation, isCompact: true);
    final login = user.lastLoginAt?.toLocal().toString() ?? '—';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: compact
        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [Expanded(child: Text(user.fullName, style: AppTypography.titleMedium)), badge]),
            SizedBox(height: AppSpacing.xs),
            Text(user.phoneNumber, style: AppTypography.bodyMedium),
            Text(user.roleName ?? '—', style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
            if (user.lastLoginAt != null) Text(login, style: AppTypography.caption),
          ])
        : Row(children: [
            Expanded(flex: 3, child: Text(user.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium)),
            Expanded(flex: 2, child: Text(user.phoneNumber, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium)),
            Expanded(flex: 2, child: Text(user.roleName ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium)),
            Expanded(flex: 1, child: badge),
            Expanded(flex: 2, child: Text(login, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall)),
          ]),
    );
  }
}
