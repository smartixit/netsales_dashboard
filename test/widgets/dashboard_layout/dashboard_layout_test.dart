import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/dashboard_layout.dart';

void main() {
  final navigation = DashboardNavigationSection(
    items: [DashboardNavigationItem(id: 'home', label: 'Home', icon: Icons.home_outlined)],
  );

  Widget buildApp(Widget home) => ScreenUtilInit(
    designSize: const Size(1440, 900),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) => MaterialApp(home: child),
    child: home,
  );

  testWidgets('renders content and selected navigation item', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildApp(
      DashboardShell(
        navigation: navigation,
        selectedNavigationId: 'home',
        onNavigationSelected: (_) {},
        sidebarHeader: const Text('Brand'),
        child: const Text('Dashboard content'),
      ),
    ));
    expect(find.text('Dashboard content'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Brand'), findsOneWidget);
  });

  testWidgets('auto-collapses on compact desktop and allows an explicit expand override', (tester) async {
    tester.view.physicalSize = const Size(1100, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool? collapsedOverride;
    Widget dashboard() => buildApp(
      DashboardShell(
        navigation: navigation,
        selectedNavigationId: 'home',
        onNavigationSelected: (_) {},
        sidebarCollapsed: collapsedOverride,
        onSidebarCollapsedChanged: (value) => collapsedOverride = value,
        child: const Text('Compact desktop content'),
      ),
    );

    await tester.pumpWidget(dashboard());
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.tap(find.byTooltip('Expand navigation'));
    await tester.pump();
    expect(collapsedOverride, isFalse);

    await tester.pumpWidget(dashboard());
    expect(find.byTooltip('Collapse navigation'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('uses drawer navigation at compact width', (tester) async {
    tester.view.physicalSize = const Size(700, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildApp(
      DashboardShell(
        navigation: navigation,
        selectedNavigationId: 'home',
        onNavigationSelected: (_) {},
        child: const Text('Compact content'),
      ),
    ));
    expect(find.text('Compact content'), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
  });
}
