import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

import '../models/dashboard_user_profile.dart';
import '../theme/dashboard_layout_theme.dart';

class DashboardTopbar extends StatelessWidget {
  const DashboardTopbar({
    required this.height,
    this.leading,
    this.search,
    this.notifications,
    this.actions,
    this.profile,
    this.onProfileTap,
    super.key,
  });
  final double height;
  final Widget? leading;
  final Widget? search;
  final Widget? notifications;
  final List<Widget>? actions;
  final DashboardUserProfile? profile;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final layoutTheme = DashboardLayoutTheme.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: layoutTheme.topbarBackground,
        border: Border(
          bottom: BorderSide(color: layoutTheme.border, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, AppSpacing.hMd],
          if (search != null)
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: search!,
              ),
            )
          else
            const Spacer(),
          if (notifications != null) ...[notifications!, AppSpacing.hSm],
          ...?actions,
          if (profile != null) ...[
            AppSpacing.hMd,
            Tooltip(
              message: profile!.name,
              child: CustomButton(
                variant: AppButtonVariant.custom,
                size: AppButtonSize.small,
                shape: AppButtonShape.pill,
                borderRadius: AppRadius.full,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: scheme.onSurface,
                onPressed: onProfileTap,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: scheme.primaryContainer,
                      backgroundImage: profile!.avatarUrl == null
                          ? null
                          : NetworkImage(profile!.avatarUrl!),
                      child: profile!.avatarUrl != null
                          ? null
                          : Text(
                              profile!.initials ??
                                  (profile!.name.isEmpty
                                      ? '?'
                                      : profile!.name.characters.first),
                              style: AppTypography.labelMedium.copyWith(
                                color: scheme.onPrimaryContainer,
                              ),
                            ),
                    ),
                    AppSpacing.hSm,
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (profile!.subtitle != null)
                            Text(
                              profile!.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AppSpacing.hXs,
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
