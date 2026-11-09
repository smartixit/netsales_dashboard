import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/enums/user_status.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_entity.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformUsersList extends StatelessWidget {
  const PlatformUsersList({
    super.key,
    required this.controller,
    required this.l10n,
  });
  final PlatformUsersController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 650;
      return Column(
        children: [
          if (!compact) _UsersTableHeader(l10n: l10n),
          Expanded(
            child: ListView.separated(
              itemCount: controller.users.length + (controller.hasMore ? 1 : 0),
              separatorBuilder: (_, _) =>
                  Divider(height: 1, color: context.colors.outlineVariant),
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
                final user = controller.users[index];
                return controller.isTrashView.value
                    ? _UserRow(
                        user: user,
                        compact: compact,
                        isTrashed: true,
                        onRestore: () => controller.restoreUser(user.id),
                        onForceDelete: controller.canDelete ? () => controller.forceDeleteUser(user.id) : null,
                      )
                    : InkWell(
                        onTap: () => Get.toNamed<void>(AppRoutes.userDetail(user.id)),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: _UserRow(
                          user: user,
                          compact: compact,
                          onDelete: controller.canDelete ? () => controller.softDeleteUser(user.id) : null,
                        ),
                      );
              },
            ),
          ),
        ],
      );
    },
  );
}

class _UsersTableHeader extends StatelessWidget {
  const _UsersTableHeader({required this.l10n});
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    color: context.colors.surfaceContainerHigh,
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(l10n.text('user_name'), style: AppTypography.labelLarge),
        ),
        Expanded(
          flex: 2,
          child: Text(l10n.text('user_phone'), style: AppTypography.labelLarge),
        ),
        Expanded(
          flex: 2,
          child: Text(l10n.text('user_role'), style: AppTypography.labelLarge),
        ),
        Expanded(
          flex: 1,
          child: Text(
            l10n.text('user_status'),
            style: AppTypography.labelLarge,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            l10n.text('user_last_login'),
            style: AppTypography.labelLarge,
          ),
        ),
      ],
    ),
  );
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.compact, this.isTrashed = false, this.onRestore, this.onForceDelete, this.onDelete});

  final PlatformUserEntity user;
  final bool compact;
  final bool isTrashed;
  final VoidCallback? onRestore;
  final VoidCallback? onForceDelete;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final presentation = EnumPresentationRegistry.resolveUserStatus(
      UserStatus.fromWire(user.status),
      serverLabel: user.statusLabel,
    );
    final badge = CustomStatusBadge.fromPresentation(
      presentation,
      isCompact: true,
    );
    final identity = Row(
      children: [
        CustomCachedImage.avatar(
          url: user.profileImage,
          radius: compact ? 21 : 20,
          fallbackText: _initials(user.fullName),
          fallbackTextStyle: AppTypography.labelMedium,
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall,
              ),
              if ((user.email ?? '').isNotEmpty)
                Text(
                  user.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: compact ? AppSpacing.md : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: identity),
                    SizedBox(width: AppSpacing.sm),
                    badge,
                    if (!isTrashed && onDelete != null)
                      CustomButton.icon(icon: Icons.delete_outline_rounded, tooltip: 'نقل إلى سلة المحذوفات', onPressed: onDelete, foregroundColor: context.colors.error, size: AppButtonSize.small),
                    if (!isTrashed && onDelete != null)
                  CustomButton.icon(icon: Icons.delete_outline_rounded, tooltip: 'نقل إلى سلة المحذوفات', onPressed: onDelete, foregroundColor: context.colors.error, size: AppButtonSize.small),
                if (isTrashed) ...[
                      CustomButton.icon(icon: Icons.restore_rounded, tooltip: 'استعادة', onPressed: onRestore, size: AppButtonSize.small),
                      CustomButton.icon(icon: Icons.delete_forever_outlined, tooltip: 'حذف نهائي', onPressed: onForceDelete, foregroundColor: context.colors.error, size: AppButtonSize.small),
                    ],
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _Meta(
                      icon: Icons.phone_iphone_rounded,
                      value: user.phoneNumber,
                    ),
                    _Meta(
                      icon: Icons.badge_outlined,
                      value: user.roleName ?? '—',
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: identity),
                Expanded(
                  flex: 2,
                  child: Text(
                    user.phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    user.roleName ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium,
                  ),
                ),
                Expanded(flex: 1, child: badge),
                if (isTrashed) ...[
                  CustomButton.icon(icon: Icons.restore_rounded, tooltip: 'استعادة', onPressed: onRestore, size: AppButtonSize.small),
                  CustomButton.icon(icon: Icons.delete_forever_outlined, tooltip: 'حذف نهائي', onPressed: onForceDelete, foregroundColor: context.colors.error, size: AppButtonSize.small),
                ],
                Expanded(
                  flex: 2,
                  child: Text(
                    user.lastLoginAt?.toLocal().toString() ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _initials(String value) {
    final words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    final parts = words
        .take(2)
        .map((word) => String.fromCharCode(word.runes.first));
    return parts.join();
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: context.colors.onSurfaceVariant),
      SizedBox(width: AppSpacing.xs),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
