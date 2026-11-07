import 'package:desktop_windowing/src/geometry/window_geometry_resolver.dart';
import 'package:desktop_windowing/src/config/window_constraints.dart';
import 'package:desktop_windowing/src/config/window_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  const resolver = WindowGeometryResolver();
  const workArea = Rect.fromLTWH(1920, 0, 1280, 900);

  group('WindowGeometryResolver', () {
    test('centers a profile inside the display work area', () {
      final result = resolver.resolve(
        currentBounds: const Rect.fromLTWH(0, 0, 500, 300),
        requestedSize: const Size(800, 600),
        constraints: const WindowConstraints(
          minimumSize: Size(640, 480),
        ),
        workArea: workArea,
        positionPolicy: WindowPositionPolicy.center,
      );

      expect(result, const Rect.fromLTWH(2160, 150, 800, 600));
    });

    test('clamps requested size and origin to the work area', () {
      final result = resolver.resolve(
        currentBounds: const Rect.fromLTWH(3100, 820, 700, 500),
        requestedSize: const Size(1800, 1200),
        constraints: const WindowConstraints(
          minimumSize: Size(500, 400),
        ),
        workArea: workArea,
        positionPolicy: WindowPositionPolicy.preserve,
      );

      expect(result, const Rect.fromLTWH(1920, 0, 1280, 900));
    });

    test('honors explicit minimum and maximum profile constraints', () {
      final result = resolver.resolve(
        currentBounds: const Rect.fromLTWH(1920, 0, 700, 500),
        requestedSize: const Size(900, 700),
        constraints: const WindowConstraints(
          minimumSize: Size(600, 450),
          maximumSize: Size(760, 580),
        ),
        workArea: workArea,
        positionPolicy: WindowPositionPolicy.workAreaOrigin,
      );

      expect(result.size, const Size(760, 580));
      expect(result.topLeft, workArea.topLeft);
    });
  });
}
