import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/menus/custom_popup_menu.dart';

enum CustomProfileAction { profile, security, devices, logout }

class CustomProfileMenu extends StatelessWidget {
  const CustomProfileMenu({
    super.key,
    required this.name,
    required this.role,
    required this.onSelected,
    required this.profileLabel,
    required this.securityLabel,
    required this.devicesLabel,
    required this.logoutLabel,
    this.avatarUrl,
    this.initials,
    this.showSecurity = false,
    this.showDevices = false,
    this.compact = false,
  });
  final String name;
  final String role;
  final String profileLabel;
  final String securityLabel;
  final String devicesLabel;
  final String logoutLabel;
  final String? avatarUrl;
  final String? initials;
  final bool showSecurity;
  final bool showDevices;
  final bool compact;
  final ValueChanged<CustomProfileAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final entries = <CustomPopupEntry<CustomProfileAction>>[
      CustomPopupSectionHeader<CustomProfileAction>(title: role),
      CustomPopupItem<CustomProfileAction>(
        value: CustomProfileAction.profile,
        label: profileLabel,
        icon: Icons.person_outline_rounded,
      ),
      if (showSecurity)
        CustomPopupItem<CustomProfileAction>(
          value: CustomProfileAction.security,
          label: securityLabel,
          icon: Icons.shield_outlined,
        ),
      if (showDevices)
        CustomPopupItem<CustomProfileAction>(
          value: CustomProfileAction.devices,
          label: devicesLabel,
          icon: Icons.devices_outlined,
        ),
      const CustomPopupDivider<CustomProfileAction>(),
      CustomPopupItem<CustomProfileAction>(
        value: CustomProfileAction.logout,
        label: logoutLabel,
        icon: Icons.logout_rounded,
        isDestructive: true,
      ),
    ];
    return CustomPopupMenu<CustomProfileAction>(
      items: entries,
      onSelected: onSelected,
      trigger: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.xs : AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow.withValues(alpha: 0.65),
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: colors.primaryContainer,
              backgroundImage: avatarUrl == null || avatarUrl!.isEmpty
                  ? null
                  : NetworkImage(avatarUrl!),
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? Text(
                      initials ?? (name.isEmpty ? '?' : name.characters.first),
                      style: AppTypography.labelMedium.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            if (!compact) ...[
              AppSpacing.hSm,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 190),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMedium.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.hXs,
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: colors.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}
