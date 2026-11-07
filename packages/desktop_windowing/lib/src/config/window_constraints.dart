import 'package:flutter/widgets.dart';

/// Logical-pixel constraints applied to a window profile.
class WindowConstraints {
  const WindowConstraints({
    this.minimumSize = const Size(480, 320),
    this.maximumSize,
  }) : assert(minimumSize == null || minimumSize.width >= 0),
       assert(minimumSize == null || minimumSize.height >= 0),
       assert(maximumSize == null || maximumSize.width > 0),
       assert(maximumSize == null || maximumSize.height > 0);

  final Size? minimumSize;
  final Size? maximumSize;
}
