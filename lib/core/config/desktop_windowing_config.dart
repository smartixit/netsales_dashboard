import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:flutter/widgets.dart';

/// NetSales Dashboard window profiles. Values are calibrated starting points;
/// each is clamped against the active display work area at runtime.
const WindowingConfig desktopWindowingConfig = WindowingConfig(
  initialProfileId: 'splash',
  profiles: {
    'splash': WindowProfile(
      id: 'splash',
      size: Size(520, 360),
      constraints: WindowConstraints(
        minimumSize: Size(480, 320),
        maximumSize: Size(640, 480),
      ),
    ),
    'authentication': WindowProfile(
      id: 'authentication',
      size: Size(860, 640),
      constraints: WindowConstraints(
        minimumSize: Size(680, 520),
      ),
    ),
    'dashboard': WindowProfile(
      id: 'dashboard',
      size: Size(1440, 900),
      constraints: WindowConstraints(
        minimumSize: Size(1120, 720),
      ),
      positionPolicy: WindowPositionPolicy.preserve,
    ),
  },
  routeProfiles: {
    '/splash': 'splash',
    '/login': 'authentication',
    '/forgot-password': 'authentication',
    '/verify-otp': 'authentication',
    '/two-factor-auth': 'authentication',
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
