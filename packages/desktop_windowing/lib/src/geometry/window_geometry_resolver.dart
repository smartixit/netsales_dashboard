import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../config/window_constraints.dart';
import '../config/window_profile.dart';

/// Resolves profile geometry against the display's usable work area.
class WindowGeometryResolver {
  const WindowGeometryResolver();

  Rect resolve({
    required Rect currentBounds,
    required Size requestedSize,
    required WindowConstraints constraints,
    required Rect workArea,
    required WindowPositionPolicy positionPolicy,
  }) {
    final safeWorkArea = workArea.width > 0 && workArea.height > 0
        ? workArea
        : Rect.fromLTWH(0, 0, requestedSize.width, requestedSize.height);

    final minimum = constraints.minimumSize ?? Size.zero;
    final maximum = constraints.maximumSize ?? safeWorkArea.size;

    final minWidth = math.min(minimum.width, safeWorkArea.width).toDouble();
    final minHeight = math.min(minimum.height, safeWorkArea.height).toDouble();
    final maxWidth = math
        .max(minWidth, math.min(maximum.width, safeWorkArea.width))
        .toDouble();
    final maxHeight = math
        .max(minHeight, math.min(maximum.height, safeWorkArea.height))
        .toDouble();

    final width = requestedSize.width.clamp(minWidth, maxWidth).toDouble();
    final height = requestedSize.height.clamp(minHeight, maxHeight).toDouble();
    final targetSize = Size(width, height);

    final requestedOrigin = switch (positionPolicy) {
      WindowPositionPolicy.center => Offset(
          safeWorkArea.center.dx - width / 2,
          safeWorkArea.center.dy - height / 2,
        ),
      WindowPositionPolicy.preserve => currentBounds.topLeft,
      WindowPositionPolicy.workAreaOrigin => safeWorkArea.topLeft,
    };

    final maxLeft = safeWorkArea.right - width;
    final maxTop = safeWorkArea.bottom - height;
    final left = requestedOrigin.dx.clamp(safeWorkArea.left, maxLeft).toDouble();
    final top = requestedOrigin.dy.clamp(safeWorkArea.top, maxTop).toDouble();

    return Rect.fromLTWH(left, top, targetSize.width, targetSize.height);
  }
}
