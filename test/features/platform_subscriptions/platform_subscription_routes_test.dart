import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/routing/app_pages.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/routing/middlewares/auth_guard.dart';

void main() {
  test('subscription workspaces are real nested routes with bindings and view permission', () {
    final dashboard = AppPages.routes.singleWhere((route) => route.name == AppRoutes.dashboard);
    const expected = <String>[
      '/subscription-plans',
      '/provider-subscriptions',
      '/subscription-requests',
    ];

    for (final routeName in expected) {
      final route = dashboard.children.singleWhere((item) => item.name == routeName);
      expect(route.binding, isNotNull);
      final guards = (route.middlewares ?? const <GetMiddleware>[]).whereType<PermissionGuardMiddleware>();
      expect(guards.single.requiredPermission, AppPermissions.subscriptionsView);
      expect(route.page, isNotNull);
    }
  });
}
