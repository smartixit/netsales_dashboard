/// Physical PDF page geometry, expressed in PDF points (1/72 inch).
enum DocumentPageOrientation { portrait, landscape }

/// Immutable page geometry shared by all rendering backends.
final class DocumentPageProfile {
  DocumentPageProfile({
    required this.widthPoints,
    required this.heightPoints,
    this.orientation = DocumentPageOrientation.portrait,
    this.marginTop = 36,
    this.marginRight = 36,
    this.marginBottom = 36,
    this.marginLeft = 36,
  }) {
    if (!_isPositiveFinite(widthPoints) || !_isPositiveFinite(heightPoints)) {
      throw ArgumentError('Page dimensions must be finite and positive.');
    }
    if (orientation == DocumentPageOrientation.portrait &&
        widthPoints > heightPoints) {
      throw ArgumentError('Portrait pages must be taller than they are wide.');
    }
    if (orientation == DocumentPageOrientation.landscape &&
        widthPoints < heightPoints) {
      throw ArgumentError('Landscape pages must be wider than they are tall.');
    }

    final margins = [marginTop, marginRight, marginBottom, marginLeft];
    if (margins.any((value) => !_isNonNegativeFinite(value))) {
      throw ArgumentError('Page margins must be finite and non-negative.');
    }
    if (marginLeft + marginRight >= widthPoints ||
        marginTop + marginBottom >= heightPoints) {
      throw ArgumentError('Margins must leave a positive printable area.');
    }
  }

  factory DocumentPageProfile.a4Portrait({
    double marginTop = 36,
    double marginRight = 36,
    double marginBottom = 36,
    double marginLeft = 36,
  }) => DocumentPageProfile(
    widthPoints: 595.28,
    heightPoints: 841.89,
    marginTop: marginTop,
    marginRight: marginRight,
    marginBottom: marginBottom,
    marginLeft: marginLeft,
  );

  factory DocumentPageProfile.a4Landscape({
    double marginTop = 36,
    double marginRight = 36,
    double marginBottom = 36,
    double marginLeft = 36,
  }) => DocumentPageProfile(
    widthPoints: 841.89,
    heightPoints: 595.28,
    orientation: DocumentPageOrientation.landscape,
    marginTop: marginTop,
    marginRight: marginRight,
    marginBottom: marginBottom,
    marginLeft: marginLeft,
  );

  factory DocumentPageProfile.letterPortrait({
    double marginTop = 36,
    double marginRight = 36,
    double marginBottom = 36,
    double marginLeft = 36,
  }) => DocumentPageProfile(
    widthPoints: 612,
    heightPoints: 792,
    marginTop: marginTop,
    marginRight: marginRight,
    marginBottom: marginBottom,
    marginLeft: marginLeft,
  );

  final double widthPoints;
  final double heightPoints;
  final DocumentPageOrientation orientation;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double marginLeft;

  static bool _isPositiveFinite(double value) => value.isFinite && value > 0;

  static bool _isNonNegativeFinite(double value) =>
      value.isFinite && value >= 0;
}
