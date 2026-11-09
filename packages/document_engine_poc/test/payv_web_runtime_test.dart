@TestOn('browser')
library;

import 'dart:typed_data';

import 'package:document_engine_poc/document_engine_poc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Payv shapes Arabic and creates PDF bytes in a browser runtime', () async {
    final fontData = await rootBundle.load(
      'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    );
    final fontBytes = Uint8List.sublistView(fontData);

    final bytes = buildPayvSpecimen(fontBytes);

    expect(bytes.length, greaterThan(1000));
    expect(bytes.take(5), <int>[37, 80, 68, 70, 45]);
    expect(bytes, contains(37));
  });
}
