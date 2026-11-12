import 'package:document_engine/document_engine.dart';
import 'package:document_engine/document_engine_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PayvTextShapingProvider provider;

  setUpAll(() async {
    provider = PayvTextShapingProvider(
      await loadDocumentEngineArabicFont(),
      languageTag: 'ar-YE',
    );
  });

  test('paragraph creates measured shaped line widgets', () {
    final paragraph = ShapedPdfParagraph(
      text: 'فاتورة مبيعات INV-2026/0017 تتضمن أصنافاً متعددة '
          'ومبالغ بعملات YER و USD.',
      provider: provider,
      width: 180,
      fontSize: 10,
      direction: DocumentTextDirection.rightToLeft,
    );

    final widget = paragraph.build(
      pw.Context(
        document: pw.Document(),
        page: pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.SizedBox(),
        ).build(pw.Context(document: pw.Document())),
      ),
    );

    expect(widget, isA<pw.Column>());
  });

  test('paragraph rejects invalid geometry instead of clipping', () {
    expect(
      () => ShapedPdfParagraph(
        text: 'نص',
        provider: provider,
        width: 0,
        fontSize: 10,
      ),
      throwsArgumentError,
    );
  });
}
