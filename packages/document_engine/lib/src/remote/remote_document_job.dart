import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;

import '../core/document_id.dart';
import '../core/template_id.dart';
import '../core/template_version.dart';
import '../rendering/document_render_result.dart';
import '../reports/report_id.dart';

/// Server-owned asynchronous document generation state.
enum RemoteDocumentJobStatus {
  queued,
  running,
  succeeded,
  failed,
  expired,
  cancelled;

  static RemoteDocumentJobStatus fromWire(String value) =>
      switch (value) {
        'QUEUED' => queued,
        'RUNNING' => running,
        'SUCCEEDED' => succeeded,
        'FAILED' => failed,
        'EXPIRED' => expired,
        'CANCELLED' => cancelled,
        _ => throw FormatException('Unknown remote document job status.'),
      };

  String get wireValue => switch (this) {
    queued => 'QUEUED',
    running => 'RUNNING',
    succeeded => 'SUCCEEDED',
    failed => 'FAILED',
    expired => 'EXPIRED',
    cancelled => 'CANCELLED',
  };
}

/// Host-supplied report execution request. Tenant identity and permissions are
/// deliberately absent: the authenticated backend context determines scope.
final class RemoteDocumentJobRequest {
  RemoteDocumentJobRequest({
    required this.reportId,
    required this.reportSchemaVersion,
    required this.idempotencyKey,
    required this.correlationId,
    required Map<String, Object?> payload,
  }) : payload = _immutableJsonMap(payload) {
    if (reportSchemaVersion < 1) {
      throw ArgumentError.value(
        reportSchemaVersion,
        'reportSchemaVersion',
        'Must be positive.',
      );
    }
    _validateOpaqueKey(idempotencyKey, 'idempotencyKey');
    _validateOpaqueKey(correlationId, 'correlationId');
  }

  final ReportId reportId;
  final int reportSchemaVersion;
  final String idempotencyKey;
  final String correlationId;

  /// Criteria and presentation payload only; never report result rows,
  /// authentication tokens, signed URLs, or permission grants.
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() => {
    'report_id': reportId.value,
    'report_schema_version': reportSchemaVersion,
    'idempotency_key': idempotencyKey,
    'correlation_id': correlationId,
    'payload': payload,
  };
}

final class RemoteDocumentJobId {
  RemoteDocumentJobId(String value) : value = _requiredText(value, 'jobId');
  final String value;
  @override
  String toString() => value;
}

/// Submission receipt returned after the backend durably records a job.
final class RemoteDocumentJobReceipt {
  const RemoteDocumentJobReceipt({
    required this.jobId,
    required this.status,
    required this.submittedAt,
    this.pollAfterSeconds,
  }) : assert(pollAfterSeconds == null || pollAfterSeconds > 0);

  final RemoteDocumentJobId jobId;
  final RemoteDocumentJobStatus status;
  final DateTime submittedAt;
  final int? pollAfterSeconds;
}

/// Metadata for a private, server-issued artifact. No public or signed URL is
/// stored here; retrieval must go through an authenticated host adapter.
final class RemoteDocumentArtifactMetadata {
  RemoteDocumentArtifactMetadata({
    required this.artifactId,
    required this.documentId,
    required this.documentType,
    required this.revision,
    required this.schemaVersion,
    required this.officialDocumentId,
    required this.templateId,
    required this.templateVersion,
    required this.rendererId,
    required this.rendererVersion,
    required this.generatedAt,
    required this.sha256,
    required this.byteLength,
    required this.fileName,
    this.pageCount,
    this.expiresAt,
  }) {
    _requiredText(artifactId, 'artifactId');
    _requiredText(documentType, 'documentType');
    _requiredText(officialDocumentId, 'officialDocumentId');
    _requiredText(rendererId, 'rendererId');
    _requiredText(rendererVersion, 'rendererVersion');
    _requiredText(fileName, 'fileName');
    if (revision < 1 || schemaVersion < 1 || byteLength < 1 ||
        (pageCount != null && pageCount! < 1)) {
      throw ArgumentError('Invalid remote artifact metadata bounds.');
    }
    if (!RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(sha256)) {
      throw ArgumentError.value(sha256, 'sha256', 'Expected a SHA-256 hex digest.');
    }
  }

  final String artifactId;
  final DocumentId documentId;
  final String documentType;
  final int revision;
  final int schemaVersion;
  final String officialDocumentId;
  final TemplateId templateId;
  final TemplateVersion templateVersion;
  final String rendererId;
  final String rendererVersion;
  final DateTime generatedAt;
  final String sha256;
  final int byteLength;
  final String fileName;
  final int? pageCount;
  final DateTime? expiresAt;
}

