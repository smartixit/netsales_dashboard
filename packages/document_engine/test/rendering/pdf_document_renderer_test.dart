import 'package:document_engine/document_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final documentType = DocumentTypeId('report.summary');
  final template = DocumentTemplateDefinition(
    id: TemplateId('report.summary.standard'),
    version: TemplateVersion(major: 1, minor: 0, patch: 0),
    documentTypeId: documentType,
    displayName: 'Standard summary',
    supportedLocaleTags: const ['en'],
    capabilities: TemplateCapabilities({
      TemplateCapability.tables,
      TemplateCapability.metrics,
      TemplateCapability.pageNumbering,
      TemplateCapability.repeatingHeader,
      TemplateCapability.repeatingFooter,
      TemplateCapability.portraitPage,
      TemplateCapability.landscapePage,
    }),
  );

  DocumentSnapshot snapshot({
    String title = 'Quarterly summary',
    String languageTag = 'en-US',
    List<DocumentNode>? nodes,
  }) {
    return DocumentSnapshot(
      metadata: DocumentMetadata(
        id: DocumentId('report-001'),
        documentTypeId: documentType,
        title: title,
        locale: DocumentLocale(
          languageTag: languageTag,
          direction: DocumentTextDirection.leftToRight,
        ),
        createdAt: DateTime.utc(2026, 11, 9),
      ),
      sections: [
        DocumentSection(
          id: 'summary',
          title: 'Overview',
          nodes:
              nodes ??
              [
                const DocumentParagraph(text: 'This is a generated report.'),
                DocumentMetric(
                  label: 'Gross sales',
                  value: DocumentDecimalValue('1250.50'),
                  caption: 'Supplied by the host application',
                ),
                DocumentTable(
                  columns: [
                    DocumentTableColumn(id: 'item', label: 'Item'),
                    DocumentTableColumn(
                      id: 'amount',
                      label: 'Amount',
                      alignment: DocumentCellAlignment.trailing,
                    ),
                  ],
                  rows: [
                    DocumentTableRow(
                      id: 'row-1',
                      cells: [
                        const DocumentTableCell(
                          value: DocumentTextValue('Service'),
                        ),
                        DocumentTableCell(
                          value: DocumentDecimalValue('1250.50'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
        ),
      ],
    );
  }

  DocumentRenderOptions options({
    DocumentPageProfile? pageProfile,
    bool showPageNumbers = true,
    String? headerText,
    String? footerText,
  }) {
    return DocumentRenderOptions(
      pageProfile: pageProfile ?? DocumentPageProfile.a4Portrait(),
      generatedAt: DateTime.utc(2026, 11, 9, 10),
      showPageNumbers: showPageNumbers,
      headerText: headerText,
      footerText: footerText,
    );
  }

  test(
    'renders a PDF with metadata, digest, and defensive byte copies',
    () async {
      const renderer = PdfDocumentRenderer();
      final result = await renderer.render(
        snapshot: snapshot(),
        template: template,
        options: options(
          headerText: 'NetSales Reports',
          footerText: 'Confidential',
        ),
      );

      expect(result, isA<DocumentRenderSuccess>());
      final artifact = (result as DocumentRenderSuccess).artifact;
      expect(artifact.bytes.take(5), [37, 80, 68, 70, 45]);
      expect(artifact.byteLength, greaterThan(100));
      expect(artifact.sha256, matches(RegExp(r'^[a-f0-9]{64}$')));
      expect(artifact.documentId, DocumentId('report-001'));
      expect(artifact.templateVersion.toString(), '1.0.0');
      expect(artifact.rendererId, 'document-engine.pdf');
      expect(artifact.generatedAt, DateTime.utc(2026, 11, 9, 10));

      final firstCopy = artifact.bytes;
      firstCopy[0] = 0;
      expect(artifact.bytes.first, 37);
    },
  );

  test(
    'rejects complex RTL text until a shaping provider is approved',
    () async {
      const renderer = PdfDocumentRenderer();
      final result = await renderer.render(
        snapshot: snapshot(
          languageTag: 'en-US',
          nodes: const [DocumentParagraph(text: 'تقرير المبيعات')],
        ),
        template: template,
        options: options(),
      );

      expect(result, isA<DocumentRenderFailure>());
      expect(
        (result as DocumentRenderFailure).code,
        DocumentRenderFailureCode.unsupportedTextShaping,
      );
    },
  );

  test('rejects a template registered for another document type', () async {
    const renderer = PdfDocumentRenderer();
    final otherTemplate = DocumentTemplateDefinition(
      id: TemplateId('invoice.standard'),
      version: TemplateVersion(major: 1, minor: 0, patch: 0),
      documentTypeId: DocumentTypeId('sales.invoice'),
      displayName: 'Invoice',
      supportedLocaleTags: const ['en'],
      capabilities: template.capabilities,
    );

    final result = await renderer.render(
      snapshot: snapshot(),
      template: otherTemplate,
      options: options(),
    );

    expect(result, isA<DocumentRenderFailure>());
    expect(
      (result as DocumentRenderFailure).code,
      DocumentRenderFailureCode.templateMismatch,
    );
  });

  test(
    'requires the template to declare the requested page orientation',
    () async {
      const renderer = PdfDocumentRenderer();
      final portraitOnly = DocumentTemplateDefinition(
        id: TemplateId('report.portrait'),
        version: TemplateVersion(major: 1, minor: 0, patch: 0),
        documentTypeId: documentType,
        displayName: 'Portrait report',
        supportedLocaleTags: const ['en'],
        capabilities: TemplateCapabilities({
          TemplateCapability.pageNumbering,
          TemplateCapability.portraitPage,
        }),
      );

      final result = await renderer.render(
        snapshot: snapshot(
          nodes: const [DocumentParagraph(text: 'Short report')],
        ),
        template: portraitOnly,
        options: options(pageProfile: DocumentPageProfile.a4Landscape()),
      );

      expect(result, isA<DocumentRenderFailure>());
      expect(
        (result as DocumentRenderFailure).code,
        DocumentRenderFailureCode.unsupportedCapability,
      );
    },
  );

  test('validates printable area and page limits', () {
    expect(
      () => DocumentPageProfile(
        widthPoints: 100,
        heightPoints: 100,
        marginLeft: 50,
        marginRight: 50,
      ),
      throwsArgumentError,
    );
    expect(
      () => DocumentRenderOptions(
        pageProfile: DocumentPageProfile.a4Portrait(),
        generatedAt: DateTime.utc(2026),
        maxPages: 0,
      ),
      throwsArgumentError,
    );
  });
}
