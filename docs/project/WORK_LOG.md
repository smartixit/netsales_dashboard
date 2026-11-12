# NetSales Dashboard — Work Log

## 2026-11-08 — Windows Desktop Typography Scale Refactoring

**Repository:** `smartixit/netsales_dashboard`  
**File Modified:** `lib/core/themes/app_typography.dart`

### Implemented
- Refactored all typography tokens in `AppTypography` to match Windows Desktop enterprise information density and Fluent Design / Material 3 Desktop specifications.
- Completely eliminated `flutter_screenutil` (`.sp`, `.h`) dependencies from typography to prevent unnatural font enlargement and vertical line-height distortion when resizing or maximizing desktop windows.
- Adopted crisp logical pixel sizes (`sizeDisplayLarge: 36`, `sizeHeadlineLarge: 22`, `sizeHeadlineMedium: 18`, `sizeTitleMedium: 14`, `sizeBodyMedium: 13`, `sizeBodySmall: 12`, `sizeButtonLarge: 14`, `sizeButtonMedium: 13`, `sizeInputText: 13`, `sizeCurrencyHero: 28`, `sizeBadge: 11`).
- Normalized `letterSpacing: 0.0` for Arabic cursive text to maintain proper ligatures and glyph connections in IBM Plex Sans Arabic.
- Standardized proportional unitless `height` multipliers (`1.2` - `1.5`) across all text styles.

### Verification
- `flutter analyze lib/`: Passed with 0 errors and 0 warnings (ran in 28.7s).
- `dart format lib/core/themes/app_typography.dart`: Clean.

## 2026-11-08 — Platform User Detail Screen

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/platform-user-details`

### Implemented
- Added `PlatformUserDetailEntity`, device/ban/session domain entities, and typed API detail/session models.
- Extended the existing Platform Users remote data source and repository contract/implementation with detail and session reads.
- Added dedicated `GetPlatformUserDetailUseCase`, `GetPlatformUserSessionsUseCase`, `PlatformUserDetailController`, and `PlatformUserDetailBinding`.
- Added the protected nested route `/dashboard/users/:id` and directory-to-detail navigation.
- Built a responsive detail composition with identity, account information, devices, sessions, and security-ban sections.
- Used server labels and the centralized enum presentation registry; reused project badges, buttons, image, section-header, skeleton, and error components.
- Security sections are hidden unless the current user has the existing `auth.view` permission. Laravel remains the authority and API PR #7 further scopes those relationships server-side.
- Added model mapping and route authorization tests.
- No guessed mutation actions or fabricated data were added.

### Verification
- API PR #7 focused new security test passed in the full CI run. The overall Laravel suite remains red: 117 failures, 186 passes, and 3 skips; the failures are in unrelated legacy feature suites.
- Dashboard CI for this branch has not yet been started. Run analyzer, focused/full tests, and Windows build after opening the PR.
- Live Windows/Web visual inspection is not available in this execution context and is not claimed.

## 2026-11-08 — Platform Users Data/Domain Boundary Repair

**Branch:** `refactor/platform-users-architecture`

- Updated every Platform Users response model to extend its matching Domain entity: user, detail, device, ban, and session.
- Moved wire timestamp parsing into model factories so the inherited Domain properties are already typed as `DateTime?`.
- Removed `toEntity()` mapping and made the repository return model instances through the Domain repository contract.
- Kept `PlatformUsersRemoteDataSource` as the abstraction and `PlatformUsersRemoteDataSourceImpl` as a separate ApiService-backed implementation; wired the implementation explicitly in both directory and detail Bindings.
- Updated model tests to assert direct entity inheritance and optional security relationship handling.
- Pull Request #7 opened. GitHub Actions run #42513044434 was in progress at the time of this entry. No local Flutter test/analyzer or visual QA is claimed.


## 2026-11-08 — Platform Networks Management (Initial Delivery)

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/platform-networks-management`

### Implemented
- Added the Platform Networks Domain entity and NetworkResource model. The model inherits the entity and parses nested owner/governorate/directorate data without `toEntity()`.
- Added separate `PlatformNetworksRemoteDataSource` and `PlatformNetworksRemoteDataSourceImpl`, the repository boundary/implementation, and list/detail/update/approve/reject Use Cases.
- Added list and detail GetX controllers, dedicated Bindings, and guarded nested routes.
- Built a responsive directory with server search/status filtering, cursor pagination, shared DataGrid, responsive cards, loaded-row export, status badges, and server-sourced network KPIs.
- Built a detail header and information panel with permission-aware edit/approve/reject actions and rejection-reason validation.
- Added Arabic/English localization and model/route tests.
- Reused the existing design system and avoided raw Flutter button widgets.

### Boundaries
- The current NetworkResource list does not guarantee owner relation loading, so owner name may be absent in list rows; details display only what the API actually returns.
- POS membership counts, network financial summaries, and network activity are not returned by the inspected NetworkResource; they are not guessed or calculated client-side.
- No local analyzer/test/build or rendered visual QA is claimed. CI verification is pending on the pull request.


## 2026-11-08 — Platform POS Management (Initial Delivery)

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/platform-pos-management`

### Implemented
- Added POS Domain entity and `PlatformPosModel extends PlatformPosEntity`.
- Added separate RemoteDataSource contract/implementation, repository boundary/implementation, and list/detail/approve/reject Use Cases.
- Added GetX controllers and Bindings.
- Built a responsive POS directory with server-side search/status filters, cursor pagination, shared Syncfusion DataGrid, mobile cards, loaded-row export, status badges, and server-sourced KPI cards.
- Built POS detail identity and information surfaces.
- Added guarded nested routes, Arabic/English localization, and model/route tests.
- Approval/rejection actions are restricted to SUPER_ADMIN and pending POS records; rejection reason is validated before calling the server.

### Boundaries
- POS creation, memberships, POS wallets, sales, debts, and network linking are deliberately not included in this first increment. Supported name/email/address editing is included.
- No local analyzer/test/build or rendered visual QA is claimed.


### M10 integration sequencing
- M9 (Platform Networks) was merged into `main` before M10 was retargeted.
- M10 PR #9 now targets `main` directly; its branch retains the merged M9 baseline and contains only the POS feature delta relative to the current main history.


## 2026-11-08 — M11 Platform Network–POS Relationships

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/platform-network-pos-links`

