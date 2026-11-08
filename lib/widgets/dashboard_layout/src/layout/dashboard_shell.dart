import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import '../config/dashboard_layout_config.dart';
import '../models/dashboard_breadcrumb.dart';
import '../models/dashboard_navigation_item.dart';
import '../models/dashboard_user_profile.dart';
import '../theme/dashboard_layout_theme.dart';
import '../widgets/dashboard_page_header.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_topbar.dart';
import '../../desktop_title_bar.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    required this.child, required this.navigation, required this.selectedNavigationId,
    required this.onNavigationSelected, this.config = const DashboardLayoutConfig(),
    this.sidebarHeader, this.sidebarFooter, this.topbarLeading, this.search,
    this.notifications, this.topbarActions, this.profile, this.onProfileTap,
    this.breadcrumbs = const [], this.onBreadcrumbTap, this.pageHeader,
    this.sidebarCollapsed, this.onSidebarCollapsedChanged,
    this.sidebarHeaderBuilder, this.sidebarFooterBuilder,
    this.expandSidebarTooltip = 'Expand navigation',
    this.collapseSidebarTooltip = 'Collapse navigation',
    this.expandedGroupIds = const {}, this.onGroupExpansionChanged, this.content,
    super.key,
  });
  final Widget child;
  final DashboardNavigationSection navigation;
  final String? selectedNavigationId;
  final ValueChanged<String> onNavigationSelected;
  final DashboardLayoutConfig config;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final Widget? topbarLeading;
  final Widget? search;
  final Widget? notifications;
  final List<Widget>? topbarActions;
  final DashboardUserProfile? profile;
  final VoidCallback? onProfileTap;
  final List<DashboardBreadcrumb> breadcrumbs;
  final ValueChanged<String>? onBreadcrumbTap;
  final DashboardPageHeaderData? pageHeader;
  /// Null keeps the responsive default; a value represents an explicit user override.
  final bool? sidebarCollapsed;
  final ValueChanged<bool>? onSidebarCollapsedChanged;
  final Widget Function(bool collapsed)? sidebarHeaderBuilder;
  final Widget Function(bool collapsed)? sidebarFooterBuilder;
  final String expandSidebarTooltip;
  final String collapseSidebarTooltip;
  final Set<String> expandedGroupIds;
  final ValueChanged<String>? onGroupExpansionChanged;
  final Widget? content;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < config.mobileBreakpoint;
      final autoCollapse = constraints.maxWidth < AppBreakpoints.desktopMax || config.initiallyCollapsed;
      final effectiveCollapsed = !compact && (sidebarCollapsed ?? autoCollapse);
      final theme = DashboardLayoutTheme.of(context);
      final sidebar = DashboardSidebar(
        navigation: navigation,
        selectedNavigationId: selectedNavigationId,
        onNavigationSelected: onNavigationSelected,
        collapsed: compact ? false : effectiveCollapsed,
        onCollapsedChanged: onSidebarCollapsedChanged,
        header: sidebarHeaderBuilder?.call(compact ? false : effectiveCollapsed) ?? sidebarHeader,
        footer: sidebarFooterBuilder?.call(compact ? false : effectiveCollapsed) ?? sidebarFooter,
        expandedGroupIds: expandedGroupIds,
        onGroupExpansionChanged: onGroupExpansionChanged,
      );
      return Scaffold(
        backgroundColor: theme.contentBackground,
        drawer: compact ? Drawer(width: config.expandedSidebarWidth, child: SafeArea(child: sidebar)) : null,
        body: SafeArea(
          child: Column(
            children: [
              DesktopTitleBar(backgroundColor: theme.topbarBackground),
              Expanded(
                child: Row(
                  children: [
                    if (!compact)
                      AnimatedContainer(
                        duration: theme.motionDuration,
                        curve: theme.motionCurve,
                        width: effectiveCollapsed ? config.collapsedSidebarWidth : config.expandedSidebarWidth,
                        child: sidebar,
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          DashboardTopbar(
                            height: config.topbarHeight,
                            leading: compact
                                ? Builder(
                                    builder: (context) => CustomButton.icon(
                                      icon: Icons.menu_rounded,
                                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                                      onPressed: () => Scaffold.of(context).openDrawer(),
                                      dimension: 40,
                                    ),
                                  )
                                : topbarLeading ??
                                    (onSidebarCollapsedChanged == null
                                        ? null
                                        : CustomButton.icon(
                                            icon: effectiveCollapsed ? Icons.menu_open_rounded : Icons.menu_rounded,
                                            tooltip: effectiveCollapsed ? expandSidebarTooltip : collapseSidebarTooltip,
                                            onPressed: () => onSidebarCollapsedChanged!(!effectiveCollapsed),
                                            dimension: 40,
                                          )),
                            search: search,
                            notifications: notifications,
                            actions: topbarActions,
                            profile: profile,
                            onProfileTap: onProfileTap,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(config.contentPadding ?? AppBreakpoints.screenMargin(context)),
                              child: Align(
                                alignment: AlignmentDirectional.topCenter,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: config.maxContentWidth ?? AppBreakpoints.maxDashboardContentWidth),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        if (config.showBreadcrumbs && breadcrumbs.isNotEmpty)
                                          _BreadcrumbRow(breadcrumbs: breadcrumbs, onTap: onBreadcrumbTap),
                                        if (pageHeader != null) ...[
                                          AppSpacing.vMd,
                                          DashboardPageHeader(data: pageHeader!),
                                          AppSpacing.vXl,
                                        ],
                                        Expanded(child: content ?? child),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _BreadcrumbRow extends StatelessWidget {
  const _BreadcrumbRow({required this.breadcrumbs, this.onTap});
  final List<DashboardBreadcrumb> breadcrumbs;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      children: [
        for (var index = 0; index < breadcrumbs.length; index++) ...[
          if (index > 0)
            Icon(
              Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
          CustomButton.text(
            onPressed: breadcrumbs[index].enabled && breadcrumbs[index].id != null && onTap != null
                ? () => onTap!(breadcrumbs[index].id!)
                : null,
            size: AppButtonSize.small,
            enableScaleAnimation: false,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            foregroundColor: index == breadcrumbs.length - 1 ? scheme.onSurface : scheme.onSurfaceVariant,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (breadcrumbs[index].icon != null) ...[
                  Icon(breadcrumbs[index].icon, size: 14, color: scheme.onSurfaceVariant),
                  AppSpacing.hXxs,
                ],
                Text(breadcrumbs[index].label),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
