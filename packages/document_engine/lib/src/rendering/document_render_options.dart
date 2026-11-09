import 'document_page_profile.dart';

/// Presentation-only options for one PDF rendering operation.
///
/// [generatedAt] must be supplied by the host. The engine never reads the
/// system clock or derives a document date.
final class DocumentRenderOptions {
  DocumentRenderOptions({
    required this.pageProfile,
    required this.generatedAt,
    this.showPageNumbers = true,
    this.headerText,
    this.footerText,
    this.maxPages = 100,
  }) {
    if (maxPages < 1 || maxPages > 1000) {
      throw ArgumentError.value(
        maxPages,
        'maxPages',
        'Must be between 1 and 1000.',
      );
    }
  }

  final DocumentPageProfile pageProfile;
  final DateTime generatedAt;
  final bool showPageNumbers;
  final String? headerText;
  final String? footerText;
  final int maxPages;
}
