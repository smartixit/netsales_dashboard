import 'package:document_engine_poc/document_engine_poc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fixed corpus covers Arabic, mixed direction, digits and identifiers', () {
    expect(ArabicPdfCorpus.cases.length, greaterThanOrEqualTo(12));
    expect(ArabicPdfCorpus.joiningAndDiacritics, contains('اللَّهِ'));
    expect(ArabicPdfCorpus.lamAlefForms, contains('لا'));
    expect(ArabicPdfCorpus.invoiceReference, contains('INV-2026/0017'));
    expect(ArabicPdfCorpus.suppliedAmounts, contains('1,250.50'));
    expect(ArabicPdfCorpus.arabicIndicDigits, contains('١'));
    expect(ArabicPdfCorpus.uuid, contains('550e8400-e29b-41d4-a716-446655440000'));
    expect(ArabicPdfCorpus.longParagraph.split('\n\n').length, 42);
    expect(ArabicPdfCorpus.tableRows.length, greaterThanOrEqualTo(18));
  });
}
