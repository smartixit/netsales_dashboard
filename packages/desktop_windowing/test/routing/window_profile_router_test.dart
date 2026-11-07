import 'package:desktop_windowing/src/routing/window_profile_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WindowProfileRouter', () {
    const router = WindowProfileRouter({
      '/splash': 'splash',
      '/login': 'authentication',
      '/forgot-password': 'authentication',
      '/dashboard': 'dashboard',
      '/dashboard/reports': 'dashboard',
    });

    test('maps routes that share one window profile', () {
      expect(router.resolve('/forgot-password'), 'authentication');
      expect(router.resolve('/dashboard/reports'), 'dashboard');
    });

    test('returns null for unknown or empty routes', () {
      expect(router.resolve('/not-registered'), isNull);
      expect(router.resolve(null), isNull);
      expect(router.resolve(''), isNull);
    });
  });
}
