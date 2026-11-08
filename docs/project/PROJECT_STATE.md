# NetSales Dashboard — Project State

**Last updated:** 2026-11-08  
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

## Recent DataGrid and Dashboard Metrics repair
- Run [#54](https://github.com/smartixit/netsales_dashboard/actions/runs/42477073243) tested `88062b911c4113c828de3d46eb28ac2d45a38786`. The package checks and focused Splash/Auth analysis passed; full analysis, full tests (121 passed / 3 failed), and Windows Debug build failed.
- The DataGrid analyzer, test-compilation, and Windows kernel-snapshot errors shared one root cause: malformed `AppDataGridExportController` class/constructor syntax. The independent Dashboard Metrics test failure came from `_StatusCaption` text overflowing its Row.
- A corrective commit now restores the constructor body and makes status-caption text wrap within available width. Its CI verification is pending; no success is claimed yet.

## Verification status
- GitHub Actions run [#54](https://github.com/smartixit/netsales_dashboard/actions/runs/42477073243) is the latest completed run for the previous HEAD. The package test job passed. Full analysis failed with 23 issues, focused Splash/Auth analysis passed, the complete test suite had 121 passes and 3 failures, and Windows Debug compilation failed while generating the Dart kernel snapshot from the same DataGrid syntax defect.
- The next current-HEAD CI run must be checked independently for the complete analyzer, all Flutter tests, and Windows Debug build. Earlier runs for older SHAs are not evidence for the next commit.
- No rendered Windows/Web visual QA is claimed. Native animation behavior, manual resize interruption, and keyboard/pointer/RTL verification remain outstanding.

## Known baseline blockers and boundaries
- The copied application bootstrap may still contain mobile-oriented initializations or references to mobile classes; this task did not expand into a bootstrap-wide remediation.
- Full Dashboard analyzer health has not yet been demonstrated as clean on the current repair. Existing cross-repository test imports and missing source files from the separate mobile repository may still be present; the next full analyzer result must determine the remaining exact diagnostics.
- Platform Scope only: no Network/POS workspace selector, onboarding, or commercial account-registration screens were introduced.
- Client guards are UX navigation only. Laravel remains the sole authentication and authorization authority.
- The standalone windowing package remains reusable and independent; Dashboard-specific sizes and route associations are owned by the host app config.

## Next steps
1. Verify the next quality-gate run on the exact current branch HEAD: complete analyzer, full test suite, and Windows Debug build.
2. Diagnose any remaining analyzer/test/build failures from their full logs and repair root causes in a coherent batch.
3. Perform Windows visual validation of Splash → Login → recovery/OTP/2FA/reset → authenticated handoff, including resize/transition interruption, plus responsive Web, Light/Dark, RTL and keyboard/pointer checks.
4. Implement the actual Platform Dashboard home feature as its own authorized delivery, then replace the temporary authenticated handoff route.
