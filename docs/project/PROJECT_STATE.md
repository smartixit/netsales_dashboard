# NetSales Dashboard — Project State

**Last updated:** 2026-11-09  
**Repository:** `smartixit/netsales_dashboard`  
**Working branch:** `feat/premium-authentication-experience`  
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



## Platform Users — Initial Operational Screen (2026-11-08)
- Added the Platform Users feature with data source, repository contract/implementation, use case, GetX binding/controller, and a responsive users directory screen.
- Uses the existing `GET /api/v1/users` endpoint through `ApiService.getList`, server-side text search, server-side status filtering, and cursor-based forward pagination.
- User rows are mapped through the existing `UserModel` / API `UserResource`; role/status/last-login are displayed only when returned by the API.
- The route is protected by the existing `users.view` permission middleware. The server remains the authorization boundary.
- Creation, editing, deletion, role filtering, and detail actions are intentionally not exposed in this first delivery: role-list API availability and the relevant UI workflows/contracts must be delivered in their own verified scope; no dead buttons or guessed endpoints are introduced.
- Verification status: source changes committed; CI/analyzer/tests and live API data verification pending. No visual QA is claimed.


## Platform User Details — Initial Delivery (2026-11-08)

- Added a nested, `users.view`-guarded detail route under the persistent Dashboard shell.
- Detail data is loaded through the existing `ApiService` from `GET /api/v1/users/{id}`, with typed Data/Domain mapping and a dedicated GetX Binding/Controller.
- The detail page presents authoritative identity, role, account status, 2FA state, password-change requirement, login attempts, and server timestamps.
- For users with `auth.view`, the page additionally requests active sessions from `GET /api/v1/security/users/{id}/sessions` and renders device/security-ban relationships returned by the user detail resource.
- Device status/type labels are resolved through the existing `EnumPresentationRegistry` and rendered using `CustomStatusBadge`.
- The directory now navigates to the corresponding user detail route.
- No edit, reset-password, session-termination, ban/unban, or delete controls are exposed yet; those operations require their own fully implemented, permission-aware workflows.
- API dependency: PR #7 (`netsales_api`) scopes device/security-ban relationships to `auth.view` and removes FCM registration tokens from device resources. Merge this API hardening before relying on the detail screen's security boundary.
- Validation: source and model/route tests committed; current-head CI, full tests, and Windows compile are pending. No rendered visual QA is claimed.


## Platform Networks Management — Initial Delivery (2026-11-08)

**Branch:** `feat/platform-networks-management`

- Added the Platform Networks feature using the existing Laravel NetworkResource and network-management routes.
- Added Domain entity, Data model inheriting that entity, a separate `PlatformNetworksRemoteDataSource` contract and `PlatformNetworksRemoteDataSourceImpl`, repository contract/implementation, and dedicated Use Cases.
- Added GetX controllers and Bindings for the directory and detail routes.
- The directory uses server-side search, status filtering, cursor pagination, responsive mobile cards, the shared Syncfusion DataGrid, and the existing export adapter for loaded rows.
- Network status KPIs are read from the existing permission-aware `dashboard/overview` response; no client-side totals or financial values are calculated.
- Detail view supports server-backed information editing, approval, and rejection with a required reason. Buttons are shown only when the corresponding `networks.*` permission is present; Laravel remains the security authority.
- Added Arabic/English localization and route/model tests.
- Unsupported provider/POS counts, financial metrics, network activity timeline, and create form are not fabricated; they remain outside this initial delivery until their exact data contracts and complete workflows are integrated.

### Verification boundary
- Source and tests are committed on the feature branch. The GitHub Actions workflow is configured to run the full analyzer, full Flutter tests, and Windows Debug build on the pull request.
- No local Flutter execution or rendered Windows/Web visual QA is claimed from this execution context.


## Platform POS Management — Initial Delivery (2026-11-08)

**Branch:** `feat/platform-pos-management` (based on the current Platform Networks feature branch).

