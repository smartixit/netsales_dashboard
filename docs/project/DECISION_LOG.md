# NetSales Dashboard — Decision Log

Dashboard-specific decisions are maintained here. Shared product/API/financial decisions remain canonical in `netsales_api/docs/project/DECISION_LOG.md`.

| ID | Date | Decision | Status |
|---|---|---|---|
| DASH-001 | 2026-11-07 | Establish reusable desktop window management as a standalone local Flutter package with route-based profiles and centralized transition coordination. | APPROVED |
| DASH-002 | 2026-11-07 | Use `window_manager 0.6.x` native API behind the package boundary; use native bounds animation when supported and a single controlled ticker fallback otherwise. | APPROVED |
| DASH-003 | 2026-11-07 | Keep Dashboard-specific project state, decisions, and work history in this repository; keep shared API contracts canonical in the API repository. | APPROVED |

## DASH-001 — Reusable Desktop Window Management
- **Status:** APPROVED
- **Authorization:** User approved the complete window-management plan and explicitly instructed implementation.
- **Decision:** Profiles are independent per major route family (Splash, Authentication, Dashboard). Transitions are coordinated centrally and do not execute from widget build methods.
- **Constraints:** Do not force a shared fixed size across all routes. Preserve user maximize/fullscreen/manual sizing behavior and skip redundant profile applications.

## DASH-002 — Native API and Animation Strategy
- **Status:** APPROVED
- **Decision:** Use the current `window_manager 0.6.x` API, not `legacy.dart`. Prefer native bounds animation where `Window.animateBounds` reports support; otherwise use one package-owned frame driver. Do not promise identical native animation behavior on all operating systems.
- **Verification:** Package API compatibility and real Windows smoothness remain unverified until Flutter and Windows runtime tests execute.

## DASH-003 — Project Memory Boundaries
- **Status:** APPROVED
- **Decision:** Dashboard implementation state and history stay in this repository. The Laravel API repository remains authoritative for shared API and business contracts. No API files are changed by this task.

| DASH-004 | 2026-11-08 | Build one persistent nested Platform Dashboard shell with a single permission-driven navigation registry; keep all module routes inside that shell and use canonical Laravel role/permission assignments. | APPROVED |
| DASH-005 | 2026-11-08 | Do not fabricate dashboard aggregates or financial figures. Keep KPI values neutral and chart states empty until the API exposes a verified dashboard overview contract. | APPROVED |
| DASH-006 | 2026-11-08 | Keep global navigation/action search local to the authorized route registry until an entity-search API contract is available. | APPROVED |

## DASH-004 — Platform Main Layout
- **Decision:** One persistent shell owns Sidebar, Topbar, Page Header, and nested route outlet. A single Navigation Registry filters destinations using PermissionService; child route middleware repeats the client-side UX check.
- **Role source:** API RolePermissionSeeder is canonical. ACCOUNTANT does not receive `support.view` in the current API seeder; support tickets remain hidden.
- **Boundary:** Client navigation checks do not replace Laravel authorization. Backup and scheduled-task items are restricted to SUPER_ADMIN in the UI because dedicated permission keys are absent; API-side authorization remains to be verified.

## DASH-005 — Overview Data Integrity
- **Decision:** No local calculation of authoritative balances, financial totals, or server-owned KPI values. No placeholder chart series or simulated activity records.
- **Current blocker:** API routes reference a DashboardController for `GET /api/v1/dashboard/overview`, but no such controller exists in the current API source tree. The Overview therefore displays neutral unavailable KPI values and empty chart states until a real contract is implemented.


| DASH-007 | 2026-11-08 | Consume the Laravel \`GET /api/v1/dashboard/overview\` contract as the single source for Overview KPIs, chart series, attention queues, and recent activity; retain permission-aware rendering and zero client-side financial calculations. | APPROVED |

## DASH-007 — Live Platform Overview Contract
- **Authorization:** User explicitly requested implementation of the real-data Overview and approved continuation.
- **Decision:** Overview presentation consumes one server aggregate response through Clean Architecture and GetX. The client may format/display values but must not derive authoritative totals, balances, trends, or accounting figures.
- **Scope:** Periods \`7d\`, \`30d\`, \`90d\`, \`12m\`; permission-aware metric groups, chart series, attention queues, and recent activity.
- **Verification boundary:** Source integration is implemented, but runtime/CI and rendered visual verification are pending.
