@TestOn('browser')
library;

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payv/payv.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Payv creates a small Arabic PDF in a browser runtime',
    () async {
      final fontData = await rootBundle.load(
        'assets/fonts/IBMPlexSansArabic-Regular.ttf',
      );
      final fontBytes = Uint8List.sublistView(fontData);
      final font = PayvFont.load(fontBytes);
      final document = PayvDocument(
        title: 'Payv browser smoke test',
        language: 'ar',
      );
      final page = document.addPage(format: PageFormat.a4);
      page.text(
        'اختبار PDF عربي — Invoice INV-2026/0017',
        x: page.width - 48,
        y: page.height - 80,
        style: TextStyle(font: font.weight(400), size: 12),
        direction: PayvTextDirection.rtl,
      );

      final bytes = document.save();
      expect(bytes.length, greaterThan(1000));
      expect(bytes.take(5), <int>[37, 80, 68, 70, 45]);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
