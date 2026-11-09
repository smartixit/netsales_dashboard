import '../core/stable_identifier.dart';
import 'document_locale.dart';
import 'document_value.dart';

/// Base type for typed document content nodes.
abstract class DocumentNode {
  const DocumentNode();
}

final class DocumentParagraph extends DocumentNode {
  const DocumentParagraph({
    required this.text,
    this.direction = DocumentTextDirection.auto,
  });

  final String text;
  final DocumentTextDirection direction;
}

final class DocumentHeading extends DocumentNode {
  DocumentHeading({
    required this.text,
    this.level = 1,
    this.direction = DocumentTextDirection.auto,
  }) {
    if (level < 1 || level > 6) {
      throw ArgumentError.value(level, 'level', 'Must be between 1 and 6.');
    }
  }

  final String text;
  final int level;
  final DocumentTextDirection direction;
}

/// A supplied display value. The engine does not derive or aggregate it.
final class DocumentMetric extends DocumentNode {
  DocumentMetric({required String label, required this.value, this.caption})
    : label = _requireLabel(label);

  final String label;
  final DocumentValue value;
  final String? caption;

  static String _requireLabel(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, 'label', 'Must not be empty.');
    }
    return value;
  }
}

enum DocumentCellAlignment { leading, center, trailing, decimal }

final class DocumentTableColumn {
  DocumentTableColumn({
    required String id,
    required String label,
    this.alignment = DocumentCellAlignment.leading,
  }) : id = validateStableIdentifier(id, parameterName: 'columnId'),
       label = _requireLabel(label);

  final String id;
  final String label;
  final DocumentCellAlignment alignment;

  static String _requireLabel(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, 'label', 'Must not be empty.');
    }
    return value;
  }
}

final class DocumentTableCell {
  const DocumentTableCell({required this.value, this.direction});

  final DocumentValue value;
  final DocumentTextDirection? direction;
}

final class DocumentTableRow {
  DocumentTableRow({
    required String id,
    required Iterable<DocumentTableCell> cells,
  }) : id = validateStableIdentifier(id, parameterName: 'rowId'),
       cells = List<DocumentTableCell>.unmodifiable(cells);

  final String id;
  final List<DocumentTableCell> cells;
}

/// A structured table. Row/cell count must match the declared columns.
final class DocumentTable extends DocumentNode {
  DocumentTable({
    required Iterable<DocumentTableColumn> columns,
    required Iterable<DocumentTableRow> rows,
  }) : columns = List<DocumentTableColumn>.unmodifiable(columns),
       rows = List<DocumentTableRow>.unmodifiable(rows) {
    final columnIds = this.columns.map((column) => column.id).toSet();
    if (columnIds.length != this.columns.length) {
      throw ArgumentError('Table column identifiers must be unique.');
    }

    final rowIds = this.rows.map((row) => row.id).toSet();
    if (rowIds.length != this.rows.length) {
      throw ArgumentError('Table row identifiers must be unique.');
    }

    for (final row in this.rows) {
      if (row.cells.length != this.columns.length) {
        throw ArgumentError.value(
          row.cells.length,
          'row.cells.length',
          'Must match the number of table columns.',
        );
      }
    }
  }

  final List<DocumentTableColumn> columns;
  final List<DocumentTableRow> rows;
}

final class DocumentPageBreak extends DocumentNode {
  const DocumentPageBreak();
}
