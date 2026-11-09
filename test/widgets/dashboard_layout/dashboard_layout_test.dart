import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/core/themes/dashboard_layout_theme.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/adapters/netsales_dashboard_theme_adapter.dart';
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
    expect(
      find.byKey(
        const ValueKey<String>('dashboard-navigation-active-indicator-home'),
      ),
      findsOneWidget,
    );
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


  testWidgets('theme adapter preserves extensions and replaces layout theme', (
    tester,
  ) async {
    const retainedExtension = _RetainedThemeExtension();
    const originalLayoutTheme = DashboardLayoutTheme(
      sidebarBackground: Colors.black,
      sidebarForeground: Colors.white,
      sidebarMuted: Colors.grey,
      sidebarSelectedBackground: Colors.blue,
      sidebarSelectedForeground: Colors.white,
      sidebarHoverBackground: Colors.black12,
      topbarBackground: Colors.black,
      contentBackground: Colors.black,
      border: Colors.white,
      badgeBackground: Colors.blue,
      badgeForeground: Colors.white,
      itemRadius: 99,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            retainedExtension,
            originalLayoutTheme,
          ],
        ),
        home: Builder(
          builder: (context) => NetSalesDashboardThemeAdapter.wrap(
            context: context,
            child: Builder(
              builder: (wrappedContext) {
                final theme = Theme.of(wrappedContext);
                expect(
                  theme.extension<_RetainedThemeExtension>(),
                  same(retainedExtension),
                );

                final layoutTheme = theme.extension<DashboardLayoutTheme>();
                expect(layoutTheme, isNotNull);
                expect(layoutTheme, isNot(same(originalLayoutTheme)));
                expect(layoutTheme!.itemRadius, isNot(99));

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
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

  
class _RetainedThemeExtension extends ThemeExtension<_RetainedThemeExtension> {
  const _RetainedThemeExtension();

  @override
  _RetainedThemeExtension copyWith() => this;

  @override
  _RetainedThemeExtension lerp(
    ThemeExtension<_RetainedThemeExtension>? other,
    double t,
  ) => this;
}
