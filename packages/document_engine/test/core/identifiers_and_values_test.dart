import 'package:document_engine/document_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Stable identifiers', () {
    test('accept valid identifiers and preserve value equality', () {
      expect(DocumentId('doc:2026-001'), DocumentId('doc:2026-001'));
      expect(
        TemplateId('sales.invoice.standard').value,
        'sales.invoice.standard',
      );
    });

    test('rejects empty, padded, oversized, and unsupported characters', () {
      for (final value in ['', ' padded', 'bad value', 'a/b', 'a' * 129]) {
        expect(() => DocumentTypeId(value), throwsArgumentError);
      }
    });
  });

  group('TemplateVersion', () {
    test('compares major, minor, and patch numerically', () {
      final versions = [
        TemplateVersion(major: 1, minor: 10, patch: 0),
        TemplateVersion(major: 1, minor: 2, patch: 10),
        TemplateVersion(major: 1, minor: 2, patch: 2),
        TemplateVersion(major: 2, minor: 0, patch: 0),
      ]..sort();

      expect(versions.map((version) => version.toString()), [
        '1.2.2',
        '1.2.10',
        '1.10.0',
        '2.0.0',
      ]);
    });

    test('rejects negative components', () {
      expect(
        () => TemplateVersion(major: -1, minor: 0, patch: 0),
        throwsArgumentError,
      );
    });
  });

  group('DocumentDecimalValue', () {
    test('preserves canonical decimal strings without floating conversion', () {
      final value = DocumentDecimalValue('12345678901234567890.123400');
      expect(value.value, '12345678901234567890.123400');
    });

    test('rejects exponent, grouping, leading zero and malformed values', () {
      for (final value in ['1e3', '1,000.00', '01.20', '.5', '1.', '--2']) {
        expect(() => DocumentDecimalValue(value), throwsArgumentError);
      }
    });
  });
}
