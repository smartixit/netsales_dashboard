import 'dart:typed_data';

import 'package:payv/payv.dart';

import 'corpus.dart';

Uint8List buildPayvSpecimen(Uint8List fontBytes) {
  final font = PayvFont.load(fontBytes);
  if (!font.canEmbedInPdf) {
    throw StateError('Font embedding forbidden.');
  }

  final regular = font.weight(400);
  final body = TextStyle(font: regular, size: 9.5, lineHeight: 13, language: 'ar');
  final small = TextStyle(font: regular, size: 8, lineHeight: 11, language: 'ar');
  final heading = TextStyle(font: regular, size: 18, lineHeight: 23, language: 'ar');
  final numeric = TextStyle(
    font: regular,
    size: 8,
    lineHeight: 11,
    language: 'en',
    features: const <FontFeature>[FontFeature.tabularFigures],
  );

  final document = PayvDocument(
    title: 'Arabic PDF typography POC',
    author: 'NetSales Dashboard',
    creator: 'document_engine_poc',
    language: 'ar',
  );

  PayvPage newPage(String title, int number) {
    final page = document.addPage(format: PageFormat.a4);
    page.text(title,
      x: page.width - 44,
      y: page.height - 48,
      style: heading,
      direction: PayvTextDirection.rtl,
    );
    page.text('M4 POC | Page ' + number.toString(),
      x: 44,
      y: page.height - 48,
      style: small,
      direction: PayvTextDirection.ltr,
    );
    page.graphics
      ..setStrokeColor(const PdfColor.gray(0.78))
      ..setLineWidth(0.6)
      ..moveTo(44, page.height - 62)
      ..lineTo(page.width - 44, page.height - 62)
      ..stroke();
    return page;
  }

  var pageNumber = 1;
  var page = newPage('اختبار تشكيل النص العربي واتجاهه', pageNumber);
  var y = page.height - 104;

  for (final value in ArabicPdfCorpus.cases) {
    final remainder = page.textBox(
      value,
      rect: PdfRect(48, y - 30, page.width - 96, 26),
      style: body,
      align: PayvTextAlign.start,
      direction: PayvTextDirection.auto,
    );
    if (remainder != null) {
      throw StateError('A corpus line did not fit its allocated box.');
    }
    y -= 39;
  }

  String? remaining = ArabicPdfCorpus.longParagraph;
  while (remaining != null && remaining.isNotEmpty) {
    if (pageNumber >= 12) {
      throw StateError('Long text exceeded the page budget.');
    }
    pageNumber++;
    page = newPage('اختبار التفاف الفقرات الطويلة', pageNumber);
    final previous = remaining;
    remaining = page.textBox(
      previous,
      rect: PdfRect(48, 72, page.width - 96, page.height - 170),
      style: body,
      align: PayvTextAlign.start,
      direction: PayvTextDirection.auto,
    );
    if (remaining == previous) {
      throw StateError('Payv did not consume text.');
    }
  }

  pageNumber++;
  page = newPage('اختبار التفاف خلايا الجدول', pageNumber);
  const rowHeight = 34.0;
  var rowTop = page.height - 94;

  for (final row in ArabicPdfCorpus.tableRows) {
    if (rowTop - rowHeight < 55) {
      pageNumber++;
      page = newPage('استكمال جدول الاختبار', pageNumber);
      rowTop = page.height - 90;
    }
    final bottom = rowTop - rowHeight;
    page.graphics
      ..setStrokeColor(const PdfColor.gray(0.86))
      ..setLineWidth(0.35)
      ..moveTo(44, rowTop)
      ..lineTo(page.width - 44, rowTop)
      ..stroke();

    final overflow = page.textBox(
      row.$1,
      rect: PdfRect(44, bottom + 3, 286, rowHeight - 5),
      style: small,
      align: PayvTextAlign.start,
      direction: PayvTextDirection.auto,
    );
    if (overflow != null) {
      throw StateError('A table description overflowed its cell.');
    }

    page.textBox(
      row.$2,
      rect: PdfRect(350, bottom + 3, 76, rowHeight - 5),
      style: small,
      align: PayvTextAlign.end,
      direction: PayvTextDirection.ltr,
    );
    page.textBox(
      row.$3,
      rect: PdfRect(438, bottom + 3, 112, rowHeight - 5),
      style: numeric,
      align: PayvTextAlign.end,
      direction: PayvTextDirection.ltr,
    );
    rowTop = bottom;
  }

  return document.save();
}
