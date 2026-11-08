import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:flutter/widgets.dart';

/// NetSales Dashboard host profiles. The reusable package remains independent;
/// these route profiles are application-specific configuration only.
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
      size: Size(1040, 720),
      constraints: WindowConstraints(
        minimumSize: Size(900, 620),
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
    '/reset-password': 'authentication',
    '/two-factor-auth': 'authentication',
    '/unauthorized': 'authentication',
    '/dashboard': 'dashboard',
    '/dashboard/overview': 'dashboard',
    '/dashboard/account': 'dashboard',
    '/dashboard/users': 'dashboard',
    '/dashboard/roles': 'dashboard',
    '/dashboard/networks': 'dashboard',
    '/dashboard/pos': 'dashboard',
    '/dashboard/geography': 'dashboard',
    '/dashboard/subscription-plans': 'dashboard',
    '/dashboard/provider-subscriptions': 'dashboard',
    '/dashboard/subscription-requests': 'dashboard',
    '/dashboard/sales': 'dashboard',
    '/dashboard/network-wallets': 'dashboard',
    '/dashboard/pos-wallets': 'dashboard',
    '/dashboard/expenses': 'dashboard',
    '/dashboard/bank-accounts': 'dashboard',
    '/dashboard/financial-reports': 'dashboard',
    '/dashboard/support-tickets': 'dashboard',
    '/dashboard/notifications': 'dashboard',
    '/dashboard/notification-management': 'dashboard',
    '/dashboard/sessions': 'dashboard',
    '/dashboard/audit-logs': 'dashboard',
    '/dashboard/settings': 'dashboard',
    '/dashboard/backups': 'dashboard',
    '/dashboard/scheduled-tasks': 'dashboard',
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
