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
