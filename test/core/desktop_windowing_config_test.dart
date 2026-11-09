import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/core/config/desktop_windowing_config.dart';

void main() {
  group('NetSales desktop window profiles', () {
    test('keeps splash compact and fixed while authentication and dashboard resize', () {
      final splash = desktopWindowingConfig.profiles['splash']!;
      final authentication = desktopWindowingConfig.profiles['authentication']!;
      final dashboard = desktopWindowingConfig.profiles['dashboard']!;

      expect(splash.size.width, 540);
      expect(splash.size.height, 380);
      expect(splash.resizable, isFalse);
      expect(splash.constraints.minimumSize, splash.size);
      expect(splash.constraints.maximumSize, splash.size);

      expect(authentication.resizable, isTrue);
      expect(authentication.constraints.minimumSize!.width, 900);
      expect(authentication.constraints.minimumSize!.height, 620);

      expect(dashboard.resizable, isTrue);
      expect(dashboard.constraints.minimumSize!.width, 1120);
      expect(dashboard.constraints.minimumSize!.height, 720);
    });

    test('maps every platform user route to the dashboard window profile', () {
      expect(desktopWindowingConfig.routeProfiles['/dashboard/users'], 'dashboard');
      expect(desktopWindowingConfig.routeProfiles['/dashboard/roles'], 'dashboard');
      expect(desktopWindowingConfig.routeProfiles['/login'], 'authentication');
      expect(desktopWindowingConfig.routeProfiles['/splash'], 'splash');
    });

    test('uses animated profile transitions without forcing auth and dashboard sizes equal', () {
      expect(desktopWindowingConfig.animation.enabled, isTrue);
      expect(desktopWindowingConfig.animation.duration.inMilliseconds, 220);
      expect(
        desktopWindowingConfig.profiles['authentication']!.size,
        isNot(desktopWindowingConfig.profiles['dashboard']!.size),
      );
    });
  });
}
