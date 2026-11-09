import '../rendering/document_render_result.dart';

/// The output operation requested by a host application.
enum DocumentOutputOperation { save, share, print }

/// Stable failure categories for document output operations.
enum DocumentOutputFailureCode {
  emptyArtifact,
  invalidFileName,
  unsupported,
  alreadyRunning,
  adapterFailure,
}

/// Result returned by a platform output adapter.
sealed class DocumentOutputResult {
  const DocumentOutputResult();
}

final class DocumentOutputSuccess extends DocumentOutputResult {
  const DocumentOutputSuccess({this.location});

  /// Optional destination path, URI, or printer identifier.
  final String? location;
}

final class DocumentOutputFailure extends DocumentOutputResult {
  const DocumentOutputFailure({
    required this.code,
    required this.message,
    this.isRetryable = false,
  });

  final DocumentOutputFailureCode code;
  final String message;
  final bool isRetryable;
}

/// Immutable request passed to save/share/print adapters.
final class DocumentOutputRequest {
  const DocumentOutputRequest({
    required this.artifact,
    required this.fileName,
  });

  final DocumentArtifact artifact;
  final String fileName;
}

/// Host-owned platform boundary. Implementations may use native APIs,
/// application services, or test doubles; this package performs no I/O.
abstract interface class DocumentOutputAdapter {
  Future<DocumentOutputResult> save(DocumentOutputRequest request);

  Future<DocumentOutputResult> share(DocumentOutputRequest request);

  Future<DocumentOutputResult> print(DocumentOutputRequest request);
}

/// Coordinates output actions without regenerating or mutating the artifact.
final class DocumentOutputCoordinator {
  DocumentOutputCoordinator({required DocumentOutputAdapter adapter})
    : _adapter = adapter;

  final DocumentOutputAdapter _adapter;
  final Set<DocumentOutputOperation> _running = {};

  bool isRunning(DocumentOutputOperation operation) =>
      _running.contains(operation);

  Future<DocumentOutputResult> save({
    required DocumentArtifact artifact,
    required String fileName,
  }) => _run(DocumentOutputOperation.save, artifact, fileName);

  Future<DocumentOutputResult> share({
    required DocumentArtifact artifact,
    required String fileName,
  }) => _run(DocumentOutputOperation.share, artifact, fileName);

  Future<DocumentOutputResult> print({
    required DocumentArtifact artifact,
    required String fileName,
  }) => _run(DocumentOutputOperation.print, artifact, fileName);

  Future<DocumentOutputResult> _run(
    DocumentOutputOperation operation,
    DocumentArtifact artifact,
    String requestedName,
  ) async {
    if (artifact.byteLength == 0) {
      return const DocumentOutputFailure(
        code: DocumentOutputFailureCode.emptyArtifact,
        message: 'The document artifact is empty.',
      );
    }
    final fileName = normalizePdfFileName(requestedName);
    if (fileName == null) {
      return const DocumentOutputFailure(
        code: DocumentOutputFailureCode.invalidFileName,
        message: 'A valid PDF file name is required.',
      );
    }
    if (!_running.add(operation)) {
      return const DocumentOutputFailure(
        code: DocumentOutputFailureCode.alreadyRunning,
        message: 'This output operation is already running.',
        isRetryable: true,
      );
    }

    try {
      final request = DocumentOutputRequest(
        artifact: artifact,
        fileName: fileName,
      );
      return switch (operation) {
        DocumentOutputOperation.save => await _adapter.save(request),
        DocumentOutputOperation.share => await _adapter.share(request),
        DocumentOutputOperation.print => await _adapter.print(request),
      };
    } catch (_) {
      return const DocumentOutputFailure(
        code: DocumentOutputFailureCode.adapterFailure,
        message: 'The document could not be sent to the selected output.',
        isRetryable: true,
      );
    } finally {
      _running.remove(operation);
    }
  }
}

/// Produces a safe, bounded PDF filename while preserving Arabic and other
/// Unicode letters. Returns null when no meaningful filename remains.
String? normalizePdfFileName(String value) {
  var name = value.trim();
  if (name.isEmpty) return null;
  name = name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
  name = name.replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), '_');
  name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
  name = name.replaceAll(RegExp(r'^[. ]+|[. ]+$'), '');
  if (name.isEmpty) return null;
  if (name.length > 116) name = name.substring(0, 116).trim();
  if (name.isEmpty) return null;
  return '$name.pdf';
}
