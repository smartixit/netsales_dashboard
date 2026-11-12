import 'package:payv/payv.dart' as payv;

import '../../document/document_locale.dart';

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'payv_text_shaping_provider.dart';

/// A single-line, vector-outline PDF text widget.
///
/// This is the first layout adapter over [PayvTextShapingProvider]. It accepts
/// a bounded fixed box; paragraph wrapping and multipage flow remain owned by
/// the surrounding document layout. The painter draws actual shaped glyph
/// outlines, not Unicode presentation-form substitutions.
final class ShapedPdfTextLine extends pw.StatelessWidget {
  ShapedPdfTextLine({
    required this.text,
    required this.provider,
    required this.width,
    required this.fontSize,
    this.height,
    this.color = PdfColors.black,
    this.direction = DocumentTextDirection.auto,
    this.alignment = ShapedPdfTextAlignment.start,
  }) {
    if (text.contains('\n') || text.contains('\r')) {
      throw ArgumentError.value(text, 'text', 'Only one line is accepted.');
    }
    if (!width.isFinite || width <= 0 || width > 2000) {
      throw ArgumentError.value(width, 'width', 'Must be in (0, 2000].');
    }
    if (!fontSize.isFinite || fontSize <= 0 || fontSize > 144) {
      throw ArgumentError.value(fontSize, 'fontSize', 'Must be in (0, 144].');
    }
    if (height != null &&
        (!height!.isFinite || height! <= 0 || height! > 500)) {
      throw ArgumentError.value(height, 'height', 'Must be in (0, 500].');
    }
  }

  final String text;
  final PayvTextShapingProvider provider;
  final double width;
  final double fontSize;
  final double? height;
  final PdfColor color;
  final DocumentTextDirection direction;
  final ShapedPdfTextAlignment alignment;

  @override
  pw.Widget build(pw.Context context) {
    final shaped = provider.shapeLine(text, direction: direction);
    final scale = fontSize / provider.font.unitsPerEm;
    final measuredWidth = shaped.advance * scale;
    final boxHeight = height ?? fontSize * 1.8;

    if (measuredWidth > width + 0.01) {
      throw ArgumentError(
        'The shaped line requires ${measuredWidth.toStringAsFixed(2)} pt '
        'but its allocated width is ${width.toStringAsFixed(2)} pt. '
        'Use the paragraph-flow adapter for wrapping.',
      );
    }

    final freeSpace = width - measuredWidth;
    final startX = switch (alignment) {
      ShapedPdfTextAlignment.start =>
        shaped.isRightToLeft ? freeSpace : 0.0,
      ShapedPdfTextAlignment.end =>
        shaped.isRightToLeft ? 0.0 : freeSpace,
      ShapedPdfTextAlignment.center => freeSpace / 2,
      ShapedPdfTextAlignment.left => 0.0,
      ShapedPdfTextAlignment.right => freeSpace,
    };

    return pw.CustomPaint(
      size: PdfPoint(width, boxHeight),
      painter: (canvas, size) {
        var penX = startX;
        final baseline = (boxHeight - fontSize) / 2;
        for (final run in shaped.visualRuns) {
          for (final glyph in run.glyphs) {
            final originX = penX + glyph.xOffset * scale;
            final originY = baseline + glyph.yOffset * scale;
            final path = _transformGlyphPath(
              glyph.outline,
              scale: scale,
              offsetX: originX,
              offsetY: originY,
            );
            if (path.isNotEmpty) {
              canvas
                ..setFillColor(color)
                ..drawShape(path.toPdfPath())
                ..fillPath();
            }
            penX += glyph.xAdvance * scale;
          }
        }
      },
    );
  }

  static payv.GlyphPath _transformGlyphPath(
    payv.GlyphPath source, {
    required double scale,
    required double offsetX,
    required double offsetY,
  }) {
    final result = payv.GlyphPath();
    for (final command in source.commands) {
      switch (command) {
        case payv.MoveTo():
          result.moveTo(
            offsetX + command.x * scale,
            offsetY + command.y * scale,
          );
        case payv.LineTo():
          result.lineTo(
            offsetX + command.x * scale,
            offsetY + command.y * scale,
          );
        case payv.QuadTo():
          result.quadraticTo(
            offsetX + command.cx * scale,
            offsetY + command.cy * scale,
            offsetX + command.x * scale,
            offsetY + command.y * scale,
          );
        case payv.CubicTo():
          result.cubicTo(
            offsetX + command.c1x * scale,
            offsetY + command.c1y * scale,
            offsetX + command.c2x * scale,
            offsetY + command.c2y * scale,
            offsetX + command.x * scale,
            offsetY + command.y * scale,
          );
        case payv.ClosePath():
          result.close();
      }
    }
    return result;
  }
}

/// Alignment follows the resolved paragraph direction for start/end.
enum ShapedPdfTextAlignment { start, end, left, right, center }
