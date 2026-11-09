import 'dart:typed_data';

import 'package:document_engine/document_engine.dart';
import 'package:flutter_test/flutter_test.dart';

final class _RecordingAdapter implements DocumentOutputAdapter {
  DocumentOutputRequest? saved;
  DocumentOutputRequest? shared;
  DocumentOutputRequest? printed;

  @override
  Future<DocumentOutputResult> save(DocumentOutputRequest request) async {
    saved = request;
    return const DocumentOutputSuccess(location: 'memory://saved');
  }

  @override
  Future<DocumentOutputResult> share(DocumentOutputRequest request) async {
    shared = request;
    return const DocumentOutputSuccess();
  }

  @override
  Future<DocumentOutputResult> print(DocumentOutputRequest request) async {
    printed = request;
    return const DocumentOutputSuccess(location: 'printer-1');
  }
}

DocumentArtifact _artifact() => DocumentArtifact(
  documentId: DocumentId('doc-1'),
  templateId: TemplateId('invoice.standard'),
  templateVersion: TemplateVersion(major: 1, minor: 0, patch: 0),
  schemaVersion: 1,
  rendererId: 'test',
  rendererVersion: '1',
  generatedAt: DateTime.utc(2026),
  bytes: Uint8List.fromList([37, 80, 68, 70]),
  pageCount: 1,
);

void main() {
  group('normalizePdfFileName', () {
    test('preserves Arabic and appends a single PDF extension', () {
      expect(normalizePdfFileName('فاتورة ١٢.pdf'), 'فاتورة ١٢.pdf');
    });

    test('removes invalid path characters and bounds the name', () {
      final result = normalizePdfFileName(r'../../Invoice:2026?.pdf')!;
      expect(result, isNot(contains('/')));
      expect(result, isNot(contains(':')));
      expect(result, endsWith('.pdf'));
      expect(result.length, lessThanOrEqualTo(120));
    });

    test('rejects empty names', () {
      expect(normalizePdfFileName('  '), isNull);
      expect(normalizePdfFileName('...'), isNull);
    });
  });

  test('save, share and print receive the same immutable artifact bytes', () async {
    final adapter = _RecordingAdapter();
    final coordinator = DocumentOutputCoordinator(adapter: adapter);
    final artifact = _artifact();

    expect(
      await coordinator.save(artifact: artifact, fileName: 'Invoice'),
      isA<DocumentOutputSuccess>(),
    );
    expect(
      await coordinator.share(artifact: artifact, fileName: 'Invoice'),
      isA<DocumentOutputSuccess>(),
    );
    expect(
      await coordinator.print(artifact: artifact, fileName: 'Invoice'),
      isA<DocumentOutputSuccess>(),
    );

    expect(adapter.saved!.artifact.sha256, artifact.sha256);
    expect(adapter.shared!.artifact.sha256, artifact.sha256);
    expect(adapter.printed!.artifact.sha256, artifact.sha256);
    expect(adapter.saved!.fileName, 'Invoice.pdf');
  });

  test('rejects empty artifacts before invoking the adapter', () async {
    final adapter = _RecordingAdapter();
    final coordinator = DocumentOutputCoordinator(adapter: adapter);
    final artifact = DocumentArtifact(
      documentId: DocumentId('doc-1'),
      templateId: TemplateId('invoice.standard'),
      templateVersion: TemplateVersion(major: 1, minor: 0, patch: 0),
      schemaVersion: 1,
      rendererId: 'test',
      rendererVersion: '1',
      generatedAt: DateTime.utc(2026),
      bytes: Uint8List(0),
    );

    final result = await coordinator.save(
      artifact: artifact,
      fileName: 'Invoice',
    );
    expect(result, isA<DocumentOutputFailure>());
    expect(adapter.saved, isNull);
  });
}
