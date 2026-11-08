# NetSales Dashboard — Project State

**Last updated:** 2026-11-08  
**Repository:** `smartixit/netsales_dashboard`  
**Working branch:** `feat/platform-main-layout`  
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

## Recent CI #55 verification and follow-up cleanup
- Run [#55](https://github.com/smartixit/netsales_dashboard/actions/runs/42478869409) tested the exact branch HEAD `71fbd8c5167340ea37f1151fddd2c6245c85834a`.
- The Desktop Windowing package analyzer/tests passed, and focused Splash/Authentication analysis reported no issues.
- The complete Flutter test suite passed **130 tests**, including DataGrid export and Dashboard Metrics overflow regression coverage.
- Windows Debug compilation succeeded and produced `build/windows/x64/runner/Debug/NetSales.exe` with 0 native build errors.
- The full analyzer step failed only on two informational lints: `unnecessary_library_name` in the package barrel and `prefer_initializing_formals` in the native controller constructor.
- Follow-up source changes remove both lints without reducing the public geometry-resolver injection seam. The status caption spacing now uses shared `AppSpacing` tokens. The showcase interaction test targets the containing `ChoiceChip` instead of its inner text to avoid a hit-test warning.
- Verification of these follow-up changes is pending a new CI run for the resulting current HEAD.

## Verification status
- Run #55 conclusively verifies: package checks passed, focused Splash/Auth analysis passed, all 130 Flutter tests passed, and Windows Debug compilation passed.
- Run #55 overall conclusion is **failure solely because full `flutter analyze` returned exit code 1 for the two informational diagnostics described above**.
- The current follow-up commit must be checked independently for a clean full analyzer, a still-green complete test suite, and a successful Windows Debug build.
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

## Platform Main Layout delivery (2026-11-08)

### Implemented in source; CI/visual validation pending
- Persistent nested Platform Dashboard shell with Sidebar, Topbar, Page Header, and one route outlet.
- Permission-driven navigation for SUPER_ADMIN, SUPPORT_AGENT, and ACCOUNTANT, matching the API permission seed assignments. ACCOUNTANT does not receive `support.view` in the current API seeder; support tickets remain hidden.
- Expand/collapse sidebar, automatic collapse below desktop breakpoint, responsive drawer below 900 dp, compact topbar on narrow screens, persisted Arabic/English locale, RTL/LTR from active locale, and existing Light/Dark ThemeService.
- Platform Overview composes Dashboard Metrics, Syncfusion chart cards, recent activity timeline, and audit DataGrid. KPI cards show neutral unavailable values and charts remain empty until server aggregate data exists.
- Notifications and audit records use existing API endpoints through typed repository/use-case layers.
- Shared command palette, notification center, section header, filter bar, date range selector, activity timeline, profile menu, shortcut hint, and status banner components are added.

### Known integration boundaries
- `GET /api/v1/dashboard/overview` is registered in API routes but the referenced DashboardController is absent from the current API source tree. Aggregate KPIs, trend series, distribution data, and attention queues remain unavailable. No fake data is used and no API changes were made.
- Global search indexes permitted routes/actions only; entity search awaits a server contract.
- Backups and scheduled tasks are client-visible only to SUPER_ADMIN because dedicated permission keys are absent; API-side authorization must be verified.
- Other module destinations are route placeholders pending their feature-specific delivery.

### CI verification — exact HEAD 35a913eb3cf1dead647d58075a1f89f0bd0cfba8
- Run [#42491537717](https://github.com/smartixit/netsales_dashboard/actions/runs/42491537717) completed with **success** on the exact current branch HEAD.
- Desktop windowing package analysis and tests passed.
- Full Dashboard `flutter analyze` passed.
- Focused Splash/Authentication analysis passed.
- Full Flutter test suite passed.
- Windows Debug compilation passed.
- The earlier duplicate-local and unawaited-future analyzer diagnostics in `PlatformDashboardController` were corrected in the verified HEAD.

### Remaining validation and delivery boundaries
- Live rendered Windows/Web visual QA remains outstanding: resize/transition behavior, focus/hover, keyboard/mouse, RTL/LTR, Light/Dark, and minimum 1120×720 window behavior. No visual pass is claimed.
- `GET /api/v1/dashboard/overview` remains unavailable for aggregate data because the referenced DashboardController is absent from current API source. No fake KPI, chart, attention, or financial values are supplied.
- Non-overview module destinations remain route placeholders pending their separately scoped feature delivery.
- Pull Request [#2](https://github.com/smartixit/netsales_dashboard/pull/2) is open and has not been merged.


## Platform Overview — Live API Integration (2026-11-08)
- **Dashboard branch:** \`feat/platform-main-layout\`
- **Current implementation HEAD:** \`d3053d48773620dd1ee44208050af4c86ba293b9\`
- Added typed Overview domain entities and JSON model mapping for period, permission-filtered metrics, charts, attention queues, and recent activity.
- Added \`GET /api/v1/dashboard/overview?period=7d|30d|90d|12m\` data-source integration through the existing ApiService, repository contract/implementation, use case, and Dashboard Binding.
- Replaced neutral placeholder KPI values and API-unavailable banners with server-returned metrics; added server-backed chart series, period selection, attention queue navigation, refresh/loading/error/stale handling, and Arabic/English labels.
- Recent activity is now read from the Overview response rather than requiring a separate audit endpoint request. The activity section reuses the existing timeline component.
- **Backend PR #3 was merged** into \`netsales_api\`; merged head \`99f8066cb9f2a40cd8289981de50323c1608ea30\`. Its CI run still reports failure in Composer security audit due to dependency advisories; this is not a passing verification.
- **Important verification boundary:** The latest Dashboard CI run observed before this state update tested an earlier HEAD (\`c10af366...\`), not the current HEAD. The latest commits have not yet been validated by Flutter analyzer/tests/Windows build. No visual QA is claimed.
- **Known integration item:** Backend currently returns recent activity rows for audit-authorized users or support-ticket creation activity for support-only users. It does not synthesize activity when neither source permission is available.
