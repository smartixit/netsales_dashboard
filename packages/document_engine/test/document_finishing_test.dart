import 'dart:typed_data';

import 'package:document_engine/document_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QR payload is opaque and bounded', () {
    final qr = DocumentQrCode(payload: 'https://verify.example/d/opaque-id');
    expect(qr.payload, 'https://verify.example/d/opaque-id');
    expect(qr.sizePoints, 96);
    expect(
      () => DocumentQrCode(payload: ' '),
      throwsArgumentError,
    );
    expect(
      () => DocumentQrCode(payload: 'x' * 2049),
      throwsArgumentError,
    );
  });

  test('signature image bytes are defensively copied', () {
    final source = Uint8List.fromList([1, 2, 3]);
    final signature = DocumentSignatureArea(
      label: 'Authorized by',
      signerName: 'Example User',
      roleLabel: 'Finance Manager',
      approvalReference: 'APR-2026-01',
      approvedAt: DateTime.utc(2026),
      visualSignatureBytes: source,
    );
    source[0] = 99;
    expect(signature.visualSignatureBytes, [1, 2, 3]);
    final copy = signature.visualSignatureBytes!;
    copy[1] = 99;
    expect(signature.visualSignatureBytes, [1, 2, 3]);
  });

  test('watermark is bounded presentation metadata', () {
    final watermark = DocumentWatermark(
      text: 'DRAFT',
      opacity: 0.1,
    );
    expect(watermark.text, 'DRAFT');
    expect(
      () => DocumentWatermark(text: 'DRAFT', opacity: 0.9),
      throwsArgumentError,
    );
  });

  test('receipt profiles express explicit fixed-height PDF geometry', () {
    final narrow = DocumentPageProfile.receipt58mm(heightPoints: 420);
    final wide = DocumentPageProfile.receipt80mm(heightPoints: 500);
    expect(narrow.widthPoints, closeTo(164.4, 0.2));
    expect(wide.widthPoints, closeTo(226.8, 0.2));
    expect(narrow.heightPoints, 420);
    expect(
      () => DocumentPageProfile.receipt58mm(heightPoints: 100),
      throwsArgumentError,
    );
  });
}
