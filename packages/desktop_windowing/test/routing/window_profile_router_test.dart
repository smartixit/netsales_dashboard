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
      '/dashboard/users/:id': 'dashboard',
    });

    test('maps routes that share one window profile', () {
      expect(router.resolve('/forgot-password'), 'authentication');
      expect(router.resolve('/dashboard/reports'), 'dashboard');
    });

    test('resolves parameterized routes and ignores query strings and trailing slashes', () {
      expect(router.resolve('/dashboard/users/42'), 'dashboard');
      expect(router.resolve('/dashboard/users/42?tab=security'), 'dashboard');
      expect(router.resolve('/dashboard/users/42/'), 'dashboard');
    });

    test('returns null for unknown or empty routes', () {
      expect(router.resolve('/not-registered'), isNull);
      expect(router.resolve(null), isNull);
      expect(router.resolve(''), isNull);
    });
  });
}
