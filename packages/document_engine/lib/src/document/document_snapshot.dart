import 'bounded_document_input.dart';
import 'document_metadata.dart';
import 'document_section.dart';

/// Immutable, application-neutral input for a single document rendering.
final class DocumentSnapshot {
  DocumentSnapshot({
    required this.metadata,
    required Iterable<DocumentSection> sections,
    this.schemaVersion = 1,
  }) : sections = copyBoundedDocumentList(sections, maxLength: 250, fieldName: 'sections') {
    if (schemaVersion < 1) {
      throw ArgumentError.value(
        schemaVersion,
        'schemaVersion',
        'Must be a positive integer.',
      );
    }

    final nodeCount = this.sections.fold<int>(0, (count, section) => count + section.nodes.length);
    if (nodeCount > 20000) throw ArgumentError.value(nodeCount, 'sections', 'A document may contain at most 20000 nodes.');
    final sectionIds = this.sections.map((section) => section.id).toSet();
    if (sectionIds.length != this.sections.length) {
      throw ArgumentError('Document section identifiers must be unique.');
    }
  }

  final DocumentMetadata metadata;
  final List<DocumentSection> sections;
  final int schemaVersion;
}
