# NetSales Dashboard — Project State

**Last updated:** 2026-11-07  
**Repository:** `smartixit/netsales_dashboard`  
**Working branch:** `feat/desktop-windowing-foundation`  
**Base commit:** `c5de57619e672c74a82d1d17883abf8aba9f220e`

## Current work
Desktop windowing foundation is in progress.

### Completed in this branch
- Created reusable local package `packages/desktop_windowing`.
- Added profile, constraints, animation configuration, geometry resolver, route-profile mapping, persistence interface, native controller, and non-desktop stub.
- Added geometry and route resolver unit tests.
- Added Dashboard host window profiles and initialized the controller before the first visible Flutter frame.
- Connected GetX route changes to profile requests.
- Reworked CI to be read-only, include feature branches, remove the unsupported Android compile job, and add focused package checks.

## Not yet verified
- Flutter dependency resolution and lockfile synchronization.
- Dart analyzer and package unit tests.
- Full Dashboard analyzer, test suite, and Windows Debug build.
- Native animation behavior and manual resize interruption on a real Windows window.
- End-to-end route transitions. The current copied Dashboard route registry does not yet contain Splash, Login, or Dashboard production screens; route profile mappings are prepared for those route names but the actual screens/navigation must be delivered in their own authorized work.

## Known baseline blockers
- The copied application bootstrap still contains mobile-oriented initialization and references missing mobile classes.
- The current route registry contains only developer showcase routes and does not register the configured initial Splash route.
- Existing full-project CI had broad analyzer/build failures before this windowing work. These are not claimed fixed by the windowing foundation.

## Next steps
1. Run package dependency resolution, analyzer, and tests in a Flutter 3.47.9 / Dart 3.13.7 environment.
2. Fix any API or analyzer mismatches in the package.
3. Integrate actual Splash/Login/Dashboard route screens when those routes exist.
4. Perform Windows visual validation of resize smoothness, interruption, display bounds, and user-controlled maximize/restore.
