# NetSales Platform Dashboard

Standalone Flutter Dashboard for NetSales Platform Scope roles: `SUPER_ADMIN`, `SUPPORT_AGENT`, and platform `ACCOUNTANT`.

## Targets
- Windows desktop
- Responsive Web

Network and POS operational workspaces remain in the separate `smartixit/netsales` mobile client. Shared product, authorization, financial, and API contracts remain canonical in `smartixit/netsales_api`.

## Architecture
- Feature-first Clean Architecture with GetX.
- Laravel API is the sole authorization and financial authority.
- Reusable dashboard layout, metrics, charts, and DataGrid components live under `lib/widgets`.
- Reusable desktop window management lives in `packages/desktop_windowing`.

## Toolchain
- Flutter 3.47.9
- Dart 3.13.7 or the SDK bundled with the selected Flutter release

Run `flutter pub get`, `flutter analyze`, and `flutter test` from the repository root.
