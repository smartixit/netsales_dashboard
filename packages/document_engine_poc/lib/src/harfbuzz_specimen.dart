import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_text_shaper/pdf_text_shaper.dart';

import 'corpus.dart';

Future<Uint8List> buildHarfBuzzSpecimen({
  required Uint8List arabicFontBytes,
  required Uint8List fallbackFontBytes,
}) async {
  final arabic = ShapedFont.fromBytes(
    arabicFontBytes,
    name: 'IBM Plex Sans Arabic',
  );
  final fallback = ShapedFont.fromBytes(
    fallbackFontBytes,
    name: 'Vazirmatn fallback',
  );

  try {
    final style = ShapedTextStyle(
      font: arabic,
      fallbackFonts: <ShapedFont>[fallback],
      fontSize: 10.5,
      lineHeight: 1.35,
      direction: ShapedTextDirection.auto,
      align: ShapedTextAlign.start,
      preserveUnicodeText: true,
    );

    final document = pw.Document(
      compress: true,
      title: 'HarfBuzz Arabic PDF typography POC',
      creator: 'document_engine_poc',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(42),
        header: (context) => pw.Text(
          'HarfBuzz / pdf_text_shaper 1.1.1',
          style: const pw.TextStyle(fontSize: 8),
        ),
        footer: (context) => pw.Text(
          'HarfBuzz page ${context.pageNumber}',
          style: const pw.TextStyle(fontSize: 8),
        ),
        build: (context) => <pw.Widget>[
          pw.Text(
            'Arabic and mixed-direction shaping — candidate B',
            style: const pw.TextStyle(fontSize: 16),
          ),
          ShapedText(ArabicPdfCorpus.arabicJoining, style: style),
          ShapedText(ArabicPdfCorpus.lamAlefForms, style: style),
          ...ArabicPdfCorpus.glyphMappedCases.map(
            (value) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: ShapedText(value, style: style, language: 'ar'),
            ),
          ),
          ...ArabicPdfCorpus.longParagraph.split('\n\n').map(
            (paragraph) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: ShapedText(paragraph, style: style, language: 'ar'),
            ),
          ),
          ShapedText(ArabicPdfCorpus.longTableCell, style: style, language: 'ar'),
        ],
      ),
    );

    return Uint8List.fromList(await document.save());
  } finally {
    arabic.dispose();
    fallback.dispose();
  }
}