### Implemented
- Added `PlatformNetworkPosLinkEntity` and `PlatformNetworkPosLinkModel extends PlatformNetworkPosLinkEntity` using the exact `NetworkPosResource` contract.
- Added separate RemoteDataSource interface and `PlatformNetworkPosLinksRemoteDataSourceImpl`, repository, and Use Cases for listing, detail, creation, status updates, and unlink.
- Added GetX controllers and feature Bindings, including reuse of existing Network/POS directory Use Cases for remote-search selection.
- Built a responsive relationship directory with search, active/inactive server filters, cursor pagination, Syncfusion DataGrid, mobile cards, loaded-row Excel/PDF export, and detail navigation.
- Built relationship detail view with both entities, relationship status, reference, creation time, activation/deactivation, and confirmed unlink.
- Added Arabic/English copy, SUPER_ADMIN-only navigation/routes/actions, and model/route tests.
- No API changes; all mutations call the existing Laravel endpoints.

### Contract and authorization boundaries
- Only SUPER_ADMIN has global Network–POS management access in the inspected API policy; other roles receive membership-scoped list data. The UI and routes therefore enforce SUPER_ADMIN access.
- Relationship creation is limited to active networks and active POS records. Laravel remains authoritative and rejects inactive entities and duplicate links.
- Laravel creates a missing POS wallet with initial balance 0.00 during link creation. Unlink deletes the relationship record but leaves the wallet untouched.
- Network/POS membership management remains outside Platform Scope because it belongs to operational workspaces and is guarded by operational workspace scope.

### Verification
- Model and navigation tests added; no Flutter analyzer/test/build, GitHub Actions, or rendered visual QA result is claimed yet.

## 2026-11-09 — M12 Platform Subscription Management

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/platform-subscriptions-center`

### Implemented
- Added pure Domain entities and response Models extending those entities for plans, features, plan-feature entitlements, provider subscriptions, feature consumption, and subscription requests.
- Added separate RemoteDataSource interface/implementation, repository contract/implementation, and Use Cases for the verified Laravel API routes.
- Added GetX controller/Binding with cursor pagination, independent request generations, server-side filters, and feature quota selection for plan creation/editing.
- Replaced plan, provider-subscription, and request placeholders with real nested routes.
- Built responsive premium plan cards, feature/limit editor, provider subscription cards with expandable server-reported consumption, and approval/rejection request cards.
- Added extension workflow, status filtering, cursor load-more, inline feedback, loading/empty/error states, and Arabic/English copy.
- Added model inheritance/parsing tests and nested route authorization tests.
- Did not invent subscription KPIs, plan pricing formulas, currency labels, or usage totals.

### API authorization finding
- The existing subscription route group did not enforce the already-seeded `subscriptions.view/create/edit/delete/approve/reject` permissions.
- Opened companion API hardening branch `fix/subscription-api-permissions` to enforce route-level authorization while preserving provider request submission and operational quota consumption/early-activation paths.
- Flutter-only permissions are not treated as the security boundary.

### Verification
- No local Flutter analyzer/test/Windows build or live rendered visual QA is claimed. PR CI is pending.


## 2026-11-09 — Desktop Design-System Scale Correction

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `fix/desktop-design-token-scaling`

### Root cause
- The app initialized `flutter_screenutil` with a mobile design size of 375×812 while the Windows dashboard opens at 1440×900.
- Shared `AppSpacing`, `AppRadius`, `AppTypography`, and portions of `AppThemes` multiplied logical-pixel values by ScreenUtil scale factors. This caused spacing and radii to grow with the desktop window and also enlarged typography.
- Typography had been reverted from the previously reviewed desktop logical-pixel scale in commit `49846d9`.

### Implemented
- Restored fixed desktop typography tokens and unitless line-height multipliers.
- Converted spacing and radius tokens to immutable logical-pixel values; set compact desktop control dimensions and shell heights.
- Removed ScreenUtil from `AppThemes` and replaced scaled strokes, paddings, slider, tooltip, and FAB dimensions with fixed values / shared spacing tokens.
- Kept ScreenUtil temporarily only for compatibility with older leaf widgets, but disabled width, height, and text scaling globally. Responsive composition remains the responsibility of `AppBreakpoints` and actual layout constraints.
- Added a permanent UI engineering rule prohibiting screen-relative units in shared desktop tokens.
- Added regression tests proving typography, spacing, radii, and theme construction do not require ScreenUtil initialization.

### Verification
- Regression tests added; GitHub Actions analyzer, full tests, and Windows build are pending PR CI.
- No live rendered Windows/Web visual QA is claimed from this execution context.


## 2026-11-09 — Premium Desktop Authentication Polish

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/premium-authentication-polish`

### Implemented
- Strengthened the brand-panel hierarchy: clearer product descriptor, larger brand identity and headline, better description contrast, and an explicit platform-pillars section.
- Removed equal visual weighting from the three benefit cards. Security remains the highlighted trust pillar; financial governance and desktop stability are quieter supporting rows.
- Added a centralized desktop compact-height breakpoint and use it to reduce vertical gaps when the authentication window is short.
- Centered the authentication form vertically when space permits while keeping the content scrollable and overflow-safe when the window is compact.
- Increased the login welcome heading to the proper desktop page-heading token.
- Added responsive authentication layout tests for 900×620, 1040×720, 1440×900, 1920×1080, and a compact-width 880×720 case, covering both themes and RTL/LTR.
- Authentication behavior, API calls, controller state, and credential submission were not changed.

### Verification
- Focused responsive widget tests, full Flutter tests, analyzer, and Windows Debug build are pending PR CI.
- No live rendered Windows/Web visual QA is claimed from this execution context.

## 2026-11-09 — Reusable Document Engine Architecture Blueprint (Design Only)

