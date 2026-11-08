import 'package:flutter/material.dart';
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
      CustomPopupItem<CustomProfileAction>(value: CustomProfileAction.profile, label: profileLabel, icon: Icons.person_outline_rounded),
      if (showSecurity) CustomPopupItem<CustomProfileAction>(value: CustomProfileAction.security, label: securityLabel, icon: Icons.shield_outlined),
      if (showDevices) CustomPopupItem<CustomProfileAction>(value: CustomProfileAction.devices, label: devicesLabel, icon: Icons.devices_outlined),
      const CustomPopupDivider<CustomProfileAction>(),
      CustomPopupItem<CustomProfileAction>(value: CustomProfileAction.logout, label: logoutLabel, icon: Icons.logout_rounded, isDestructive: true),
    ];
    return CustomPopupMenu<CustomProfileAction>(
      items: entries,
      onSelected: onSelected,
      trigger: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? AppSpacing.xs : AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colors.primaryContainer,
              backgroundImage: avatarUrl == null || avatarUrl!.isEmpty ? null : NetworkImage(avatarUrl!),
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? Text(initials ?? (name.isEmpty ? '?' : name.characters.first), style: AppTypography.labelMedium.copyWith(color: colors.onPrimaryContainer))
                  : null,
            ),
            if (!compact) ...[
              AppSpacing.hSm,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.labelMedium.copyWith(color: colors.onSurface)),
                    Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant)),
                  ],
                ),
              ),
              AppSpacing.hXs,
              Icon(Icons.expand_more_rounded, color: colors.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}
