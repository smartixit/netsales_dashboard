import 'package:flutter/widgets.dart';

/// Logical-pixel constraints applied to a window profile.
class WindowConstraints {
  const WindowConstraints({
    this.minimumSize = const Size(480, 320),
    this.maximumSize,
  });

  final Size? minimumSize;
  final Size? maximumSize;
}