**Repository:** smartixit/netsales_dashboard  
**Branch:** docs/document-engine-architecture-blueprint  
**Base HEAD:** 849e0dc902b38433a0a68b7c7c534b749f150118

### Delivered
- Added docs/architecture/document-engine/ARCHITECTURE_BLUEPRINT.md defining the proposed package boundary, generic document/report contracts, template capabilities/versioning, rendering strategies, PDF layout/pagination, Arabic/RTL, preview/output adapters, backend job/artifact integration, integrity, security, quality gates, and incremental roadmap.
- Added docs/architecture/document-engine/ARABIC_PDF_POC.md to make the Arabic shaping and multi-script typography evaluation evidence-based.
- Updated the Dashboard documentation index.
- Recorded DOC-001 in DECISION_LOG.md as PROPOSED.

### Scope and verification boundary
- Documentation-only change. No package implementation, application code, dependency, pubspec.yaml/lockfile, Laravel API, route, migration, invoice, or PDF template was changed.
- No analyzer, unit/widget test, Windows build, or visual QA was run; this was a design-documentation delivery.
- The exact resolved dashboard lockfile versions were inspected. Printing 5.15.1 and PDF 3.13.1 remain the initial implementation candidates, not a claim of compatibility for every API property without version-specific verification.
- The Arabic shaping package is a research candidate only. No PDF text-shaping dependency is approved or installed.
- Official financial artifacts remain backend-finalized and immutable. Client-generated PDFs are limited to bounded non-official documents.
- Package implementation and dependency changes remain gated on explicit owner approval of the architecture.