- Added the Platform POS feature using the existing Laravel `PosResource`, routes, and status contract.
- Added `PlatformPosModel extends PlatformPosEntity`, with typed JSON parsing and no `toEntity()` conversion.
- Added separate `PlatformPosRemoteDataSource` and `PlatformPosRemoteDataSourceImpl`, repository contract/implementation, and list/detail/approve/reject Use Cases.
- Added GetX list/detail controllers and feature Bindings.
- Added a responsive directory with server-side search/status filters, cursor pagination, shared Syncfusion DataGrid, responsive cards, loaded-row export, status badges, and server-sourced POS KPIs.
- Added detail view for POS identity, owner, contact, geography, approval/rejection timestamps, and rejection reason, plus permission-aware name/email/address editing.
- Supported name, email, and address edits use the existing PUT resource contract. Approval/rejection actions are exposed only to SUPER_ADMIN and only for PENDING records, matching the inspected Laravel controller/service behavior. Rejection requires a reason.
- Added Arabic/English localization and model/route tests.
- POS creation, memberships, wallet balances, sales, and financial details are not fabricated or exposed in this initial slice; they require their own complete workflows and permission-aware contracts.

### Verification boundary
- Source and tests are committed to the feature branch. CI/Windows compilation is not claimed from this execution context.
- No rendered visual QA is claimed.


## M11 — Platform Network–POS Relationships (In Progress)

**Branch:** `feat/platform-network-pos-links`

- Added a dedicated `platform_network_pos_links` feature for the global Network–POS relationship records exposed by `/network-pos`.
- The feature covers server-side search/status filtering, cursor pagination, relationship details, create, status update, and unlink.
- Creation selectors reuse the existing Network and POS list Use Cases with remote search and only offer ACTIVE records. The Laravel service revalidates both entities as active.
- Relationship Models extend pure-Dart Domain Entities. The feature has distinct RemoteDataSource and RemoteDataSourceImpl contracts, repository, Use Cases, GetX controllers, and route Bindings.
- Access is SUPER_ADMIN-only because the inspected `NetworkPosPolicy` grants global management through its `before()` bypass only to SUPER_ADMIN. Non-super-admin index results are tenant-membership scoped; no broader platform access is fabricated.
- Membership administration is explicitly excluded: operational membership routes are guarded by Operational Workspace Scope and are not part of the Platform Scope dashboard.
- Creating a link causes Laravel to create a missing POS wallet for that network with an initial balance of 0.00. Unlink removes the NetworkPos relation only; the service does not delete the wallet.
- No client-side wallet or financial calculations are performed.

### Verification boundary
- Implementation and focused model/route tests are committed to the feature branch.
- Flutter analyzer, tests, Windows build, CI, and rendered visual QA have not yet been verified in this execution context.

## M12 — Platform Subscription Management (In Progress)

**Branch:** `feat/platform-subscriptions-center`

- Added a dedicated `platform_subscriptions` feature covering subscription plan catalogue, provider subscriptions, and subscription approval requests.
- Implemented exact API response Models inheriting pure-Dart Domain Entities for plans, plan features, feature catalogue entries, provider subscriptions, feature consumption, and subscription requests.
- Added separate `PlatformSubscriptionsRemoteDataSource` and `PlatformSubscriptionsRemoteDataSourceImpl`, repository contract/implementation, and Use Cases for list/detail/create/update/status/delete, request review, subscription extension, and consumption reads.
- Added GetX controller and Binding with independent cursor state, debounced server search only where the API supports it, stale-response protection, and append loading state.
- Replaced the three subscription placeholders with real permission-guarded nested routes.
- Built a responsive subscription workspace with premium plan cards, interactive plan editor including per-feature quotas, provider subscription lifecycle cards with expandable server-sourced consumption, and approval/rejection request cards.
- Plan quotas use the API's `plan_feature_value` contract; `-1` is rendered and submitted as unlimited. Prices and discounts are rendered from server values only; no financial totals are calculated client-side.
- Request approval and rejection are permission-specific; rejection requires the server-required reason. Approval calls the existing endpoint that atomically creates the subscription and initializes quotas.
- Provider subscription extension uses the existing `additional_days` endpoint contract. Operational early activation and consumption are not exposed as platform actions.
- Added Arabic/English localization and focused model/route tests.

