import 'package:document_engine/document_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'file_export_service.dart';
import 'share_service.dart';

/// NetSales host adapter for the generic document-engine output ports.
class NetSalesDocumentOutputAdapter
    implements DocumentSavePort, DocumentSharePort, DocumentPrintPort {
  const NetSalesDocumentOutputAdapter();

  @override
  Future<DocumentOutputResult> save(DocumentOutputRequest request) async {
    if (kIsWeb) {
      // share_plus uses the Web Share API when available and falls back to a
      // browser download when the API is unavailable.
      final result = await ShareService.instance.shareBytes(
        bytes: request.artifact.bytes,
        fileName: request.fileName,
        mimeType: 'application/pdf',
        subject: 'NetSales PDF report',
      );
      return _shareResult(result);
    }

    final result = await FileExportService.instance.saveFile(
      bytes: request.artifact.bytes,
      fileName: request.fileName,
      extension: 'pdf',
      namingStrategy: FileNamingStrategy.report,
      timestamp: request.artifact.generatedAt,
      folderName: 'NetSales',
      autoOpen: false,
      showFeedback: false,
    );
    if (!result.isSuccess) {
      return const DocumentOutputFailure(
        code: DocumentOutputFailureCode.adapterFailure,
        message: 'The PDF could not be saved to the NetSales export folder.',
        isRetryable: true,
      );
    }
    return DocumentOutputSuccess(location: result.filePath);
  }

  @override
  Future<DocumentOutputResult> share(DocumentOutputRequest request) async {
    final result = await ShareService.instance.shareBytes(
      bytes: request.artifact.bytes,
      fileName: request.fileName,
      mimeType: 'application/pdf',
      subject: 'NetSales PDF report',
    );
    return _shareResult(result);
  }

  @override
  Future<DocumentOutputResult> print(DocumentOutputRequest request) async {
    final printed = await Printing.layoutPdf(
      name: request.fileName,
      dynamicLayout: false,
      onLayout: (_) async => request.artifact.bytes,
    );
    return printed
        ? const DocumentOutputSuccess()
        : const DocumentOutputCancelled();
  }

  DocumentOutputResult _shareResult(ShareResult result) => switch (result.status) {
    ShareResultStatus.dismissed => const DocumentOutputCancelled(),
    ShareResultStatus.success || ShareResultStatus.unavailable =>
      const DocumentOutputSuccess(),
  };
}
