# NetSales Dashboard — Decision Log

| USERS-002 | 2026-11-08 | Deliver a read-only platform user detail view using the existing UserResource and security endpoints; expose device/session/security data only to callers with `auth.view`. | APPROVED |

## USERS-002 — Platform User Detail
- Detail identity and account settings are sourced from `GET /api/v1/users/{id}`.
- Session data is sourced from `GET /api/v1/security/users/{id}/sessions` and is shown only when the caller has `auth.view`.
- Device and security-ban relationships are shown only when Laravel includes them for an `auth.view` caller.
- Device registration tokens are secrets and must never be serialized to the Dashboard.
- The initial delivery is read-only. Mutations must be delivered as complete workflows with server permission checks and confirmed endpoint contracts.

| ARCH-001 | 2026-11-08 | Data response models inherit their corresponding pure-Dart Domain entities; JSON parsing remains in Data, and repositories return these model instances directly through Domain contracts. Each remote datasource contract has a separate ApiService-backed `*_impl.dart` implementation registered in its feature Binding. | APPROVED |


| NET-001 | 2026-11-08 | Deliver Platform Networks as a permission-aware management feature using the existing NetworkResource/API contracts. Reuse dashboard overview metrics only; do not invent POS counts, financial indicators, or network activity data. The initial delivery includes directory, details, supported edit, approval, and rejection workflows. | APPROVED |

## NET-001 — Platform Networks Management
- The feature is restricted by `networks.view`; edit, approve, and reject controls additionally require `networks.edit`, `networks.approve`, and `networks.reject` respectively.
- The DataSource interface and ApiService-backed `RemoteDataSourceImpl` remain separate; response Models inherit their Domain Entities.
- Listing search/status filters and cursor pagination are server-side. Client-side sorting/filtering is disabled unless a matching backend query contract is available.
- Network KPI cards use the API's permission-filtered Dashboard Overview response. No local aggregate or financial calculations are allowed.
- Provider creation, POS/subscription/financial/activity subviews, and network-specific reports are deferred until their complete workflows/contracts are verified.


| POS-001 | 2026-11-08 | Deliver Platform POS directory and details using the existing POSResource/API contract. Keep status metrics server-sourced; expose approve/reject only to SUPER_ADMIN for PENDING records, and require a rejection reason. | APPROVED |

## POS-001 — Platform POS Management
- The directory and detail routes require `pos.view`.
- POS status filtering and search use the existing API query parameters; pagination uses the API cursor contract.
- POS approval and rejection are exposed only to `SUPER_ADMIN`, because `PosController` explicitly rejects other roles even if they hold `pos.edit`. Both actions are shown only while the POS is `PENDING`.
- POS KPI cards use `dashboard/overview.metrics.pos`; no client-side aggregation or financial calculations are allowed.
- The POS resource does not provide wallet, membership, sales, debt, or subscription detail collections in this response. Those belong to subsequent features and must not be inferred.
