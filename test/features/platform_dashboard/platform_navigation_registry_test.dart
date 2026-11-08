import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/routing/app_pages.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/routing/middlewares/auth_guard.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';

void main() {
  late PermissionService permissions;
  setUp(() {
    Get.testMode = true;
    permissions = PermissionService.instance;
    permissions.clear();
    Get.put<PermissionService>(permissions, permanent: true);
  });
  tearDown(() {
    permissions.clear();
    Get.reset();
    Get.testMode = false;
  });

  PlatformNavigationDestination destination(String id) =>
      PlatformNavigationRegistry.destinations.singleWhere((item) => item.id == id);

  test('support agent navigation follows the seeded platform permissions', () {
    permissions.updateAccess(
      roleKey: AppRoles.supportAgent,
      permissions: const [
        AppPermissions.usersView,
        AppPermissions.networksView,
        AppPermissions.posView,
        AppPermissions.supportView,
        AppPermissions.notificationsView,
        AppPermissions.notificationsCreate,
      ],
    );
    expect(PlatformNavigationRegistry.canOpen(destination('users')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('networks')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('pos')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('support_tickets')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('notifications')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('send_notifications')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('roles')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('subscription_plans')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('sales')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('audit_logs')), isFalse);
  });

  test('platform accountant navigation follows the exact seeded permissions', () {
    permissions.updateAccess(
      roleKey: AppRoles.accountant,
      permissions: const [
        AppPermissions.networksView,
        AppPermissions.posView,
        AppPermissions.networkWalletsView,
        AppPermissions.posWalletsView,
        AppPermissions.salesView,
        AppPermissions.salesReport,
        AppPermissions.expensesView,
        AppPermissions.subscriptionsView,
        AppPermissions.bankAccountsView,
        AppPermissions.notificationsView,
      ],
    );
    expect(PlatformNavigationRegistry.canOpen(destination('networks')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('pos')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('sales')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('network_wallets')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('pos_wallets')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('subscription_requests')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('bank_accounts')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('support_tickets')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('notifications')), isTrue);
    expect(PlatformNavigationRegistry.canOpen(destination('users')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('roles')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('sessions')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('audit_logs')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('backups')), isFalse);
    expect(PlatformNavigationRegistry.canOpen(destination('scheduled_tasks')), isFalse);
  });

  test('super administrator can access every registered navigation destination', () {
    permissions.updateAccess(roleKey: AppRoles.superAdmin, permissions: const []);
    for (final item in PlatformNavigationRegistry.destinations) {
      expect(PlatformNavigationRegistry.canOpen(item), isTrue, reason: 'Expected SUPER_ADMIN to access ${item.id}');
    }
  });

  test('dashboard shell is restricted to platform roles', () {
    final dashboardPage = AppPages.routes.singleWhere(
      (page) => page.name == AppRoutes.dashboard,
    );
    final roleGuards = dashboardPage.middlewares
        .whereType<PermissionGuardMiddleware>()
        .where((guard) => guard.anyRoles != null)
        .toList(growable: false);

    expect(roleGuards, hasLength(1));
    expect(
      roleGuards.single.anyRoles,
      containsAll([
        AppRoles.superAdmin,
        AppRoles.supportAgent,
        AppRoles.accountant,
      ]),
    );
  });

  test('all registered destinations resolve to nested GetX routes', () {
    expect(PlatformNavigationRegistry.routeForId('overview'), AppRoutes.overview);
    for (final item in PlatformNavigationRegistry.destinations) {
      expect(PlatformNavigationRegistry.routeForId(item.id), item.route);
    }
    final dashboardPage = AppPages.routes.singleWhere((page) => page.name == AppRoutes.dashboard);
    final childPaths = dashboardPage.children.map((page) => page.name).toSet();
    for (final item in PlatformNavigationRegistry.destinations) {
      expect(childPaths, contains(item.route.replaceFirst(AppRoutes.dashboard, '')), reason: 'Missing child route for ${item.id}');
    }
  });
}