### Security finding and API dependency
- Inspection found that subscription API routes lacked explicit `subscriptions.*` permission middleware despite the seeded permission matrix. Flutter guards are not a security boundary.
- A companion API hardening branch `fix/subscription-api-permissions` adds least-privilege route middleware for plan, feature catalogue, request review, provider subscription read, and extension endpoints. Provider request submission and operational quota consumption/activation remain outside the platform permission gates.
- Dashboard route and action visibility follows the same seeded permission keys.

### Verification boundary
- Flutter analyzer, full tests, Windows build, GitHub Actions, and rendered visual QA are pending PR verification. No local run or visual inspection is claimed.


## Premium Desktop Authentication Polish — 2026-11-09

- Refined the existing Login brand/form composition without changing authentication or API behavior.
- The brand panel now has a clearer identity headline and supporting product descriptor, with one emphasized security pillar and quieter financial-governance / desktop-stability supporting items.
- The form column is vertically centered when available space permits and switches to compact spacing at the centralized desktop height breakpoint; scrolling remains available for short windows.
- Responsive widget coverage has been added for compact, standard, and wide desktop sizes, both themes, and RTL/LTR. CI verification is pending the corresponding PR.
- Live rendered Windows/Web visual QA is still required before declaring the visual delivery fully accepted.


## Document Engine Architecture — Design Only (2026-11-09)

**Review branch:** docs/document-engine-architecture-blueprint  
**Base main HEAD:** 849e0dc902b38433a0a68b7c7c534b749f150118  
**Status:** PROPOSED — awaiting architecture review and explicit approval.

- Added a design-only Architecture Blueprint for one reusable internal package, packages/document_engine.
- The proposal separates generic Document and Reporting responsibilities, defines typed immutable contracts, host adapters, template capability/version rules, rendering policies, and secure backend integration boundaries.
- It specifies three distinct paths: bounded non-official client PDFs, backend-finalized immutable official documents, and backend asynchronous large reports.
- Added an Arabic PDF Typography POC matrix. No text-shaping dependency is selected or added.
- Updated the Dashboard documentation index and recorded DOC-001 as PROPOSED, not APPROVED.
- No Dart/PHP application source, pubspec.yaml, pubspec.lock, API route, migration, invoice logic, PDF template, or dependency was modified.
- No analyzer, test suite, Windows build, or visual QA was run because this delivery contains documentation only.
- Next gate: review the proposed contracts, the Arabic typography POC matrix, and open decisions. Package implementation remains blocked until explicit approval.

## Document Engine — M1 Core Contracts (2026-11-09)

**Architecture:** DOC-001 APPROVED via merged PR #19.  
**M1 scope:** DOC-002 APPROVED.  
**Implementation branch:** `feat/document-engine-core-contracts`.

- Created the initial local package at `packages/document_engine`.
- Implemented typed stable identifiers, exact semantic template versions, locale/direction metadata, typed document values, immutable content nodes/sections/snapshots, structured tables, template capabilities, and exact-version in-memory registry.
- Runtime package dependencies are intentionally empty: Flutter widgets, GetX, PDF/printing, shaping, NetSales models, Laravel, and storage are not dependencies.
- Added focused tests for identifier/value validation, semantic version ordering, snapshot immutability, table shape, locale support, duplicate template versions/defaults, and exact-version lookup.
- Added a dedicated CI job for package dependency resolution, formatting, analysis, and tests. Results remain pending until the PR workflow runs on the exact head SHA.
- M1 does not integrate the package into the Dashboard host application and does not migrate existing exports or official invoices.
- Next: complete exact-head CI, address any failures, review M1 API surface, then stop for user acceptance before M2.

