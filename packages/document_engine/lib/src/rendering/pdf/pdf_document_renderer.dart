import 'package:crypto/crypto.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../document/document_node.dart';
import '../../document/document_snapshot.dart';
import '../../document/document_value.dart';
import '../../templates/document_template_definition.dart';
import '../../templates/template_capabilities.dart';
import '../document_page_profile.dart';
import '../document_render_options.dart';
import '../document_render_result.dart';
import '../document_renderer.dart';

/// First PDF backend for bounded, non-official client-side documents.
///
/// Arabic/Hebrew/Persian shaping is deliberately rejected until a shaping
/// provider is selected and validated in the dedicated typography milestone.
final class PdfDocumentRenderer implements DocumentRenderer {
  const PdfDocumentRenderer();

  @override
  String get rendererId => 'document-engine.pdf';

  @override
  String get rendererVersion => '1.0.0';

  @override
  Future<DocumentRenderResult> render({
    required DocumentSnapshot snapshot,
    required DocumentTemplateDefinition template,
    required DocumentRenderOptions options,
  }) async {
    final validationFailure = _validate(snapshot, template, options);
    if (validationFailure != null) return validationFailure;

    try {
      final document = pw.Document(
        compress: true,
        title: snapshot.metadata.title,
        subject: snapshot.metadata.subtitle ?? '',
        creator: rendererId,
        producer: 'document_engine $rendererVersion',
      );
      final profile = options.pageProfile;
      final pageFormat = PdfPageFormat(
        profile.widthPoints,
        profile.heightPoints,
      );
      int? pageCount;

      document.addPage(
        pw.MultiPage(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.fromLTRB(
            profile.marginLeft,
            profile.marginTop,
            profile.marginRight,
            profile.marginBottom,
          ),
          maxPages: options.maxPages,
          header: options.headerText == null
              ? null
              : (context) => pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.grey400,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: pw.Text(
                      options.headerText!,
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
          footer: options.footerText == null && !options.showPageNumbers
              ? null
              : (context) {
                  pageCount = context.pagesCount;
                  final parts = <pw.Widget>[];
                  if (options.footerText case final text?) {
                    parts.add(pw.Text(
                      text,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ));
                  }
                  if (options.showPageNumbers) {
                    parts.add(pw.Text(
                      '${context.pageNumber} / ${context.pagesCount}',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ));
                  }
                  return pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        top: pw.BorderSide(
                          color: PdfColors.grey300,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: parts,
                    ),
                  );
                },
          build: (context) => _buildContent(snapshot),
        ),
      );

      final bytes = await document.save();
      final digest = sha256.convert(bytes).toString();
      return DocumentRenderSuccess(
        DocumentArtifact(
          documentId: snapshot.metadata.id,
          templateId: template.id,
          templateVersion: template.version,
          schemaVersion: snapshot.schemaVersion,
          rendererId: rendererId,
          rendererVersion: rendererVersion,
          generatedAt: options.generatedAt,
          bytes: bytes,
          sha256: digest,
          pageCount: pageCount,
        ),
      );
    } catch (error) {
      final message = error.toString();
      final isPageLimit = message.contains('TooManyPagesException') ||
          message.toLowerCase().contains('maximum number of pages');
      return DocumentRenderFailure(
        code: isPageLimit
            ? DocumentRenderFailureCode.pageLimitExceeded
            : DocumentRenderFailureCode.renderingFailure,
        message: isPageLimit
            ? 'The document exceeded the configured page limit.'
            : 'The PDF renderer could not generate this document.',
      );
    }
  }

