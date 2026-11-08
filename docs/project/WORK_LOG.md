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
