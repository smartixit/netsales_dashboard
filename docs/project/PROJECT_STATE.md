# NetSales Dashboard — Project State

**Last updated:** 2026-11-07  
**Repository:** `smartixit/netsales_dashboard`  
**Working branch:** `feat/desktop-windowing-foundation`  
**Last verified baseline before Authentication UI delivery:** `ce9bc0ee1b167c21ee74ffdd2f7614d18a60e97a`

## Current work
Desktop windowing foundation and the first production Splash/Authentication presentation flow are implemented on this branch. The reusable window-management package remains independent under `packages/desktop_windowing`; Dashboard-specific profiles and route mapping remain in `lib/core/config/desktop_windowing_config.dart`.

### Completed in this branch
- Created reusable local package `packages/desktop_windowing`.
- Added profile, constraints, animation configuration, geometry resolver, route-profile mapping, persistence interface, native controller, and non-desktop stub.
- Added geometry and route resolver unit tests.
- Added Dashboard host window profiles and initialized the controller before the first visible Flutter frame.
- Connected GetX route changes to profile requests.
- Reworked CI to be read-only, include feature branches, remove the unsupported Android compile job, and add focused package checks.
- Added a responsive Splash Screen and Arabic/RTL Authentication presentation for Login, Forgot Password, OTP Verification, Two-Factor Authentication, and Password Reset.
- Added shared feature-level `AuthScaffold` for the authentication brand/form composition, with adaptive desktop split layout and compact layout behavior.
- Registered production Splash and Authentication routes in `AppPages`, using the existing per-screen GetX Bindings.
- Aligned route constants with controller/guard destinations and added a temporary authenticated landing page because the actual Platform Dashboard home screen is not yet present in this branch.
- Removed references in the Splash boot destination to absent Welcome/Onboarding pages; unverified sessions now land on Login, while sessions validated with the API proceed to the authenticated route.
- Kept the authentication Use Cases, repository contracts, and API data sources unchanged. Updated only Login presentation integration to accept a phone number passed back from password recovery and removed an import to a non-existent pending-support widget.
- Extended only the Dashboard host window route mapping for Reset Password and Unauthorized screens. The package itself was not moved, copied, or modified.

## Not yet verified
- Flutter dependency resolution and lockfile synchronization.
- Dart analyzer and the complete Dashboard unit/widget test suite after the Splash/Auth changes.
- Windows Debug build after the new production routes and screens.
- Native animation behavior and manual resize interruption on a real Windows window.
- Visual QA of Splash and every Auth state on real Windows/Web viewports, both themes, RTL, keyboard and pointer interaction.
- Actual Dashboard home screen integration. The authenticated route currently uses an explicit temporary handoff screen, not a fabricated Dashboard implementation.

## Known baseline blockers and boundaries
- The copied application bootstrap may still contain mobile-oriented initializations or references to mobile classes; this task did not expand into a bootstrap-wide remediation.
- The full Dashboard analyzer previously failed on the baseline commit; this delivery does not claim to have resolved unrelated existing analyzer errors.
- Platform Scope only: no Network/POS workspace selector, onboarding, or commercial account-registration screens were introduced.
- Client guards are UX navigation only. Laravel remains the sole authentication and authorization authority.
- The standalone windowing package remains reusable and independent; Dashboard-specific sizes and route associations are owned by the host app config.

## Next steps
1. Run `flutter pub get` using the declared Flutter 3.47.9 / Dart 3.13.7 toolchain and confirm lockfile synchronization.
2. Run `flutter analyze` and the relevant Splash/Auth/widget tests; classify existing baseline failures separately from this delivery.
3. Build the Windows target and inspect the Splash → Login → recovery/OTP/2FA/reset → authenticated handoff transitions.
4. Perform Windows visual validation of resizing and transitions, plus responsive Web, Light/Dark, RTL and keyboard/pointer checks.
5. Implement the actual Platform Dashboard home feature as its own authorized delivery, then replace the temporary authenticated handoff route.
