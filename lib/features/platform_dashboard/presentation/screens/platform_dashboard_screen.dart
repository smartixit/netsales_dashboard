import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/locale_service.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/services/theme_service.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/platform_navigation_footer.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/platform_sidebar_brand.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_command_palette.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_notification_center.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_profile_menu.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/dashboard_layout.dart';

class PlatformDashboardScreen extends GetView<PlatformDashboardController> {
  const PlatformDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final user = SessionService.to.currentUser;
    final isNarrow = AppBreakpoints.widthOf(context) < AppBreakpoints.tabletMax;
    final destinations = <CommandPaletteItem>[
      CommandPaletteItem(
        id: 'overview',
        title: l10n.text('overview'),
        subtitle: l10n.text('platform_summary'),
        icon: Icons.space_dashboard_outlined,
      ),
      for (final item in PlatformNavigationRegistry.destinations)
        if (PlatformNavigationRegistry.canOpen(item))
          CommandPaletteItem(
            id: item.id,
            title: l10n.text(item.labelKey),
            subtitle: l10n.text('open'),
            icon: item.icon,
            keywords: [item.id, item.labelKey],
          ),
    ];

    void openPalette() {
      CustomCommandPalette.show(
        context: context,
        items: destinations,
        queryController: controller.commandController,
        query: controller.commandQuery,
        onSelected: (item) {
          final route = PlatformNavigationRegistry.routeForId(item.id);
          if (route != null) {
            controller.setActiveRoute(route);
            Get.toNamed<void>(route);
          }
        },
      );
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            openPalette,
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): openPalette,
      },
      child: Obx(() {
        final navigation = PlatformNavigationRegistry.build(context);
        final selectedId = _selectedId(controller.activeRoute.value);
        final selectedLabel = _labelForId(context, selectedId);
        return DashboardShell(
          config: const DashboardLayoutConfig(
            expandedSidebarWidth: 272,
            collapsedSidebarWidth: 76,
            topbarHeight: 68,
            mobileBreakpoint: 900,
            showBreadcrumbs: true,
          ),
          navigation: navigation,
          selectedNavigationId: selectedId,
          onNavigationSelected: (id) {
            final route = PlatformNavigationRegistry.routeForId(id);
            if (route != null) {
              controller.setActiveRoute(route);
              Get.toNamed<void>(route);
            }
          },
          sidebarCollapsed: controller.sidebarCollapsed.value,
          onSidebarCollapsedChanged: controller.setSidebarCollapsed,
          expandSidebarTooltip: l10n.text('expand_sidebar'),
          collapseSidebarTooltip: l10n.text('collapse_sidebar'),
          expandedGroupIds: controller.expandedGroups.toSet(),
          onGroupExpansionChanged: controller.toggleGroup,
          sidebarHeaderBuilder: (collapsed) =>
              PlatformSidebarBrand(collapsed: collapsed),
          sidebarFooterBuilder: (collapsed) =>
              PlatformNavigationFooter(collapsed: collapsed),
          search: isNarrow
              ? CustomButton.icon(
                  icon: Icons.search_rounded,
                  tooltip: l10n.text('search'),
                  onPressed: openPalette,
                  foregroundColor: colors.onSurfaceVariant,
                  backgroundColor: colors.surfaceContainerLow,
                  dimension: 40,
                )
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: openPalette,
                    borderRadius: AppRadius.mdRadius,
                    child: Container(
                      width: 260,
                      height: AppSpacing.buttonHeight,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow.withValues(alpha: 0.65),
                        borderRadius: AppRadius.mdRadius,
                        border: Border.all(
                          color: colors.outlineVariant.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 19,
                            color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                          AppSpacing.hSm,
                          Expanded(
                            child: Text(
                              '${l10n.text('search')}...',
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerHighest.withValues(alpha: 0.8),
                              borderRadius: AppRadius.xsRadius,
                              border: Border.all(
                                color: colors.outlineVariant.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'Ctrl K',
                              style: AppTypography.caption.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          notifications: controller.canViewNotifications
              ? CustomNotificationCenter(
                  items: controller.notificationItems,
                  unreadCount: controller.unreadCount,
                  isLoading: controller.isLoadingNotifications,
                  hasError: controller.hasNotificationError,
                  onRefresh: controller.loadNotifications,
                  onMarkRead: controller.markRead,
                  onMarkAllRead: controller.markAllRead,
                  onViewAll: () {
                    controller.setActiveRoute(AppRoutes.notifications);
                    Get.toNamed<void>(AppRoutes.notifications);
                  },
                )
              : null,
          topbarActions: [
            CustomButton.icon(
              icon: ThemeService.to.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              tooltip: l10n.text(
                ThemeService.to.isDarkMode ? 'light_mode' : 'dark_mode',
              ),
              onPressed: ThemeService.to.toggleTheme,
              foregroundColor: colors.onSurfaceVariant,
              backgroundColor: colors.surfaceContainerLow,
              dimension: 40,
            ),
            AppSpacing.hXs,
            CustomButton.icon(
              icon: Icons.language_rounded,
              tooltip: l10n.text('language'),
              onPressed: LocaleService.to.toggleLocale,
              foregroundColor: colors.onSurfaceVariant,
              backgroundColor: colors.surfaceContainerLow,
              dimension: 40,
            ),
            AppSpacing.hXs,
            CustomProfileMenu(
              name: user?.userFullName ?? '',
              role: user?.role?.roleName ?? PermissionService.to.currentRole,
              avatarUrl: user?.userProfileLogo,
              compact: isNarrow,
              profileLabel: l10n.text('profile'),
              securityLabel: l10n.text('security_settings'),
              devicesLabel: l10n.text('devices'),
              logoutLabel: l10n.text('logout'),
              showSecurity: PermissionService.to.can('auth.view'),
              showDevices: PermissionService.to.can('auth.view'),
              onSelected: (action) {
                switch (action) {
                  case CustomProfileAction.profile:
                    controller.setActiveRoute(AppRoutes.account);
                    Get.toNamed<void>(AppRoutes.account);
                    break;
                  case CustomProfileAction.security:
                  case CustomProfileAction.devices:
                    controller.setActiveRoute(AppRoutes.sessions);
                    Get.toNamed<void>(AppRoutes.sessions);
                    break;
                  case CustomProfileAction.logout:
                    controller.logout();
                    break;
                }
              },
            ),
          ],
          breadcrumbs: [
            DashboardBreadcrumb(
              label: l10n.text('overview'),
              id: 'overview',
              enabled: selectedId != 'overview',
            ),
            if (selectedId != 'overview')
              DashboardBreadcrumb(
                label: selectedLabel,
                id: selectedId,
                enabled: false,
              ),
          ],
          onBreadcrumbTap: (id) {
            final route = PlatformNavigationRegistry.routeForId(id);
            if (route != null) {
              controller.setActiveRoute(route);
              Get.toNamed<void>(route);
            }
          },
          pageHeader: DashboardPageHeaderData(
            title: selectedLabel,
            description: selectedId == 'overview'
                ? l10n.text('platform_summary')
                : null,
            icon: selectedId == 'overview'
                ? Icons.space_dashboard_rounded
                : Icons.dashboard_outlined,
          ),
          child: GetRouterOutlet(
            anchorRoute: AppRoutes.dashboard,
            initialRoute: AppRoutes.overview,
          ),
        );
      }),
    );
  }

  String _selectedId(String route) {
    if (route.endsWith('/overview') || route == AppRoutes.dashboard) {
      return 'overview';
    }
    if (route.endsWith('/account')) return 'account';
    if (route.startsWith(AppRoutes.networks) && route != AppRoutes.networks) {
      return 'networks';
    }
    for (final destination in PlatformNavigationRegistry.destinations) {
      if (route == destination.route || route.endsWith(destination.route)) {
        return destination.id;
      }
    }
    return 'overview';
  }

  String _labelForId(BuildContext context, String id) {
    if (id == 'overview') return AppLocalizations.of(context).text('overview');
    if (id == 'account') return AppLocalizations.of(context).text('profile');
    final destination = PlatformNavigationRegistry.destinations
        .firstWhereOrNull((item) => item.id == id);
    return AppLocalizations.of(context).text(destination?.labelKey ?? id);
  }
}