## 2026-11-09 — Document Engine M1 Core Contracts

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/document-engine-core-contracts`  
**Base:** `019610b06e822c5e226c87476ca88fd513b378d8`

### Implemented
- Added the local `packages/document_engine` Dart package with zero runtime dependencies.
- Added typed identifiers (`DocumentId`, `DocumentTypeId`, `TemplateId`) and numeric semantic `TemplateVersion`.
- Added locale/direction metadata, typed document values (decimal strings remain exact), content nodes, structured tables, sections, and immutable snapshots.
- Added immutable template capability declarations and an in-memory registry with exact-version lookup, unique-version enforcement, and one default per document type.
- Added package README and strict analyzer options.
- Added focused unit tests for identifiers, decimal validation, version ordering, snapshot collection immutability, duplicate IDs, table consistency, locale matching, registry defaults, and exact-version lookup.
- Added a dedicated Ubuntu CI job for package dependency resolution, format check, static analysis, and tests; the existing Dashboard Windows job now waits for this package job as well.
- Updated DOC-001 to APPROVED based on the merged architecture PR and recorded DOC-002 for the approved M1 scope.

### Scope boundaries
- No PDF/printing or Arabic shaping dependency was added.
- No Flutter UI, GetX, host application dependency, Laravel API, migration, persistence adapter, financial logic, invoice migration, or official document template was changed.
- No package integration into the Dashboard host app was performed.

### Verification
- CI is configured but must be evaluated on the exact PR head SHA. No local Flutter/Dart runtime is available through this GitHub-only execution, so no local analyzer/test outcome is claimed.

## 2026-11-09 — Repair M1 and Implement M2 PDF Renderer

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/document-engine-pdf-renderer-final`  
**PR:** [#32](https://github.com/smartixit/netsales_dashboard/pull/32)  
**Base HEAD:** `69c7ad41d4ef94431c80075808b2580c1d19ad2c`

### M1 repair
- Identified the original M1 CI failure as a canonical Dart formatting failure affecting 13 Dart files; the original formatter step stopped before analysis and tests.
- Used the pinned Flutter 3.47.9 / Dart 3.13.7 formatter to produce the canonical changes.
- Repaired two locale/template validator files after the first formatting diagnostic exposed malformed source; the complete validators were restored and rechecked.
- Added the package-specific `pubspec.lock` to pin the resolved internal package dependency graph.
- Restored the strict non-mutating formatter check.

### M2 implementation
- Added the framework-neutral renderer port and typed rendering outcomes.
- Added validated PDF page profiles for A4 portrait, A4 landscape, and Letter portrait.
- Added explicit render options, bounded page count, and explicit generated-at timestamp.
- Added the `pdf` backend for multipage semantic content, metrics, structured tables with repeated headings, page breaks, repeating header/footer, and page numbering.
- Added defensive artifact byte access, provenance fields, and SHA-256 calculation at the artifact boundary.
- Added template/document, locale, capability, and orientation validation.
- Added tests for PDF signature, artifact digest/provenance/immutability, RTL rejection, template mismatch, orientation capability, printable area, and page-limit input validation.

### Scope boundaries
- No Arabic shaping provider is selected. RTL/complex scripts fail explicitly until the typography POC is completed.
- No report studio, charts, preview/print/share adapters, Laravel API, official invoice migration, business/financial calculations, or Dashboard host integration was added.

### Verification
- Diagnostic CI on the formatted working tree completed document-engine dependency resolution, static analysis, and tests successfully.
- Strict exact-head CI is running separately; final conclusion and each job outcome must be captured before claiming the milestone fully verified.
- No local Flutter runtime or manual visual PDF review is claimed.

## 2026-11-09 — Premium Authentication Flow and Duplicate Login Route Repair

**Repository:** \`smartixit/netsales_dashboard\`  
**Branch:** \`feat/premium-authentication-experience\`

### Implemented
- Extended the shared \`AuthScaffold\` with an optional flow-progress region while preserving the premium Login brand/form composition and responsive layout.
- Added reusable \`AuthFlowProgress\`, \`AuthNoticeBanner\`, and \`AuthStatusPanel\` components.
- Redesigned Forgot Password, OTP verification, Two-Factor Authentication, Password Reset, Success, and Unauthorized screens with purpose-specific hierarchy and security guidance.
- Fixed Forgot Password → Login navigation: pop to the already-mounted Login route when it is directly underneath recovery, instead of replacing recovery with a second Login route. If that route ancestry is absent, clear the stack before creating Login. This prevents duplicate mounting of the Login form key.
- Removed ScreenUtil scaling from the shared password-requirement item to preserve stable desktop logical-pixel dimensions.
- Added a route-stack regression test and extended responsive authentication layout coverage for the progress component.

### Scope boundaries
- Authentication use cases, repository contracts, API calls, token/session handling, and backend authorization were not changed.
- No runtime dependency was added. Windows WNS/Reverb remains deferred.

### Verification status
- Exact-head Flutter formatting, analyzer, focused/full tests, Windows Debug build, GitHub Actions, and rendered Windows/Web visual QA remain pending.


## 2026-11-09 — Document Engine M4 Arabic Typography POC Harness

**Repository:** smartixit/netsales_dashboard  
**Branch:** feat/document-engine-arabic-typography-m4-poc  
**PR:** #36  
**Implementation head at handoff:** 5416eb31b1cd97209c1580b3cdbc30c974e2de80

### Implemented
- Added isolated package packages/document_engine_poc. It is not imported by the Dashboard app and does not add dependencies to production document_engine.
- Added synthetic Arabic/RTL corpus and table fixtures covering joining, diacritics, lam-alef, mixed Latin/Arabic, punctuation, bidi isolates, Arabic-Indic/Western digits, and preformatted references/amounts.
- Added baseline pdf renderer and isolated candidate implementations for HarfBuzz-backed pdf_text_shaper and pure-Dart payv.
- Added byte-for-byte IBM Plex Sans Arabic Regular and Vazirmatn Regular TTF fixtures, including their SIL OFL 1.1 licenses and upstream blob provenance.
- Added native Ubuntu/Windows CI and a Dart-to-JavaScript compile check for the pure-Dart candidate.

### Boundaries
- No production dependency, renderer switch, public API, Dashboard feature integration, Laravel change, invoice migration, or financial calculation was changed.
- No shaping provider is approved. Production RTL rejection remains the expected behavior until a separate provider decision.

### Verification
- PR #36 is open. Exact-head Actions run 42635067589 was still running at handoff; its jobs were queued/in progress, so no pass is claimed.
- Actual PDF rendering, visual inspection, text extraction/copy/search, font embedding, pagination, output size, and performance still require completed CI artifacts and manual Windows/Web review.
- No local Flutter/Dart execution is claimed in this environment.


## 2026-11-09 — M4 POC Closure and M5 Authorization

**Repository:** `smartixit/netsales_dashboard`  
**M4 PR:** #36  
**M5 decision:** DOC-006 approved by the project owner

### M4 outcome
- Closed the M4 research scope without requiring vowel diacritics.
- Preserved tests for Arabic joining, RTL, mixed Arabic/Latin values, identifiers, punctuation, tables, and pagination.
- Recorded Payv as the leading research candidate, not a production selection.
- Documented the need for Unicode LTR isolates around phone numbers, invoice references, UUIDs, and numeric/currency runs within Arabic paragraphs.
- Replaced the browser rootBundle runtime test with the originally authorized JavaScript compile check. Web runtime/preview acceptance remains for the later preview milestone.
- Production dependencies, renderer behavior, and the complex-RTL rejection guard remain unchanged.

### M5 scope authorized
- Generic application-supplied report definitions and allowlisted filters/fields/sorts/groups.
- Typed criteria and presentation options kept separate from server query authorization.
- A responsive schema-driven Flutter Configuration Studio, independent of GetX/navigation.
- Versioned SavedReportPreset serialization and explicit migration/review outcomes.
- No Laravel routes/schema, persistence, authorization, tenant policy, or financial arithmetic.

### Verification boundary
- Native Windows and Ubuntu generation on the exact pre-closure POC head passed; the final adjusted exact head must rerun POC tests, PDF generation, and JavaScript compilation.
- No browser runtime PDF rendering or production Arabic provider approval is claimed.


## 2026-11-09 — Document Engine M5 Report Configuration Foundation

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/document-engine-m5-report-configuration`  
**Decision:** DOC-006 approved

### Implemented
- Added `ReportId`, schema-declared filter/choice types, output column definitions, metric slots, template references, language/page-profile allowlists, execution policy, and optional client row limit.
- Added typed report filter values, criteria serialization, required/type/choice/length validation, and unknown-filter rejection.
- Added presentation settings and validation for visible columns, sort/group allowlists, templates, locales, page profiles, and chart/metric capabilities.
- Added SavedReportPreset serialization with separate preset/report schema versions and compatibility assessment that surfaces review-required changes without silent migration.
- Added `document_engine_flutter.dart` with a controlled responsive Configuration Studio. State, translation resolution, routing, API access, preview generation, and save persistence remain host responsibilities.
- Added focused tests for schema validation, criteria types/allowlists, presentation capabilities, preset round-tripping, strict unknown-field rejection, schema drift, and controlled widget callbacks.

### Boundaries
- No backend report endpoint, database table, queue, tenant policy, or preset persistence adapter is implemented.
- No financial or reporting aggregation is performed by the engine. Values/metrics remain supplied by the server.
- Production PDF Arabic provider selection remains separate from M5.

### Verification
- Exact-head formatting, analysis, tests, and CI are pending; no verification outcome is claimed before those checks complete.


### M9 migration and second-host reuse
- Added `DocumentPdfBytesPreview` as the shared read-only preview primitive for raw existing PDF bytes. `DocumentArtifactPreview` now composes it.
- Migrated the existing MediaPdfViewerCard preview from a direct PdfPreview instance to `DocumentPdfBytesPreview`; local/remote byte loading, cache behavior, and external-open behavior remain unchanged.
- Added `packages/document_engine/example`, a second host app branded Northstar Labs. It demonstrates independent rendering and output adapters using Flutter Material without importing GetX or NetSales application services.
- Added example run instructions. The example's Save/Share/Print actions are host implementations of the package ports.


## 2026-11-10 — Document Output Public API and Dashboard Analyzer Diagnostics

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `fix/document-output-integration-analyzer-errors`  
**Pull Request:** #44

### Root causes and corrections
- Exported `src/output/document_output.dart` from the `document_engine.dart` public barrel so host applications, examples, and tests can consume the output ports, result types, request, and coordinator through the supported package API.
- Corrected `remote_document_job.dart` to import the sibling output contract with `../output/document_output.dart`, removing the duplicate package-internal import and the invalid relative URI.
- Removed the output test's direct import of the package-private implementation path; it now tests through the public barrel.
- Added the explicit document-engine public import to `PlatformDashboardBinding` for `DocumentOutputCoordinator`.
- Added the missing `AppRadius` token import to `PlatformOverviewScreen`.
- Added and forwarded the optional `backgroundColor` argument through `CustomButton.outline`, preserving the welcome-panel's intended translucent button surface.
- Applied the repository-pinned Dart formatter to the nine files previously identified by the strict document-engine formatting gate. The one-time helper workflow was removed in the same formatter commit and is not part of the final tree.

### Scope boundaries
- Dashboard Flutter and the reusable document-engine package only.
- No Laravel/API, database, authorization, tenant, or financial behavior changed.
- No temporary workflow remains in the branch.

### Verification status
- GitHub Actions run [42711215313](https://github.com/smartixit/netsales_dashboard/actions/runs/42711215313) completed successfully: Flutter 3.47.9 / Dart 3.13.7 setup and `dart format packages/document_engine` succeeded; nine files were formatted.
- The follow-up PR checks on the formatter bot commit entered `action_required` without creating jobs. A repository-authored documentation commit is being used to trigger the exact-head PR checks again.
- No local `flutter analyze` or `flutter test` result is claimed; the local execution environment has no Flutter/Dart SDK. Await exact-head GitHub Actions for package analysis/tests, full dashboard analysis/tests, and Windows compilation.


## 2026-11-10 — Windows Dashboard ThemeExtension Collection Compile Fix

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `fix/dashboard-layout-theme-extension-map`

### Root cause and correction
- The Windows build error occurred in `NetSalesDashboardThemeAdapter.wrap`: a typed list literal combined with a spread of `ThemeData.extensions.values` and triggered an invalid recursive `ThemeExtension<dynamic>` generic element inference in the Windows AOT compilation path.
- Replaced the list reconstruction with a typed copy of the existing extension map, replaced the entry under `DashboardLayoutTheme.type`, and passed the resulting map values to `ThemeData.copyWith`.
- This retains every unrelated ThemeExtension and replaces an existing DashboardLayoutTheme entry without duplicate keys or unchecked casts.
- Added a widget regression test that verifies unrelated extensions survive and the host DashboardLayoutTheme is replaced by the NetSales adapter value.

### Scope
- Dashboard theme adapter and its widget regression test only.
- No design tokens, colors, business behavior, API contracts, or window-management behavior changed.

### Verification
- Pending exact-head GitHub Actions: dashboard analysis/tests and Windows Debug compilation.
- No local Windows build is claimed; the reported MSBuild/AOT diagnostic is the target regression to be checked by CI.


## 2026-11-11 — Platform Billing Workspace Foundation

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `feat/platform-billing-management`

### Implemented
- Added a dedicated `platform_billing` feature with pure domain entities, typed wire-status enums, remote data source, resource models, repository contract/implementation, use cases, GetX controller, and binding.
- Added the first billing workspace with overview, plans, subscriptions, invoices, payments, treasury, and currency selection surfaces.
- Replaced the three legacy subscription navigation entries with one `billing.view`-gated Billing Center route.
- Added focused model tests for exact enum wire values, plan/version/price mapping, and currency-separated overview summaries.

### Contract and financial safety
- Matched Flutter models to Laravel Billing API Resources rather than the legacy subscription endpoints.
- Financial summary values are returned as decimal strings by Laravel per currency; Flutter renders these values without calculating or aggregating money.
- Preserved cursor-based list loading and request-generation guards against stale subscription, invoice, and payment responses.

### Verification boundary
- No Flutter SDK or repository command runner was available in this GitHub-only execution. Formatting, analyzer, unit tests, Windows build, and visual QA remain unverified and must run on the exact PR head SHA.
- Mutating billing workflows (plan/version authoring, policy lifecycle, account/subscription provisioning, payment review actions, trial adjustment, refunds/credit notes, and reconciliation UI) remain incomplete.
- No PR has been opened and no merge is claimed.


## 2026-11-11 — Billing Search Contract Integration

- Extended subscription search from the presentation controller through GetX use case, domain repository, data repository, and remote datasource.
- Search refresh now resets the cursor and reloads subscriptions, invoices, and payments; server-side search is authoritative and existing request-generation guards prevent stale results from replacing newer results.
- The Laravel contract was extended in the paired API branch to search subscriptions by account/network/plan identifiers and names.
- Verification: no Flutter SDK command execution, analyzer, tests, desktop build, or visual QA was available in this GitHub-only session. Exact-head validation remains mandatory.


## Platform billing plan version history integration — 2026-11-11

- Added the Dashboard data/domain contract for cursor-paginated plan version history and connected it to Laravel's `GET /platform/billing/plans/{planId}/versions` endpoint through RemoteDataSource, Repository, UseCase, and GetX Binding.
- Added an expandable version-history view to plan catalogue cards, showing exact server-sourced status, currency-specific decimal prices, and plan feature values. The client does not calculate or convert amounts.
- Corrected model constructors so price decimal strings and per-currency financial summary decimal strings are accepted and mapped consistently. Added the trial policy version ID to the plan-version entity/model.
- Expanded model tests for version history, unlimited resource limit values, and server-formatted price amounts.
- Relevant commits: `e1bb4b59`, `8324ffca`, `64dc5532`, `42163e83`, `b3734805`, `318d32c0`, `2cc17d75`, `b246f0d2`, `546783e0`, `8152a712`, `b2aef067`, `18ffd387`, `99f2298c`.
- Commands executed: GitHub source reads and file/commit operations only. Flutter format/analyzer/tests/Windows build and rendered visual QA were not executed.


- Follow-up constructor inspection corrected model/entity wiring for server-formatted price amounts, financial summary decimal strings, and trial policy version IDs. Added a model test for version history and authoritative decimal strings. These tests have been authored but not executed.

## 2026-11-11 — Platform Billing authoring and policy administration

Repository: smartixit/netsales_dashboard
Branch: feat/platform-billing-management

### Implemented
- Added product and plan authoring through the DataSource → Repository → UseCase → GetX Controller flow. Plan creation explicitly orchestrates plan record, Draft version, initial currency-specific price, and optional first feature.
- Added resumable workflow checkpoints so a failed later step does not intentionally re-create already completed plan/version/price steps on retry.
- Added Draft-only additional price and feature operations, with currency-precision and duplicate checks before submission. Laravel remains the final validator and the only source of monetary conversion/calculation.
- Added plan version publication as a distinct billing.manage action. Draft price/feature and policy assignment controls are restricted to billing.edit.
- Added typed product, trial policy, dunning policy, policy-version, and trial-redemption domain models and wire mappers.
- Added versioned trial/dunning policy list/history/create/revision/publish flows, assignment of published policy versions to Draft plan versions or prices, pending trial-redemption review, and audited active-trial adjustments.
- Added a dedicated policies section in the Billing Center. Product/plan and policy forms use shared NetSales custom fields, dropdowns, switches, dialogs, status badges, and buttons.
- Consolidated duplicate legacy/new policy controller methods into one definition per operation. Added guards against concurrent plan/product and policy mutations.
- Added focused model contract tests for product/price policy references, trial/dunning policy snapshots, nested trial-redemption context, plan versions, and currency-separated overview figures.

### Authorization and financial invariants
- Product/plan create, Draft construction, publication, policy administration, and trial decisions map to Laravel permissions: billing.create, billing.edit, billing.manage, and billing.view.
- Published plan/policy versions are immutable. Policy links can be assigned or cleared only while the plan version or price belongs to a Draft.
- Currency values are submitted as decimal strings. Flutter validates display precision but does not calculate minor units, convert currencies, determine entitlement, trial expiry, invoice amounts, or accounting entries.

### Verification boundary
- No local Flutter/Dart SDK is available in this execution environment. The newly added model tests have not been run; formatting, analyzer, complete test suite, Windows Debug compilation, and rendered Light/Dark QA remain unverified.
- The Dashboard GitHub workflow triggers on pull requests targeting main; a Draft PR is required for exact-head CI evidence. No merge is claimed.

## 2026-11-11 — Shared DataGrid Render Overflow Remediation

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `fix/dashboard-datagrid-render-overflow`

### Root cause and correction
- The shared `AppDataGrid` selected its tabular/card presentation from the global MediaQuery device width. When embedded in a narrower desktop content pane, split layout, or resized window, the grid still selected the desktop layout even though its actual allocation was compact.
- Directory widgets duplicated the numeric 760 dp cutoff instead of referencing a shared breakpoint.
- The cursor/page pagination footer kept its label and navigation controls in one unbreakable Row. Long localized labels could exceed the actual inner width.
- Added the centralized `AppBreakpoints.dataGridCompactMax` and made `AppDataGrid` select its compact card presentation, hide grid-only exports, and choose its pager from the actual bounded LayoutBuilder width.
- Made toolbar count chips wrap and made pagination stack its label above the navigation controls below 480 dp of inner width.
- Aligned Platform Networks and Platform POS directory presentation with the shared breakpoint.
- Added widget regression coverage for a 420 dp RTL allocation with a long Arabic cursor label and for a wide allocation retaining the tabular grid.
- Updated the reusable DataGrid responsive documentation.

### Scope
- Shared DataGrid presentation and responsive breakpoint only.
- Platform Networks/POS list breakpoint alignment.
- No API, data/domain contracts, financial logic, permissions, or pagination semantics changed.

### Verification
- Widget regression tests have been added but have not yet been executed.
- Flutter analyzer, complete test suite, and Windows Debug build remain pending exact-head GitHub Actions.
- No rendered Windows/Web visual QA is claimed from this GitHub-only execution context.


## 2026-11-11 — CI Blocker Remediation Follow-up

### Evidence reviewed
- Retrieved the full Windows workflow job log for run `42996096464` at PR head `36802e9d8d7c6145c7eaacf56086f1c78b200237`.
- The shared DataGrid regression tests passed in that run. The full test suite still failed for unrelated existing dashboard/auth/billing code.
- Analyzer failures were concrete: duplicate billing API constants, an outdated trial-adjustment call signature, inferred/unchecked map types, and async mutation futures returned from validation try blocks without awaiting.
- Windows compilation failed on the same duplicate billing declarations and outdated trial-adjustment call.
- Authentication layout widget tests exposed missing ScreenUtil initialization and a horizontal overflow in the test render tree. A separate compact-sidebar test exposed a 9 dp icon/padding overflow.
- Password recovery navigation test timed out because it awaited the route future before navigating back.

### Changes applied on this branch
- Removed duplicate Platform Billing API constant declarations without changing endpoint paths.
- Updated the trial-adjustment UI call to pass the required subscription ID positionally, matching the controller/use-case contract.
- Added explicit empty JSON payload and collection types, and typed billing map conversions.
- Awaited policy mutation futures inside their FormatException handling scope so asynchronous failures remain caught.
- Added the missing GetX lifecycle override annotation.
- Initialized ScreenUtil in authentication layout tests.
- Removed excess compact-sidebar icon padding to fit the collapsed rail.
- Changed the password navigation test to initiate route navigation without awaiting the route's completion future.

### Verification status
- These fixes are committed to the active PR branch. They are not considered verified until a fresh GitHub Actions run completes against the latest PR head SHA.
- The DataGrid-specific widget tests passed on the previous SHA, but all full-project gates must be rerun after these fixes.
- Rendered visual QA remains a separate acceptance gate; no visual pass is claimed.


## 2026-11-11 — Document Engine correctness repair (in progress)

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `fix/document-engine-production-readiness`

### Confirmed defect and correction
- The Cartesian chart contract and error message documented a maximum of 24 points per series, while constructor validation accidentally allowed up to 100. The mismatch was corrected to enforce the declared 24-point limit.
- Added boundary regression coverage for 24 accepted points and 25 rejected points.

### Remaining blockers (not represented as fixed)
- Production Arabic/complex RTL rendering remains intentionally rejected. The M4 POC identifies Payv only as a research candidate; it is not approved for production, and Web runtime/viewer acceptance is incomplete. No dependency/provider has been added.
- Template metadata/capabilities are not yet a distinct template-layout execution strategy in the PDF renderer; the generic renderer still composes the content tree. This requires architectural repair and tests before package transfer.
- Configuration Studio host design-system injection and branding/font/logo contract need further work and verification.

### Verification
- Source and regression test changes are committed to this branch.
- No Flutter/Dart SDK is available in this execution environment; these tests, formatting, analyzer, and package test suite have not been executed. Do not treat this correction as package acceptance.
- No files have been copied to `netsales`; transfer remains blocked until package-level blockers are resolved and verified.


## 2026-11-11 — Document Engine rendering and host integration repair (in progress)

**Repository:** smartixit/netsales_dashboard  
**Branch:** fix/document-engine-production-readiness

### Implemented in this increment
- Enforced the documented 24-point Cartesian chart boundary and added 24/25 regression coverage.
- Added a bounded DocumentImage node with defensive byte copies, PNG/JPEG signature checks, explicit fit/alignment/caption/size controls, and template capability enforcement.
- Added host-supplied DocumentBranding to render options: organization identity, semantic colors, logo bytes, and bounded TrueType/OpenType font roles. PDF rendering now uses supplied base/bold fonts, applies brand identity to cover/content composition, and embeds the supplied logo.
- Added explicit template composition strategies: standard, executive, compact, and receipt. They produce different title hierarchy, density, alignment, logo placement, and brand accent treatment.
- Added a ReportConfigurationStudio.actionBuilder extension point so the consuming application can supply its own design-system Preview/Save buttons without coupling the package to NetSales widgets or GetX.
- Added tests for branding/image defensive-copy contracts, image capability rejection, distinct template render digests, brand render path, and host-provided Studio actions.

### Remaining production blockers
- Arabic/complex RTL remains rejected until a provider passes the full target matrix and searchable/copyable text acceptance.
- Studio filter/selection controls still use generic Flutter Material widgets; only primary actions are host-injectable so far. A host control-builder strategy is still required before strict design-system integration.
- Template layouts are now distinct composition modes, but they still share the common content-node renderer. Invoice, receipt, and financial-document-specific design composition and visual QA remain to be completed.
- Image signature/size checks are not a full decoder safety validation; renderer error handling and malformed image corpus tests remain required.
- Font embedding, font licensing, fallback behavior, and PDF extraction/searchability require tests with actual licensed NetSales fonts.

### Verification status
- Changes are committed on the repair branch. No local Flutter/Dart SDK is available in this execution context; formatting, analyzer, tests, PDF artifact inspection, and Windows/Web visual rendering have not yet run.
- Exact-head GitHub Actions has not yet run for the current HEAD. The repository quality workflow includes document_engine format/analyze/test gates and requires a PR targeting main.
- Nothing has been copied into smartixit/netsales; transfer remains blocked until package-level CI and acceptance gates pass.


## 2026-11-11 — Cross-platform validation repair (in progress)

**Repository:** `smartixit/netsales_dashboard`  
**Branch:** `fix/document-engine-production-readiness`

### Findings from exact-SHA CI run `59d0a8822b7504032e721648c5b65d73be9f2a97`
- Windows package format, analyzer, and all document-engine tests passed; the generated Windows host also built successfully.
- iOS device and simulator builds both passed without code signing.
- Android validation did not start because the third-party setup action attempted to install the retired Android SDK package named `tools`; replaced that action with explicit use of the runner's preinstalled SDK, license acceptance, and installation of platform-tools / Android 36 / build-tools 36.
- Arabic POC matrix jobs failed before analysis/tests because the source was not Dart-formatted. Updated the cross-platform workflow to apply canonical formatting before analyzing/testing, rather than aborting before the substantive checks.
- The dedicated Windows Arabic POC workflow already demonstrated that formatter normalization, static analysis, and Payv JavaScript compilation can run; its PDF generator/test stages are being followed through separately.

### Current acceptance status
- Windows package tests + Windows host build: PASS on the recorded SHA above.
- iOS device + simulator builds: PASS on the recorded SHA above.
- Android: BLOCKED on runner SDK bootstrap; setup was repaired and awaits a fresh exact-SHA run.
- Arabic renderer/provider: NOT APPROVED. A PDF generator compiling is not sufficient; generated artifacts, extraction/searchability, shaping, mixed-direction values, and visual review on Windows, Android, and iOS remain required.
- No package copy to `smartixit/netsales` and no legacy invoice renderer replacement have occurred.


## 2026-11-11 — Report Configuration Studio host-control integration (in progress)

- Added framework-neutral `ReportStudioFilterSectionBuilder` and `ReportStudioPresentationSectionBuilder` extension points.
- NetSales can now render every filter and presentation control using its own approved design-system components; the package's generic Material implementation remains a fallback for independent consumers.
- Added widget regression coverage proving both injected sections replace the built-in controls.
- This closes the package API extensibility gap, not the consuming-app integration work. No raw Material control is to be used by the NetSales feature adapter.
- Verification awaits the next exact-HEAD Windows/macOS package CI run.


## 2026-11-11 — Approved NetSales Reporting and Document Engine Scope

- User approved the complete staged adoption plan, including operational reporting and business documents first, followed by Platform Billing reports and invoices in the Dashboard as the final product-domain stage.
- User explicitly requires removal of legacy report and invoice-document generation paths from the NetSales app, while preserving operational invoice entities, APIs, repositories, use cases, screens, and accounting workflows.
- The package source branch is `fix/document-engine-premium-rendering`. The package was extended with generic semantic document composition nodes: information grid, status banner, financial summary, callout, and divider; A5 portrait/landscape page profiles were added for compact vouchers.
- PDF renderer support was added for these semantic nodes. The existing fail-closed Arabic shaping guard is extended to inspect every newly added text-bearing node. Arabic output remains blocked until a shaping provider is integrated and verified.
- Added focused tests for semantic-node validation/immutability, PDF rendering, RTL rejection, and A5 geometry. These tests are authored but deliberately not executed because the user requested all tests, reviews, and GitHub Actions to run only at the final stage.
- No operational reports, subscription reports, or billing invoice providers have been implemented in this step. The work is following the approved order: package foundations first, then NetSales integration, shared API operational reporting, operational document flows, legacy output cleanup, and Platform Billing reports/documents last.
- No GitHub Actions workflow, PR review, or build has been triggered during this implementation stage.


## 2026-11-12 — Document Input Resource Bounds

- Added a shared bounded-copy helper so section, snapshot, table, chart, information-grid, and financial-summary collections are checked while iterating, before the full collection is materialized.
- Added hard limits for snapshot sections/content nodes, section nodes, table rows/columns/cells, chart series/points, semantic collections, and binary image/signature payload copies.
- Added focused regression cases for oversized snapshots, tables, and image assets. Tests were authored only; they were not executed, in accordance with the requested final-stage verification freeze.
- This increment does not resolve Arabic shaping. Complex RTL remains fail-closed and the package is not yet declared production-ready.

- Follow-up hardening normalized the bounded-input implementations, added a 100-entry bound for table column weights, and added a lazy-iterable regression case proving that the section limit is enforced before the entire iterable is consumed. No test or CI command was run.

- Added a snapshot-wide text budget: individual text fields are capped at 100,000 characters and all caller-supplied document text at 2,000,000 characters, including table cells, chart labels, metadata, and semantic nodes. Regression tests were authored for per-field and aggregate overflow; verification remains deferred.


## 2026-11-12 — Payv Arabic shaping provider integration foundation

- Selected and pinned Payv 0.1.2 as the pure-Dart OpenType and UAX #9 provider following the project owner's explicit request to settle Arabic shaping and mixed-direction handling.
- Added PayvTextShapingProvider: paragraph-direction-aware bidi resolution, visual bidi run ordering, script itemization, per-run Arabic/Latin shaping, OpenType GSUB/GPOS, cluster source mapping, missing-glyph rejection, and TrueType outline validation.
- Added ShapedPdfTextLine to paint shaped glyph outlines as vector paths in the existing pdf widget tree. It is intentionally fixed single-line and rejects overflow; it does not silently clip or reverse mixed runs.
- Bundled IBM Plex Sans Arabic Regular and the upstream SIL OFL 1.1 notice, declared the assets in the package manifest, and exposed a Flutter asset loader.
- Added focused tests for Arabic joining, mixed Arabic/Latin/currency/identifier runs, LTR isolates, Arabic-Indic/Western digits, and the single-line contract. Tests were authored but NOT run.
- Updated the package README and recorded decision DOC-012.
- Remaining production blockers: integrate the provider into every text-bearing node in PdfDocumentRenderer; implement measured paragraph wrapping and multipage flow; repeated table headers/cell wrapping; metadata/header/footer/cover/watermark/chart/QR/signature paths; searchable/selectable text tagging and extraction; viewer/print/save/share parity; and final Windows/Android/iOS/Web verification.
- No tests, formatter, analyzer, build, or GitHub Actions were executed, per the user's explicit final-stage verification instruction.


## 2026-11-12 — Shaped PDF path and measured paragraph flow

- Verified the exact upstream pdf 3.12.0 graphics API and corrected the glyph painter: Payv's `GlyphPath.toPdfPath()` emits PDF content syntax, whereas `PdfGraphics.drawShape()` parses SVG path syntax. The painter now emits MoveTo/LineTo/CubicTo/ClosePath commands directly to PdfGraphics, using Payv's cubic-converted outline commands.
- Added ShapedPdfParagraph. It shapes and measures candidate lines before wrapping, keeps the requested paragraph base direction for each line, handles explicit paragraph separators, and uses the PDF package's spanning Column layout so the paragraph can continue across MultiPage pages.
- Added a conservative grapheme-boundary fallback for long unspaced identifiers and focused tests for the paragraph contract. Tests remain unexecuted.
- Exported the paragraph widget and documented the integration boundary.
- Production RTL remains fail-closed: these primitives are not yet injected into all PdfDocumentRenderer node builders, table cells, running headers/footers, cover fields, watermark, chart labels, signature/QR captions, and other text-bearing output paths. Unicode extraction/search/accessibility tagging is also still unresolved.
- No tests, formatter, analyzer, builds, or Actions were run.


## 2026-11-12 — Renderer-wide RTL and searchable text integration

- Added provider injection to PdfDocumentRenderer so the host explicitly supplies a validated, embeddable/subsettable OpenType face. The renderer no longer blocks all RTL when this provider is present; it continues to fail closed without one.
- Routed every renderer-owned Text/Paragraph call through a central text gateway. RTL/mixed strings in metadata, titles, section headings, semantic nodes, tables, chart labels/legends, captions, signatures, branding, cover data, and running headers/footers now use Payv shaping and paragraph flow.
- Propagated explicit paragraph/heading direction and per-cell/info-grid direction into the shaped text path.
- Added a hidden Unicode text layer under each visible vector-outline line. The original logical Unicode sequence is written LTR/in logical order using the same licensed font and PDF invisible text rendering mode, while Payv supplies the visible glyph outline geometry and bidi order.
- Cached the PDF font object per shaping-provider instance to avoid reparsing and embedding font data for every line.
- Improved paragraph flow: resolve UAX #9 paragraph base direction once, preserve inter-word whitespace, wrap by measured shaped advances, and use the characters package for full Unicode grapheme segmentation.
- Kept Arabic watermark text fail-closed because the PDF package's page-level watermark decorator bypasses the shared shaped text gateway.
- Updated renderer tests to cover injected-provider rendering across paragraphs, headings, tables, headers, cover metadata, branding, and semantic nodes. Added paragraph direction resolution tests. Tests remain unexecuted.
- No tests, formatter, analyzer, builds, or GitHub Actions were run.
