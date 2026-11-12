import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../document/document_locale.dart';
import 'payv_text_shaping_provider.dart';
import 'shaped_pdf_text_line.dart';

/// Paragraph flow for shaped text.
///
/// Lines are measured after OpenType shaping, so ligatures and contextual
/// Arabic forms are never split by a character-count approximation. The
/// returned Column is a spanning PDF widget and can flow through MultiPage.
final class ShapedPdfParagraph extends pw.StatelessWidget {
  ShapedPdfParagraph({
    required this.text,
    required this.provider,
    required this.width,
    required this.fontSize,
    this.color = PdfColors.black,
    this.direction = DocumentTextDirection.auto,
    this.alignment = ShapedPdfTextAlignment.start,
    this.lineHeight = 1.65,
    this.paragraphSpacing = 0,
  }) {
    if (!width.isFinite || width <= 0 || width > 2000) {
      throw ArgumentError.value(width, 'width', 'Must be in (0, 2000].');
    }
    if (!fontSize.isFinite || fontSize <= 0 || fontSize > 144) {
      throw ArgumentError.value(fontSize, 'fontSize', 'Must be in (0, 144].');
    }
    if (!lineHeight.isFinite || lineHeight < 1 || lineHeight > 3) {
      throw ArgumentError.value(lineHeight, 'lineHeight', 'Must be in [1, 3].');
    }
    if (!paragraphSpacing.isFinite ||
        paragraphSpacing < 0 ||
        paragraphSpacing > 100) {
      throw ArgumentError.value(
        paragraphSpacing,
        'paragraphSpacing',
        'Must be in [0, 100].',
      );
    }
  }

  final String text;
  final PayvTextShapingProvider provider;
  final double width;
  final double fontSize;
  final PdfColor color;
  final DocumentTextDirection direction;
  final ShapedPdfTextAlignment alignment;
  final double lineHeight;
  final double paragraphSpacing;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[];
    final paragraphLines = text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split(RegExp('[\u2028\u2029\n]'));

    for (var paragraphIndex = 0;
        paragraphIndex < paragraphLines.length;
        paragraphIndex++) {
      final paragraph = paragraphLines[paragraphIndex];
      if (paragraph.isEmpty) {
        widgets.add(pw.SizedBox(height: fontSize * lineHeight));
        continue;
      }

      final words = paragraph.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
      var current = '';

      void emit(String value) {
        widgets.add(
          ShapedPdfTextLine(
            text: value,
            provider: provider,
            width: width,
            fontSize: fontSize,
            height: fontSize * lineHeight,
            color: color,
            direction: direction,
            alignment: alignment,
          ),
        );
      }

      for (final word in words) {
        final candidate = current.isEmpty ? word : '$current $word';
        final candidateWidth =
            provider.shapeLine(candidate, direction: direction).advance *
            fontSize /
            provider.font.unitsPerEm;

        if (candidateWidth <= width) {
          current = candidate;
          continue;
        }

        if (current.isNotEmpty) {
          emit(current);
          current = '';
        }

        final wordWidth =
            provider.shapeLine(word, direction: direction).advance *
            fontSize /
            provider.font.unitsPerEm;
        if (wordWidth <= width) {
          current = word;
          continue;
        }

        // Long identifiers/URLs have no natural whitespace. Split only at
        // Unicode grapheme boundaries, never inside a combining sequence.
        final graphemes = _graphemes(word);
        var fragment = '';
        for (final grapheme in graphemes) {
          final next = '$fragment$grapheme';
          final nextWidth =
              provider.shapeLine(next, direction: direction).advance *
              fontSize /
              provider.font.unitsPerEm;
          if (fragment.isNotEmpty && nextWidth > width) {
            emit(fragment);
            fragment = grapheme;
          } else {
            fragment = next;
          }
        }
        current = fragment;
      }

      if (current.isNotEmpty) emit(current);
      if (paragraphIndex < paragraphLines.length - 1 &&
          paragraphSpacing > 0) {
        widgets.add(pw.SizedBox(height: paragraphSpacing));
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: widgets,
    );
  }

  static List<String> _graphemes(String value) {
    // Combining marks, variation selectors, emoji modifiers and ZWJ sequences
    // remain attached to their preceding base scalar. This bounded fallback
    // is deliberately conservative for identifiers without whitespace.
    final result = <String>[];
    var current = '';
    var joinNext = false;
    for (final scalar in value.runes) {
      final isMark =
          (scalar >= 0x0300 && scalar <= 0x036F) ||
          (scalar >= 0x064B && scalar <= 0x065F) ||
          scalar == 0x0670 ||
          (scalar >= 0x06D6 && scalar <= 0x06ED) ||
          (scalar >= 0xFE00 && scalar <= 0xFE0F) ||
          (scalar >= 0x1F3FB && scalar <= 0x1F3FF);
      if (current.isEmpty || isMark || joinNext || scalar == 0x200D) {
        current += String.fromCharCode(scalar);
      } else {
        result.add(current);
        current = String.fromCharCode(scalar);
      }
      joinNext = scalar == 0x200D;
    }
    if (current.isNotEmpty) result.add(current);
    return result;
  }
}
