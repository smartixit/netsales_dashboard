import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';

void main() {
  testWidgets('localization resolves Arabic and English labels from active locale', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('ar'),
      supportedLocales: [Locale('ar'), Locale('en')],
      home: _LocalizedProbe(),
    ));
    expect(find.text('نظرة عامة'), findsOneWidget);
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('en'),
      supportedLocales: [Locale('ar'), Locale('en')],
      home: _LocalizedProbe(),
    ));
    expect(find.text('Overview'), findsOneWidget);
  });
}

class _LocalizedProbe extends StatelessWidget {
  const _LocalizedProbe();
  @override
  Widget build(BuildContext context) => Text(AppLocalizations.of(context).text('overview'));
}
