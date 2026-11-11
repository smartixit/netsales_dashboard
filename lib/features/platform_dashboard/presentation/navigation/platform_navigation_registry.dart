import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/models/dashboard_navigation_item.dart';

class PlatformNavigationDestination {
  const PlatformNavigationDestination({
    required this.id,
    required this.route,
    required this.labelKey,
    required this.icon,
    required this.permission,
    this.groupKey,
    this.requiredRole,
  });
  final String id;
  final String route;
  final String labelKey;
  final IconData icon;
  final String permission;
  final String? groupKey;
  final String? requiredRole;
}

class PlatformNavigationRegistry {
  PlatformNavigationRegistry._();
  static const overview = PlatformNavigationDestination(
    id: 'overview',
    route: '/dashboard/overview',
    labelKey: 'overview',
    icon: Icons.space_dashboard_outlined,
    permission: '',
  );

  static const destinations = <PlatformNavigationDestination>[
    PlatformNavigationDestination(
      id: 'users',
      route: '/dashboard/users',
      labelKey: 'users',
      icon: Icons.people_alt_outlined,
      permission: AppPermissions.usersView,
      groupKey: 'platform',
    ),
    PlatformNavigationDestination(
      id: 'roles',
      route: '/dashboard/roles',
      labelKey: 'roles',
      icon: Icons.admin_panel_settings_outlined,
      permission: AppPermissions.rolesView,
      groupKey: 'platform',
    ),
    PlatformNavigationDestination(
      id: 'networks',
      route: '/dashboard/networks',
      labelKey: 'networks',
      icon: Icons.router_outlined,
      permission: AppPermissions.networksView,
      groupKey: 'platform',
    ),
    PlatformNavigationDestination(
      id: 'pos',
      route: '/dashboard/pos',
      labelKey: 'pos',
      icon: Icons.storefront_outlined,
      permission: AppPermissions.posView,
      groupKey: 'platform',
    ),
    PlatformNavigationDestination(
      id: 'network_pos_links',
      route: '/dashboard/network-pos-links',
      labelKey: 'network_pos_links',
      icon: Icons.hub_outlined,
      permission: '',
      groupKey: 'platform',
      requiredRole: AppRoles.superAdmin,
    ),
    PlatformNavigationDestination(
      id: 'geography',
      route: '/dashboard/geography',
      labelKey: 'geography',
      icon: Icons.map_outlined,
      permission: AppPermissions.geographyView,
      groupKey: 'platform',
    ),
    PlatformNavigationDestination(
      id: 'billing',
      route: '/dashboard/billing',
      labelKey: 'billing_center',
      icon: Icons.receipt_long_rounded,
      permission: AppPermissions.billingView,
      groupKey: 'subscriptions',
    ),
    PlatformNavigationDestination(
      id: 'sales',
      route: '/dashboard/sales',
      labelKey: 'sales',
      icon: Icons.trending_up_rounded,
      permission: AppPermissions.salesView,
      groupKey: 'finance',
    ),
    PlatformNavigationDestination(
      id: 'network_wallets',
      route: '/dashboard/network-wallets',
      labelKey: 'network_wallets',
      icon: Icons.account_balance_wallet_outlined,
      permission: AppPermissions.networkWalletsView,
      groupKey: 'finance',
    ),
    PlatformNavigationDestination(
      id: 'pos_wallets',
      route: '/dashboard/pos-wallets',
      labelKey: 'pos_wallets',
      icon: Icons.wallet_outlined,
      permission: AppPermissions.posWalletsView,
      groupKey: 'finance',
    ),
    PlatformNavigationDestination(
      id: 'expenses',
      route: '/dashboard/expenses',
      labelKey: 'expenses',
      icon: Icons.receipt_long_outlined,
      permission: AppPermissions.expensesView,
      groupKey: 'finance',
    ),
    PlatformNavigationDestination(
      id: 'bank_accounts',
      route: '/dashboard/bank-accounts',
      labelKey: 'bank_accounts',
      icon: Icons.account_balance_outlined,
      permission: AppPermissions.bankAccountsView,
      groupKey: 'finance',
    ),
    PlatformNavigationDestination(
      id: 'reports',
      route: '/dashboard/financial-reports',
      labelKey: 'reports',
      icon: Icons.query_stats_rounded,
      permission: AppPermissions.billingReport,
      groupKey: 'subscriptions',
    ),
    PlatformNavigationDestination(
      id: 'support_tickets',
      route: '/dashboard/support-tickets',
      labelKey: 'support_tickets',
      icon: Icons.support_agent_outlined,
      permission: AppPermissions.supportView,
      groupKey: 'support',
    ),
    PlatformNavigationDestination(
      id: 'notifications',
      route: '/dashboard/notifications',
      labelKey: 'notifications',
      icon: Icons.notifications_none_rounded,
      permission: AppPermissions.notificationsView,
      groupKey: 'support',
    ),
    PlatformNavigationDestination(
      id: 'send_notifications',
      route: '/dashboard/notification-management',
      labelKey: 'send_notifications',
      icon: Icons.campaign_outlined,
      permission: AppPermissions.notificationsCreate,
      groupKey: 'support',
    ),
    PlatformNavigationDestination(
      id: 'sessions',
      route: '/dashboard/sessions',
      labelKey: 'sessions',
      icon: Icons.devices_outlined,
      permission: AppPermissions.authView,
      groupKey: 'system',
    ),
    PlatformNavigationDestination(
      id: 'audit_logs',
      route: '/dashboard/audit-logs',
      labelKey: 'audit_logs',
      icon: Icons.policy_outlined,
      permission: AppPermissions.systemLogsView,
      groupKey: 'system',
    ),
    PlatformNavigationDestination(
      id: 'settings',
      route: '/dashboard/settings',
      labelKey: 'settings',
      icon: Icons.settings_outlined,
      permission: AppPermissions.settingsView,
      groupKey: 'system',
    ),
    PlatformNavigationDestination(
      id: 'backups',
      route: '/dashboard/backups',
      labelKey: 'backups',
      icon: Icons.backup_outlined,
      permission: '',
      groupKey: 'system',
      requiredRole: AppRoles.superAdmin,
    ),
    PlatformNavigationDestination(
      id: 'scheduled_tasks',
      route: '/dashboard/scheduled-tasks',
      labelKey: 'scheduled_tasks',
      icon: Icons.schedule_outlined,
      permission: '',
      groupKey: 'system',
      requiredRole: AppRoles.superAdmin,
    ),
  ];

