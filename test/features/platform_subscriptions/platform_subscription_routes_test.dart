import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/core/routing/app_pages.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/routing/middlewares/auth_guard.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/presentation/screens/platform_subscriptions_screen.dart';

void main() {
  test('subscription workspaces are real nested routes with bindings and view permission', () {
    final dashboard = AppPages.routes.singleWhere((route) => route.name == AppRoutes.dashboard);
    final expected = <String, SubscriptionWorkspaceSection>{
      '/subscription-plans': SubscriptionWorkspaceSection.plans,
      '/provider-subscriptions': SubscriptionWorkspaceSection.subscriptions,
      '/subscription-requests': SubscriptionWorkspaceSection.requests,
    };

    for (final entry in expected.entries) {
      final route = dashboard.children.singleWhere((item) => item.name == entry.key);
      expect(route.binding, isNotNull);
      final guards = (route.middlewares ?? const <GetMiddleware>[]).whereType<PermissionGuardMiddleware>();
      expect(guards.single.requiredPermission, AppPermissions.subscriptionsView);
      expect(route.page, isNotNull);
    }
  });
}
