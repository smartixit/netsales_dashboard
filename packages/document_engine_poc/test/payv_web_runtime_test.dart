@TestOn('browser')
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payv/payv.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Payv creates an Arabic and Latin PDF in a browser runtime',
    () async {
      final fontData = await rootBundle
          .load('assets/fonts/Vazirmatn-Regular.ttf')
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException(
              'The Web test could not load the Vazirmatn font asset.',
            ),
          );
      final fontBytes = Uint8List.sublistView(fontData);
      expect(fontBytes.length, greaterThan(10000));

      // Use the smaller OFL fixture for the browser runtime smoke test. The
      // full IBM Plex fixture remains in the native cross-candidate corpus.
      final font = PayvFont.load(fontBytes);
      final document = PayvDocument(
        title: 'Payv browser Arabic PDF smoke test',
        language: 'ar',
      );
      final page = document.addPage(format: PageFormat.a4);
      final remainder = page.textBox(
        'فاتورة Invoice INV-26',
        rect: PdfRect(48, page.height - 120, page.width - 96, 48),
        style: TextStyle(
          font: font.weight(400),
          size: 12,
          lineHeight: 16,
        ),
        align: PayvTextAlign.start,
        direction: PayvTextDirection.auto,
      );
      expect(remainder, isNull);

      final bytes = document.save();
      expect(bytes.length, greaterThan(1000));
      expect(bytes.take(5), <int>[37, 80, 68, 70, 45]);
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