  static bool canOpen(PlatformNavigationDestination destination) {
    if (destination.requiredRole != null &&
        !PermissionService.to.hasRole(destination.requiredRole!)) {
      return false;
    }
    return destination.permission.isEmpty ||
        PermissionService.to.can(destination.permission);
  }

  static String? routeForId(String id) {
    if (overview.id == id) return overview.route;
    for (final destination in destinations) {
      if (destination.id == id) return destination.route;
    }
    return null;
  }

  static DashboardNavigationSection build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grouped = <String, List<DashboardNavigationItem>>{};
    for (final destination in destinations) {
      if (!canOpen(destination)) continue;
      grouped
          .putIfAbsent(destination.groupKey!, () => [])
          .add(
            DashboardNavigationItem(
              id: destination.id,
              label: l10n.text(destination.labelKey),
              icon: destination.icon,
              selectedIcon: destination.icon,
              tooltip: l10n.text(destination.labelKey),
            ),
          );
    }
    final visibleGroups = <DashboardNavigationGroup>[];
    void addGroup(String id, String labelKey) {
      final items = grouped[id];
      if (items == null || items.isEmpty) return;
      visibleGroups.add(
        DashboardNavigationGroup(
          id: id,
          label: l10n.text(labelKey),
          items: items,
        ),
      );
    }

    addGroup('platform', 'platform_management');
    addGroup('subscriptions', 'subscriptions');
    addGroup('finance', 'finance');
    addGroup('support', 'support');
    addGroup('system', 'system');
    return DashboardNavigationSection(
      items: [
        DashboardNavigationItem(
          id: overview.id,
          label: l10n.text(overview.labelKey),
          icon: overview.icon,
          selectedIcon: Icons.space_dashboard_rounded,
          tooltip: l10n.text(overview.labelKey),
        ),
      ],
      groups: visibleGroups,
    );
  }
}
