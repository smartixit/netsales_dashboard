import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../output/document_output.dart';
import '../rendering/document_render_result.dart';

/// Read-only preview for an already-rendered artifact.
///
/// Page size and orientation are intentionally locked: this widget displays
/// the exact bytes produced by the renderer. Save/share/print are exposed
/// through [DocumentOutputCoordinator] so the host can use its own design
/// system and platform adapters.
class DocumentArtifactPreview extends StatelessWidget {
  const DocumentArtifactPreview({
    required this.artifact,
    required this.fileName,
    this.actions = const [],
    this.loadingWidget,
    this.errorBuilder,
    this.padding = const EdgeInsets.all(16),
    this.previewPageMargin = const EdgeInsets.all(12),
    this.maxPageWidth = 900,
    super.key,
  });

  final DocumentArtifact artifact;
  final String fileName;
  final List<Widget> actions;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final EdgeInsets padding;
  final EdgeInsets previewPageMargin;
  final double maxPageWidth;

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (_) async => artifact.bytes,
      pdfFileName: normalizePdfFileName(fileName) ?? 'document.pdf',
      allowPrinting: false,
      allowSharing: false,
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
      useActions: true,
      actions: actions,
      loadingWidget: loadingWidget,
      onError: errorBuilder,
      padding: padding,
      previewPageMargin: previewPageMargin,
      maxPageWidth: maxPageWidth,
      dynamicLayout: false,
    );
  }
}
