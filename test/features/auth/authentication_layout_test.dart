import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/themes/app_themes.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';

void main() {
  const scenarios = <({
    Size size,
    Brightness brightness,
    TextDirection direction,
  })>[
    (
      size: Size(900, 620),
      brightness: Brightness.light,
      direction: TextDirection.rtl,
    ),
    (
      size: Size(1040, 720),
      brightness: Brightness.light,
      direction: TextDirection.rtl,
    ),
    (
      size: Size(1440, 900),
      brightness: Brightness.dark,
      direction: TextDirection.ltr,
    ),
    (
      size: Size(1920, 1080),
      brightness: Brightness.dark,
      direction: TextDirection.rtl,
    ),
    (
      size: Size(880, 720),
      brightness: Brightness.light,
      direction: TextDirection.ltr,
    ),
  ];

  for (final scenario in scenarios) {
    testWidgets(
      'authentication layout is overflow-safe at ${scenario.size.width.toInt()}x${scenario.size.height.toInt()}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = scenario.size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(Get.reset);

        await tester.pumpWidget(
          GetMaterialApp(
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: scenario.brightness == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Directionality(
              textDirection: scenario.direction,
              child: AuthScaffold(
                icon: Icons.shield_rounded,
                title: 'مرحباً بك مجدداً',
                subtitle: 'سجّل الدخول إلى لوحة التحكم الإدارية.',
                child: const SizedBox(
                  height: 420,
                  child: Center(child: Text('نموذج تسجيل الدخول')),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('مرحباً بك مجدداً'), findsOneWidget);
        expect(find.text('نموذج تسجيل الدخول'), findsOneWidget);
        expect(
          find.text('NETSALES PLATFORM • DESKTOP EDITION'),
          scenario.size.width >= AppBreakpoints.tabletMax
              ? findsOneWidget
              : findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
