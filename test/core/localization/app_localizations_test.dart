import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';

void main() {
  testWidgets('localization resolves Arabic and English labels from active locale', (tester) async {
    Widget app(Locale locale) => MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const _LocalizedProbe(),
    );
    await tester.pumpWidget(app(const Locale('ar')));
    expect(find.text('نظرة عامة'), findsOneWidget);
    await tester.pumpWidget(app(const Locale('en')));
    expect(find.text('Overview'), findsOneWidget);
  });
}

class _LocalizedProbe extends StatelessWidget {
  const _LocalizedProbe();
  @override
  Widget build(BuildContext context) => Text(AppLocalizations.of(context).text('overview'));
}
