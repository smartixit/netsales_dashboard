# desktop_windowing

A reusable Flutter desktop window-management package. It is deliberately independent from
NetSales, GetX, and any routing framework.

## Supported platforms

- Windows, Linux, and macOS: native window management.
- Web: no browser-window resizing; the stub leaves sizing to the browser and responsive UI.

Requires Flutter 3.47 / Dart 3.13 or later through `window_manager 0.6.x`.

## Define profiles

```dart
import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:flutter/widgets.dart';

const windowingConfig = WindowingConfig(
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
    '/dashboard': 'dashboard',
  },
);
```

These values are illustrative defaults. A host application should calibrate them against its
actual screens and minimum useful content widths. All sizes are logical pixels and are clamped
to the selected monitor's work area.

## Initialize before showing the first frame

```dart
WidgetsFlutterBinding.ensureInitialized();

final windowing = DesktopWindowingController(config: windowingConfig);
await windowing.initialize();

// Initialize the host app's essential services here.

WidgetsBinding.instance.addPostFrameCallback((_) {
  windowing.show();
});
runApp(const MyApp());
```

For GetX, call `unawaited(windowing.applyRoute(routing.current))` from
`GetMaterialApp.routingCallback`. The package itself does not import GetX.

## Transition behavior

- A route change to the active profile is a no-op, so routes inside the dashboard do not
  reset a user's manually chosen window size.
- Rapid requests interrupt an active transition and start from the actual current bounds.
- A single ticker owns the frame-driven fallback. Native bounds animation is used only when
  `Window.animateBounds` reports support.
- User maximize, minimize, and fullscreen states are preserved rather than forcibly resized.
- `WindowGeometryStore` is an optional persistence boundary. The host application supplies its
  own storage adapter.

## Verification

Run the package tests with:

```sh
cd packages/desktop_windowing
flutter test
```

Native frame animation and manual resize interruption still require visual validation on the
target Windows/Linux/macOS window manager.