  DocumentRenderFailure? _validate(
    DocumentSnapshot snapshot,
    DocumentTemplateDefinition template,
    DocumentRenderOptions options,
  ) {
    if (snapshot.metadata.documentTypeId != template.documentTypeId) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.templateMismatch,
        message: 'The selected template does not support this document type.',
      );
    }

    if (!template.supportsLocale(snapshot.metadata.locale.languageTag)) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.unsupportedLocale,
        message: 'The selected template does not support this document locale.',
      );
    }

    final locale = snapshot.metadata.locale.languageTag.toLowerCase();
    if (snapshot.metadata.locale.direction ==
            DocumentTextDirection.rightToLeft ||
        RegExp(r'^(ar|fa|ur|he|ps|sd)(-|$)').hasMatch(locale) ||
        _containsUnshapedRtl(snapshot)) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.unsupportedTextShaping,
        message:
            'This PDF backend does not yet support complex RTL text shaping.',
      );
    }

    final requiredCapabilities = <TemplateCapability>[];
    if (options.showPageNumbers) {
      requiredCapabilities.add(TemplateCapability.pageNumbering);
    }
    if (options.headerText != null) {
      requiredCapabilities.add(TemplateCapability.repeatingHeader);
    }
    if (options.footerText != null) {
      requiredCapabilities.add(TemplateCapability.repeatingFooter);
    }
    if (snapshot.sections.any(
      (section) => section.nodes.any((node) => node is DocumentTable),
    )) {
      requiredCapabilities.add(TemplateCapability.tables);
    }
    if (snapshot.sections.any(
      (section) => section.nodes.any((node) => node is DocumentMetric),
    )) {
      requiredCapabilities.add(TemplateCapability.metrics);
    }
    if (!template.capabilities.supportsAll(requiredCapabilities)) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.unsupportedCapability,
        message:
            'The selected template does not declare all requested capabilities.',
      );
    }

    final orientationCapability =
        options.pageProfile.orientation == DocumentPageOrientation.portrait
            ? TemplateCapability.portraitPage
            : TemplateCapability.landscapePage;
    if (!template.capabilities.supports(orientationCapability)) {
      return const DocumentRenderFailure(
        code: DocumentRenderFailureCode.unsupportedCapability,
        message: 'The selected template does not support this page orientation.',
      );
    }
    return null;
  }

  bool _containsUnshapedRtl(DocumentSnapshot snapshot) {
    final rtlPattern = RegExp(r'[\u0590-\u08FF\uFB1D-\uFDFF\uFE70-\uFEFF]');
    for (final section in snapshot.sections) {
      for (final node in section.nodes) {
        if (node case DocumentParagraph(:final text, :final direction)) {
          if (direction == DocumentTextDirection.rightToLeft ||
              rtlPattern.hasMatch(text)) {
            return true;
          }
        } else if (node case DocumentHeading(:final text, :final direction)) {
          if (direction == DocumentTextDirection.rightToLeft ||
              rtlPattern.hasMatch(text)) {
            return true;
          }
        } else if (node case DocumentMetric(:final label, :final value)) {
          if (rtlPattern.hasMatch(label) || rtlPattern.hasMatch(_valueText(value))) {
            return true;
          }
        } else if (node case DocumentTable(:final columns, :final rows)) {
          if (columns.any((column) => rtlPattern.hasMatch(column.label))) {
            return true;
          }
          for (final row in rows) {
            if (row.cells.any(
              (cell) =>
                  cell.direction == DocumentTextDirection.rightToLeft ||
                  rtlPattern.hasMatch(_valueText(cell.value)),
            )) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  List<pw.Widget> _buildContent(DocumentSnapshot snapshot) {
    final widgets = <pw.Widget>[
      pw.Header(
        level: 0,
        child: pw.Text(
          snapshot.metadata.title,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    ];
    if (snapshot.metadata.subtitle case final subtitle?) {
      widgets.add(pw.Paragraph(
        text: subtitle,
        style: const pw.TextStyle(
          fontSize: 11,
          color: PdfColors.grey700,
        ),
      ));
    }

    for (final section in snapshot.sections) {
      if (section.title case final title?) {
        widgets.add(pw.Header(level: 1, child: pw.Text(title)));
      }
      for (final node in section.nodes) {
        switch (node) {
          case DocumentParagraph(:final text):
            widgets.add(pw.Paragraph(text: text));
          case DocumentHeading(:final text, :final level):
            widgets.add(pw.Header(
              level: level > 5 ? 5 : level,
              child: pw.Text(text),
            ));
          case DocumentMetric(:final label, :final value, :final caption):
            widgets.add(_metricWidget(label, value, caption));
          case DocumentTable(:final columns, :final rows):
            widgets.add(_tableWidget(columns, rows));
          case DocumentPageBreak():
            widgets.add(pw.NewPage());
        }
      }
    }
    return widgets;
  }

  pw.Widget _metricWidget(String label, DocumentValue value, String? caption) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 6),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.7),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 4),
          pw.Text(
            _valueText(value),
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (caption != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 3),
              child: pw.Text(
                caption,
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _tableWidget(
    List<DocumentTableColumn> columns,
    List<DocumentTableRow> rows,
  ) {
    final tableRows = <pw.TableRow>[
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: columns
            .map((column) => _tableCell(column.label, column.alignment, true))
            .toList(),
      ),
      ...rows.map(
        (row) => pw.TableRow(
          children: [
            for (var index = 0; index < row.cells.length; index++)
              _tableCell(
                _valueText(row.cells[index].value),
                columns[index].alignment,
                false,
              ),
          ],
        ),
      ),
    ];
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      children: tableRows,
    );
  }

  pw.Widget _tableCell(
    String text,
    DocumentCellAlignment alignment,
    bool isHeader,
  ) {
    final textAlign = switch (alignment) {
      DocumentCellAlignment.leading => pw.TextAlign.left,
      DocumentCellAlignment.center => pw.TextAlign.center,
      DocumentCellAlignment.trailing ||
      DocumentCellAlignment.decimal => pw.TextAlign.right,
    };
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: textAlign,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _valueText(DocumentValue value) => switch (value) {
        DocumentTextValue(:final value) => value,
        DocumentIntegerValue(:final value) => value.toString(),
        DocumentDecimalValue(:final value) => value,
        DocumentDateTimeValue(:final value) => value.toIso8601String(),
        DocumentBooleanValue(:final value) => value ? 'Yes' : 'No',
      };
}
