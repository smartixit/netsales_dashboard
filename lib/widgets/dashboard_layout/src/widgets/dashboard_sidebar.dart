import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_motion.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

import '../models/dashboard_navigation_item.dart';
import '../theme/dashboard_layout_theme.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.navigation,
    required this.selectedNavigationId,
    required this.onNavigationSelected,
    this.collapsed = false,
    this.onCollapsedChanged,
    this.header,
    this.footer,
    this.expandedGroupIds = const {},
    this.onGroupExpansionChanged,
    super.key,
  });
  final DashboardNavigationSection navigation;
  final String? selectedNavigationId;
  final ValueChanged<String> onNavigationSelected;
  final bool collapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final Widget? header;
  final Widget? footer;
  final Set<String> expandedGroupIds;
  final ValueChanged<String>? onGroupExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = DashboardLayoutTheme.of(context);
    return Material(
      color: theme.sidebarBackground,
      child: Column(
        children: [
          if (header != null)
            Padding(
              padding: EdgeInsets.all(theme.sidebarPadding),
              child: header,
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: theme.sidebarPadding,
                vertical: AppSpacing.sm,
              ),
              children: [
                for (final item in navigation.items)
                  _NavigationTile(
                    item: item,
                    collapsed: collapsed,
                    selectedNavigationId: selectedNavigationId,
                    onSelected: onNavigationSelected,
                  ),
                for (final group in navigation.groups) ...[
                  AppSpacing.vSm,
                  if (!collapsed)
                    CustomButton(
                      variant: AppButtonVariant.custom,
                      size: AppButtonSize.small,
                      width: double.infinity,
                      enableScaleAnimation: false,
                      backgroundColor: Colors.transparent,
                      foregroundColor: theme.sidebarMuted,
                      borderRadius: AppRadius.sm,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      onPressed:
                          group.id == null || onGroupExpansionChanged == null
                          ? null
                          : () => onGroupExpansionChanged!(group.id!),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.label.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSmall.copyWith(
                                color: theme.sidebarMuted,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          Icon(
                            expandedGroupIds.contains(group.id)
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            size: 18,
                            color: theme.sidebarMuted,
                          ),
                        ],
                      ),
                    )
                  else
                    Divider(height: AppSpacing.md, color: theme.border),
                  if (collapsed ||
                      group.id == null ||
                      expandedGroupIds.contains(group.id))
                    AnimatedSize(
                      duration: AppMotion.duration(context, AppMotion.normal),
                      curve: AppMotion.standard,
                      child: Column(
                        children: [
                          for (final item in group.items)
                            _NavigationTile(
                              item: item,
                              collapsed: collapsed,
                              selectedNavigationId: selectedNavigationId,
                              onSelected: onNavigationSelected,
                            ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: EdgeInsets.all(theme.sidebarPadding),
              child: footer,
            ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.item,
    required this.collapsed,
    required this.selectedNavigationId,
    required this.onSelected,
    this.depth = 0,
  });
  final DashboardNavigationItem item;
  final bool collapsed;
  final String? selectedNavigationId;
  final ValueChanged<String> onSelected;
  final int depth;

  bool _containsSelected(DashboardNavigationItem item) {
    if (item.id == selectedNavigationId) return true;
    return item.children.any(_containsSelected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DashboardLayoutTheme.of(context);
    final selected = _containsSelected(item);
    final color = selected
        ? theme.sidebarSelectedForeground
        : item.enabled
        ? theme.sidebarForeground
        : theme.sidebarMuted;
    final iconWidget = Container(
      padding: EdgeInsets.all(collapsed ? AppSpacing.zero : AppSpacing.xs),
      decoration: BoxDecoration(
        color: selected
            ? theme.sidebarSelectedForeground.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: AppRadius.smRadius,
      ),
      child: Icon(
        selected ? (item.selectedIcon ?? item.icon) : item.icon,
        size: 20,
        color: color,
      ),
    );

    if (item.hasChildren && !collapsed) {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: AppSpacing.md * (depth + 1)),
        child: Column(
          children: [
            CustomButton(
              variant: AppButtonVariant.custom,
              size: AppButtonSize.medium,
              width: double.infinity,
              enableScaleAnimation: false,
              backgroundColor: selected
                  ? theme.sidebarSelectedBackground
                  : Colors.transparent,
              foregroundColor: color,
              borderRadius: theme.itemRadius,
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              onPressed: () => onSelected(item.id),
              child: Row(
                children: [
                  iconWidget,
                  AppSpacing.hSm,
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(color: color),
                    ),
                  ),
                  if (item.badge != null) _Badge(label: item.badge!),
                ],
              ),
            ),
            for (final child in item.children)
              _NavigationTile(
                item: child,
                collapsed: false,
                selectedNavigationId: selectedNavigationId,
                onSelected: onSelected,
                depth: depth + 1,
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: theme.itemSpacing),
      child: Tooltip(
        message: collapsed ? (item.tooltip ?? item.label) : '',
        child: Stack(
          children: [
            CustomButton(
              variant: AppButtonVariant.custom,
              size: AppButtonSize.medium,
              width: double.infinity,
              enableScaleAnimation: false,
              backgroundColor: selected
                  ? theme.sidebarSelectedBackground
                  : Colors.transparent,
              foregroundColor: color,
              borderRadius: theme.itemRadius,
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: collapsed
                    ? AppSpacing.zero
                    : AppSpacing.sm + depth * AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              onPressed: item.enabled ? () => onSelected(item.id) : null,
              child: Row(
                mainAxisAlignment: collapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  iconWidget,
                  if (!collapsed) ...[
                    AppSpacing.hSm,
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium.copyWith(
                          color: color,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (item.badge != null) _Badge(label: item.badge!),
                  ],
                ],
              ),
            ),
            if (selected)
              PositionedDirectional(
                start: AppSpacing.xxs,
                top: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: IgnorePointer(
                  child: Container(
                    key: ValueKey<String>(
                      'dashboard-navigation-active-indicator-${item.id}',
                    ),
                    width: 3,
                    decoration: BoxDecoration(
                      color: theme.sidebarSelectedForeground,
                      borderRadius: AppRadius.fullRadius,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = DashboardLayoutTheme.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: theme.badgeBackground,
        borderRadius: AppRadius.fullRadius,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: theme.badgeForeground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