## Document Engine — M1 Repair and M2 PDF Renderer (2026-11-09)

**Implementation PR:** [#32](https://github.com/smartixit/netsales_dashboard/pull/32)  
**Branch:** `feat/document-engine-pdf-renderer-final`  
**Head under strict verification:** `e1bf8be52dd89b620a64adad4cade5b801106d84`

### M1 repair
- Replaced the 13 non-canonical Dart files with the output of the pinned Dart 3.13.7 formatter.
- Repaired the locale-tag and template-locale validators as complete, parseable source.
- Committed the package-specific lockfile to make the internal package dependency resolution reproducible.
- Restored the strict non-mutating format check in CI.

### M2 implementation
- Added the generic `DocumentRenderer` port and typed `DocumentRenderSuccess` / `DocumentRenderFailure` results.
- Added A4 portrait, A4 landscape, and Letter page profiles with validated dimensions and margins.
- Added explicit render options for generation timestamp, page numbering, header/footer, and maximum page count.
- Added the PDF backend for multipage headings, paragraphs, supplied metrics, structured tables, repeated table headings, explicit page breaks, repeating headers/footers, and page numbering.
- Added immutable PDF artifact access, provenance metadata, byte length, and SHA-256 computed internally.
- Added pre-render validation for template/document type, locale, requested template capabilities, and page orientation.
- Complex RTL content is rejected explicitly pending the approved shaping strategy.

### Verification status
- A diagnostic CI run after canonical formatting passed package dependency resolution, static analysis, and all document-engine tests.
- A subsequent strict CI run is evaluating the exact PR head above. Its format, analyzer, test, and desktop-windowing outcomes must be recorded from the completed run; no overall pass is claimed while it is still running.
- No preview/printing UI, official invoice migration, Laravel API, financial logic, or host application integration is included.

## Premium Authentication Flow — In Progress (2026-11-09)

**Branch:** \`feat/premium-authentication-experience\`

- Extended the shared authentication scaffold with a reusable step-progress slot, retaining the premium Login brand/form composition.
- Added shared progress, security notice, and authentication result components; applied them to Forgot Password, OTP, 2FA, Password Reset, Success, and Unauthorized screens.
- Fixed Forgot Password → Login route handling to reveal the existing Login route when it is directly underneath recovery, or clear the stack before creating a new Login route. This prevents two Login forms from sharing \`LoginController.formKey\`.
- Removed ScreenUtil scaling from shared password-requirement item geometry.
- Added navigation regression and responsive progress widget tests.
- Authentication API/domain behavior and backend security authority are unchanged. WNS/Reverb remains deferred.
- **Verification pending:** exact-head formatting, analyzer, tests, Windows Debug build, and rendered Windows/Web QA.
- Next: evaluate CI on the final PR head, fix any diagnostics, then halt for user review and merge.


## Document Engine M4 — Arabic PDF Typography POC (2026-11-09)

**Status:** ACTIVE — isolated research harness; provider not selected.  
**Branch:** feat/document-engine-arabic-typography-m4-poc  
**PR:** #36

- Added packages/document_engine_poc as an isolated research package outside the Dashboard app and production document_engine dependency graph.
- The harness contains a fixed synthetic Arabic/mixed-direction corpus, baseline pdf rendering, a HarfBuzz/pdf_text_shaper candidate, and a pure-Dart payv candidate.
- IBM Plex Sans Arabic Regular and Vazirmatn Regular are byte-for-byte test fixtures with their SIL OFL 1.1 licenses.
- Native Ubuntu/Windows CI and a Dart-to-JavaScript compile job are configured. Run 42635009795 was in progress at the latest check.
- Production renderer behavior remains unchanged; complex RTL is still rejected.
- Next: fix any exact-head CI failures; obtain and inspect candidate PDF artifacts in Windows and Web viewers; record extraction/copy/search, shaping, glyph coverage, font embedding, mixed bidi, pagination, size, and timing; then prepare a separate provider recommendation for explicit owner review.


## Document Engine — M4 Closed / M5 Active (2026-11-09)

**M4 status:** COMPLETE — constrained Arabic PDF research outcome recorded.  
**PR:** #36  
**Research candidate:** Payv 0.1.2 (not approved for production).

- Vowel diacritics are excluded from acceptance. Arabic joining, RTL, mixed Arabic/Latin runs, numeric identifiers, font embedding, pagination, and table wrapping remain core considerations.
- Native PDF generation succeeded on Windows and Ubuntu for all three POC candidates.
- Payv was the strongest constrained research candidate. Latin/numeric runs inside RTL paragraphs require Unicode LTR isolates (U+2066/U+2069).
- Payv JavaScript compilation is the Web evidence for M4; browser runtime generation and preview/viewer accessibility remain deferred.
- No production dependency, renderer switch, API, Laravel feature, or official invoice integration was made. The complex-RTL rejection guard remains in place.

**M5 status:** ACTIVE — generic ReportDefinition, typed criteria/presentation, Configuration Studio, and versioned preset contracts.
- M5 is independent of production Arabic provider selection.
- No server endpoints, storage adapter, tenant ownership policy, or financial calculations are included.
- Next: implement pure report contracts and validation first, then framework-neutral preset serialization/migration contracts, followed by the Flutter Configuration Studio entry point and responsive widget tests.


## Document Engine — M5 Report Configuration (2026-11-09)

**Status:** IN PROGRESS — first contract and Studio implementation on branch  
**Branch:** `feat/document-engine-m5-report-configuration`

- Added the initial typed report schema model: report identity/version, allowed filters and choices, output columns, server-provided metric slots, template references, locales/page profiles, execution policy, and an optional explicit client row bound.
- Added typed filter criteria and validation against the schema allowlist; criteria contain selections only, never report result records.
- Added presentation options and schema validation for column visibility, sort/group permissions, template, locale, page profile, and metric/chart capability toggles.
- Added versioned SavedReportPreset JSON serialization and compatibility assessment. Unsupported preset schemas or changed report schemas require explicit review rather than silent migration.
- Added a controlled, responsive Flutter Configuration Studio entry point independent of GetX, application routing, API execution, and persistence.
- No Laravel endpoint/schema, user/tenant ownership policy, preset persistence implementation, financial computation, or production Arabic PDF provider integration is included.
- **Verification pending:** exact-head format, Dart analysis, unit/widget tests, Windows package compilation as required by the workflow, and PR CI.


### M9 additional evidence
- Added a second independent Flutter host example, branded Northstar Labs, with its own save/share/print adapters and no GetX dependency.
- Migrated the existing MediaPdfViewerCard preview surface to the shared `DocumentPdfBytesPreview` widget. Existing byte loading, cache behavior, and external-open action remain unchanged; the migration does not fabricate DocumentArtifact provenance for imported files.

## Platform Billing administration — ACTIVE / VALIDATION PENDING (2026-11-11)

API branch: smartixit/netsales_api:feat/platform-billing-admin-contracts
Dashboard branch: smartixit/netsales_dashboard:feat/platform-billing-management

- The Billing Center now has dedicated product/plan authoring, immutable plan-version history/publication, trial/dunning policy administration, published-policy assignment, pending trial-redemption review, and audited active-trial adjustment surfaces.
- GetX bindings/controllers and typed Data/Domain contracts are used for the new workflows. Presentation is composed from existing NetSales custom design-system widgets.
- Financial amounts are submitted and displayed as API-authoritative decimal strings per currency. No client-side currency conversion, financial arithmetic, entitlement decisions, or trial date calculations are introduced.
- Access is aligned with the API: billing.view for reads, billing.create for product/plan records, billing.edit for Draft construction/assignment, and billing.manage for publication, policies, and trial review.
- Acceptance is blocked on exact-head CI: model tests, full flutter analyze lib test integration_test, complete flutter test, and Windows Debug compile must pass. Rendered Light/Dark and LTR/RTL QA remains unverified until reviewed.
- Keep both PRs in Draft until CI failures are repaired; do not merge or call the implementation production-ready before exact-head checks pass.

## Shared DataGrid Render Overflow — 2026-11-11

- Active repair branch: `fix/dashboard-datagrid-render-overflow`.
- The shared grid now selects tabular vs. compact card presentation from its actual allocated width using `AppBreakpoints.dataGridCompactMax`, not the global window width.
- Cursor/page pagination wraps on narrow allocations; toolbar count chips wrap; Platform Networks and Platform POS share the same centralized cutoff.
- Focused widget regression tests cover narrow RTL pagination with long Arabic text and the wide tabular presentation.
- Exact-head CI, local analyzer/tests, Windows build, and rendered visual QA remain pending. Do not claim the overflow is fully verified until these gates complete.


## DataGrid Render Overflow — CI remediation update (2026-11-11)

- Full Windows workflow logs were retrieved and reviewed for the prior PR head. The DataGrid-specific regression tests passed.
- The prior full-project run exposed independent blockers in Platform Billing compile/analyzer contracts, authentication test initialization/layout, compact sidebar geometry, and a password-route test timeout.
- Targeted fixes were committed on `fix/dashboard-datagrid-render-overflow`; all exact-head analyzer, full test, and Windows Debug gates must be rerun before acceptance.
- PR #47 remains Draft and unmerged. Do not mark this issue resolved until the new workflow is green and rendered visual QA is reviewed.


## Document Engine production-readiness repair — IN PROGRESS (2026-11-11)

- Active repair branch: `fix/document-engine-production-readiness`.
- Corrected the Cartesian chart point-count validation from the accidental 100-point allowance to the documented 24-point maximum; added 24/25 boundary regression coverage.
- This focused correction is not a production-readiness pass. Arabic/complex RTL remains rejected pending an explicitly approved provider and complete target/viewer evidence. Template-specific layout execution and host-injected branding/design-system contracts remain unresolved.
- No package transfer to `smartixit/netsales` has started. Do not copy the package until all package defects are resolved and exact-head CI/test evidence passes.
- Flutter/Dart tests, analyzer, formatting, and visual QA have not been run in this environment.


## Document Engine production-readiness repair — IN PROGRESS (2026-11-11)

- Active branch: fix/document-engine-production-readiness.
- Chart point-count validation now matches the documented 24-point Cartesian limit; boundary regression test added.
- Added bounded host-provided image nodes and image template capability enforcement.
- Added a framework-neutral brand contract for organization name/tagline, semantic colors, logo bytes, and semantic font assets; renderer applies brand fonts/identity.
- Added four actual PDF composition strategies (standard, executive, compact, receipt) selected by each versioned template.
- Added host-injectable Report Configuration Studio primary actions. Internal filter controls still need a broader host-control integration contract.
- RTL/Arabic shaping remains a release blocker; do not enable Arabic or copy the package to NetSales while this remains unresolved.
- Package formatting/analyzer/tests, malformed-asset validation, PDF inspection, and cross-target visual QA are not yet executed. The exact-head GitHub Actions run is pending.


### Report Studio host design-system integration
- Added `filterSectionBuilder` and `presentationSectionBuilder` contracts alongside the existing `actionBuilder`. The host can now replace the complete schema-filter and output-presentation control surfaces, not just Preview/Save buttons.
- Added widget regression coverage that asserts the injected host sections replace the package-default controls.
- This removes the package-level injection-point gap; the NetSales adapter still must implement these builders using its approved shared widgets before feature rollout.
