# NetSales Dashboard — Project State

**Last updated:** 2026-11-07  
**Repository:** `smartixit/netsales_dashboard`  
**Working branch:** `feat/desktop-windowing-foundation`  
**Authentication UI delivery baseline:** `ce9bc0ee1b167c21ee74ffdd2f7614d18a60e97a`

## Current work
The reusable desktop windowing foundation and the first production Splash/Authentication presentation flow are implemented on this branch. The reusable window-management package remains independent under `packages/desktop_windowing`; Dashboard-specific profiles and route mapping remain in `lib/core/config/desktop_windowing_config.dart`.

### Completed in this branch
- Created reusable local package `packages/desktop_windowing`.
- Added profile, constraints, animation configuration, geometry resolver, route-profile mapping, persistence interface, native controller, and non-desktop stub.
- Added geometry and route resolver unit tests.
- Added Dashboard host window profiles and initialized the controller before the first visible Flutter frame.
- Connected GetX route changes to profile requests.
- Reworked CI to be read-only, include feature branches, remove the unsupported Android compile job, and add focused package checks.
- Added a responsive Splash Screen and Arabic/RTL Authentication presentation for Login, Forgot Password, OTP Verification, Two-Factor Authentication, and Password Reset.
- Added shared feature-level `AuthScaffold` for the authentication brand/form composition, with an adaptive desktop split layout, a compact layout for narrower windows, and the existing theme toggle.
- Registered production Splash and Authentication routes in `AppPages`, using the existing per-screen GetX Bindings.
- Aligned route constants with controller/guard destinations and added a temporary authenticated landing page because the actual Platform Dashboard home screen is not yet present in this branch.
- Removed references in the Splash boot destination to absent Welcome/Onboarding pages; unverified sessions now land on Login, while sessions validated with the API proceed to the authenticated route.
- Kept authentication Use Cases, repository contracts, and API data sources unchanged. Updated only Login presentation integration to accept a phone number passed back from password recovery and removed an import to a non-existent pending-support widget.
- Extended only the Dashboard host window route mapping for Reset Password and Unauthorized screens. Adjusted the Dashboard Authentication host profile to 1040×720 with 900×620 minimum dimensions so the desktop brand/form split is visible at startup. The package itself was not moved, copied, or modified.
- Applied follow-up analyzer fixes to the new presentation files: imported the shared color extension where used, removed an unused route-file import, and used idiomatic interpolation in UI strings.

## Verification status
- GitHub Actions run [#44](https://github.com/smartixit/netsales_dashboard/actions/runs/42404700997) tested commit `95d249c25bd1dca578ebf9068671ef62097383b8`. Its package job passed. Full analysis reported 990 issues (862 errors, 28 warnings, 100 infos); the diagnostics in the newly added Auth presentation files and the unused AppPages import were corrected in the next source update.
- GitHub Actions run [#45](https://github.com/smartixit/netsales_dashboard/actions/runs/42405672764) tested commit `0f6a67e9edf1cda4fe344d8b3e46277c92595a1d`. The package job passed, as did Windows toolchain setup and dependency lockfile verification. Full analysis reported 975 issues (855 errors, 27 warnings, 93 infos).
- GitHub Actions run [#47](https://github.com/smartixit/netsales_dashboard/actions/runs/42406698977) tested the then-current commit `0300c6d7fe723d1aa5b82d22b2bd805c09bbd5c0`. The independent `desktop_windowing` package analyzer and tests passed; Windows toolchain setup and `flutter pub get --enforce-lockfile` also passed.
- Run #47 full `flutter analyze` failed with 973 issues (853 errors, 27 warnings, 93 infos). The single diagnostic inside the Auth repository was an undefined `Get` reference at the permission refresh path: a cleanup commit had removed the GetX import even though `Get.isRegistered<PermissionService>()` remains in use. The import is restored in the follow-up correction; the obsolete WorkspaceService/AppWorkspace logout reset remains removed.
- The remaining analysis backlog is outside the Splash/Auth delivery scope and includes legacy package-path mismatches (`package:netsales/...`), unavailable source files from the separate mobile repository, 292 diagnostics in enum contract parity tests, and a legacy Charts showcase/adapter area. These failures must not be represented as defects in the new Splash/Auth presentation.
- Run #47 skipped the complete Flutter test suite and Windows Debug build because the analyzer step failed. The workflow is being adjusted so these stages run independently after successful dependency resolution, while the full analyzer remains a failing quality gate.
- No rendered Windows/Web visual QA is claimed. Native animation behavior, manual resize interruption, and keyboard/pointer/RTL verification remain outstanding.

## Known baseline blockers and boundaries
- The copied application bootstrap may still contain mobile-oriented initializations or references to mobile classes; this task did not expand into a bootstrap-wide remediation.
- Full Dashboard analyzer health is not clean. Existing cross-repository test imports and missing source files from the separate mobile repository remain outside the requested Auth/Splash presentation scope.
- Platform Scope only: no Network/POS workspace selector, onboarding, or commercial account-registration screens were introduced.
- Client guards are UX navigation only. Laravel remains the sole authentication and authorization authority.
- The standalone windowing package remains reusable and independent; Dashboard-specific sizes and route associations are owned by the host app config.

## Next steps
1. Verify the follow-up quality-gate run on the exact branch HEAD: check the focused Splash/Auth analyzer, full analyzer, complete test suite, and Windows Debug build independently.
2. Resolve remaining cross-repository test imports, enum parity failures, and missing legacy mobile source files under a separately scoped Dashboard foundation/remediation delivery.
4. Perform Windows visual validation of Splash → Login → recovery/OTP/2FA/reset → authenticated handoff, including resize/transition interruption, plus responsive Web, Light/Dark, RTL and keyboard/pointer checks.
5. Implement the actual Platform Dashboard home feature as its own authorized delivery, then replace the temporary authenticated handoff route.
