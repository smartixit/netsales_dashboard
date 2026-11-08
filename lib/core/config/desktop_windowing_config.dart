import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:flutter/widgets.dart';

/// NetSales Dashboard host profiles. The reusable package remains independent;
/// these route profiles are application-specific configuration only.
const WindowingConfig desktopWindowingConfig = WindowingConfig(
  initialProfileId: 'splash',
  profiles: {
    'splash': WindowProfile(
      id: 'splash',
      size: Size(540, 380),
      constraints: WindowConstraints(
        minimumSize: Size(540, 380),
        maximumSize: Size(540, 380),
      ),
      resizable: false,
      alwaysOnTop: true,
      skipTaskbar: true,
      frameless: true,
      titleBarStyle: WindowTitleBarStyle.hidden,
    ),
    'authentication': WindowProfile(
      id: 'authentication',
      size: Size(1040, 720),
      constraints: WindowConstraints(
        minimumSize: Size(900, 620),
      ),
      resizable: true,
      alwaysOnTop: false,
      skipTaskbar: false,
      frameless: false,
      titleBarStyle: WindowTitleBarStyle.normal,
    ),
    'dashboard': WindowProfile(
      id: 'dashboard',
      size: Size(1440, 900),
      constraints: WindowConstraints(
        minimumSize: Size(1120, 720),
      ),
      positionPolicy: WindowPositionPolicy.preserve,
      resizable: true,
      alwaysOnTop: false,
      skipTaskbar: false,
      frameless: false,
      titleBarStyle: WindowTitleBarStyle.normal,
    ),
  },
  routeProfiles: {
    '/splash': 'splash',
    '/login': 'authentication',
    '/forgot-password': 'authentication',
    '/verify-otp': 'authentication',
    '/reset-password': 'authentication',
    '/two-factor-auth': 'authentication',
    '/unauthorized': 'authentication',
    '/dashboard': 'dashboard',
    '/dev/dashboard-metrics': 'dashboard',
    '/dev/data-grid': 'dashboard',
  },
  animation: WindowAnimationConfig(
    enabled: true,
    preferNative: true,
    duration: Duration(milliseconds: 220),
    curve: Curves.easeInOutCubic,
  ),
  hideUntilReady: true,
  resizable: true,
);
