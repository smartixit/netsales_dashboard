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
    this.firstPageHeaderText,
    this.firstPageFooterText,
    this.coverPage = false,
    this.coverTitle,
    this.coverSubtitle,
    Map<String, String> coverMetadata = const {},
    this.maxPages = 100,
  }) : coverMetadata = Map<String, String>.unmodifiable(coverMetadata) {
    if (maxPages < 1 || maxPages > 1000) {
      throw ArgumentError.value(
        maxPages,
        'maxPages',
        'Must be between 1 and 1000.',
      );
    }
    if (coverPage && maxPages < 2) {
      throw ArgumentError(
        'A cover page and content require at least two pages.',
      );
    }
    if (coverPage && (coverTitle == null || coverTitle!.trim().isEmpty)) {
      throw ArgumentError('A cover page requires a non-empty coverTitle.');
    }
    if (!coverPage &&
        (coverTitle != null ||
            coverSubtitle != null ||
            coverMetadata.isNotEmpty)) {
      throw ArgumentError('Cover content requires coverPage to be enabled.');
    }
  }

  final DocumentPageProfile pageProfile;
  final DateTime generatedAt;
  final bool showPageNumbers;
  final String? headerText;
  final String? footerText;
  final String? firstPageHeaderText;
  final String? firstPageFooterText;
  final bool coverPage;
  final String? coverTitle;
  final String? coverSubtitle;
  final Map<String, String> coverMetadata;
  final int maxPages;
}
