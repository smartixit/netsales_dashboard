import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'corpus.dart';

/// Candidate A baseline: pdf with an embedded TTF and explicit RTL direction,
/// but without a dedicated OpenType shaping provider.
Future<Uint8List> buildPlainPdfSpecimen(Uint8List fontBytes) async {
  final font = pw.Font.ttf(ByteData.sublistView(fontBytes));
  final document = pw.Document(
    compress: true,
    title: 'Plain PDF Arabic baseline',
    creator: 'document_engine_poc',
  );

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(42),
      header: (context) => pw.Text(
        'Arabic PDF baseline — pdf package only',
        style: pw.TextStyle(font: font, fontSize: 8),
      ),
      footer: (context) => pw.Text(
        'Baseline page ' + context.pageNumber.toString(),
        style: pw.TextStyle(font: font, fontSize: 8),
      ),
      build: (context) => <pw.Widget>[
        pw.Text(
          'Plain PDF baseline / no explicit shaping',
          style: pw.TextStyle(font: font, fontSize: 17),
        ),
        pw.SizedBox(height: 12),
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Text(
            ArabicPdfCorpus.joiningAndDiacritics,
            textAlign: pw.TextAlign.start,
            style: pw.TextStyle(font: font, fontSize: 15),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Text(
            ArabicPdfCorpus.lamAlefForms,
            textAlign: pw.TextAlign.start,
            style: pw.TextStyle(font: font, fontSize: 15),
          ),
        ),
        pw.SizedBox(height: 10),
        ...ArabicPdfCorpus.glyphMappedCases.map(
          (value) => pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                value,
                textAlign: pw.TextAlign.start,
                style: pw.TextStyle(font: font, fontSize: 10),
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        ...ArabicPdfCorpus.longParagraph.split('\n\n').map(
          (paragraph) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(
                paragraph,
                textAlign: pw.TextAlign.start,
                style: pw.TextStyle(font: font, fontSize: 9),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  return Uint8List.fromList(await document.save());
}