/// Current authoritative state of one asynchronous backend job.
final class RemoteDocumentJobSnapshot {
  RemoteDocumentJobSnapshot({
    required this.jobId,
    required this.status,
    required this.updatedAt,
    this.createdAt,
    this.startedAt,
    this.completedAt,
    this.progressPercent,
    this.failureCode,
    this.artifact,
  }) {
    if (progressPercent != null &&
        (progressPercent! < 0 || progressPercent! > 100)) {
      throw ArgumentError.value(progressPercent, 'progressPercent');
    }
    if (status == RemoteDocumentJobStatus.succeeded && artifact == null) {
      throw ArgumentError('A succeeded job must include artifact metadata.');
    }
    if (status != RemoteDocumentJobStatus.succeeded && artifact != null) {
      throw ArgumentError('Only a succeeded job may expose artifact metadata.');
    }
    if (status == RemoteDocumentJobStatus.failed &&
        (failureCode == null || failureCode!.trim().isEmpty)) {
      throw ArgumentError('A failed job must include a stable failure code.');
    }
  }

  final RemoteDocumentJobId jobId;
  final RemoteDocumentJobStatus status;
  final DateTime updatedAt;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? progressPercent;
  final String? failureCode;
  final RemoteDocumentArtifactMetadata? artifact;
}

/// Authenticated API adapter for the remote job lifecycle.
abstract interface class RemoteDocumentJobPort {
  Future<RemoteDocumentJobReceipt> submit(RemoteDocumentJobRequest request);

  Future<RemoteDocumentJobSnapshot> getStatus(RemoteDocumentJobId jobId);

  /// Returns the authoritative post-cancellation state. The server decides
  /// whether cancellation is still safe for the current job state.
  Future<RemoteDocumentJobSnapshot> cancel(RemoteDocumentJobId jobId);
}

/// Retrieves bytes by opaque artifact ID through the host's authenticated API.
/// Implementations must re-authorize every retrieval and must not persist
/// long-lived bearer or signed URLs.
abstract interface class RemoteDocumentArtifactPort {
  Future<Uint8List> retrieveBytes(String artifactId);
}

/// Retrieves an official document by its server-issued identity and revision.
abstract interface class OfficialDocumentArtifactPort {
  Future<RemoteDocumentArtifactMetadata> getMetadata({
    required String documentType,
    required String officialDocumentId,
    int? revision,
  });
}

/// Validates downloaded bytes against server metadata before creating the
/// immutable artifact used by preview/save/share/print.
DocumentArtifact hydrateRemoteDocumentArtifact({
  required RemoteDocumentArtifactMetadata metadata,
  required Uint8List bytes,
}) {
  if (bytes.isEmpty || bytes.length != metadata.byteLength) {
    throw const FormatException('Remote artifact byte length mismatch.');
  }
  final digest = crypto.sha256.convert(bytes).toString();
  if (digest.toLowerCase() != metadata.sha256.toLowerCase()) {
    throw const FormatException('Remote artifact SHA-256 mismatch.');
  }
  return DocumentArtifact(
    documentId: metadata.documentId,
    templateId: metadata.templateId,
    templateVersion: metadata.templateVersion,
    schemaVersion: metadata.schemaVersion,
    rendererId: metadata.rendererId,
    rendererVersion: metadata.rendererVersion,
    generatedAt: metadata.generatedAt,
    bytes: bytes,
    pageCount: metadata.pageCount,
  );
}

void _validateOpaqueKey(String value, String name) {
  if (value.trim().length < 8 || value.trim().length > 128) {
    throw ArgumentError.value(value, name, 'Must contain 8 to 128 characters.');
  }
}

String _requiredText(String value, String name) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized.length > 200) {
    throw ArgumentError.value(value, name, 'Must contain 1 to 200 characters.');
  }
  return normalized;
}

Map<String, Object?> _immutableJsonMap(Map<String, Object?> source) =>
    Map<String, Object?>.unmodifiable({
      for (final entry in source.entries)
        entry.key: _immutableJsonValue(entry.value),
    });

Object? _immutableJsonValue(Object? value) {
  if (value == null || value is String || value is num || value is bool) {
    return value;
  }
  if (value is List) {
    return List<Object?>.unmodifiable(value.map(_immutableJsonValue));
  }
  if (value is Map) {
    final result = <String, Object?>{};
    for (final entry in value.entries) {
      if (entry.key is! String) {
        throw ArgumentError('JSON object keys must be strings.');
      }
      result[entry.key as String] = _immutableJsonValue(entry.value);
    }
    return Map<String, Object?>.unmodifiable(result);
  }
  throw ArgumentError('Payload must contain JSON-compatible values only.');
}

/// Loads and validates a remote artifact without caching access credentials or
/// bypassing the host adapter's per-request authorization.
final class RemoteDocumentArtifactLoader {
  const RemoteDocumentArtifactLoader({required this.port});

  final RemoteDocumentArtifactPort port;

  Future<DocumentArtifact> load(
    RemoteDocumentArtifactMetadata metadata,
  ) async {
    final bytes = await port.retrieveBytes(metadata.artifactId);
    return hydrateRemoteDocumentArtifact(metadata: metadata, bytes: bytes);
  }
}
