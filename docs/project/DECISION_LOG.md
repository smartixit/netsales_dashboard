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


| LINK-001 | 2026-11-08 | Platform Network–POS relationship management is SUPER_ADMIN-only, matching NetworkPosPolicy and the API's global index scope. Deliver link listing, detail, creation, status update, and unlink using the existing API contract. Exclude tenant membership management from Platform Scope. | APPROVED |

## LINK-001 — Platform Network–POS Relationships
- The feature consumes `GET/POST /network-pos`, `GET/PUT/DELETE /network-pos/{id}`; it does not add backend endpoints.
- `NetworkPosPolicy::before()` grants global access only to SUPER_ADMIN. Non-super-admin list results are restricted to network/POS memberships, so both directory and detail routes are role-guarded as SUPER_ADMIN.
- Creation requires an active Network and active POS; Laravel validates this in `NetworkPosService::create()`. The server creates a missing POS wallet for the pair with `wallet_balance = 0.00`.
- Status is a boolean, not a fabricated enum. Visual status is resolved through `EnumPresentationRegistry.resolveLinkStatus()`.
- Unlink deletes only the NetworkPos relation; the inspected service does not delete the associated POS wallet. The confirmation must state this clearly.
- Network/POS memberships are tenant operational concerns and are not exposed in this global platform feature.


| SUB-001 | 2026-11-09 | Deliver platform subscription plan management, provider subscription monitoring, and subscription request review as one feature-first module using the existing Laravel resources and endpoints. Keep feature entitlements and consumption values server-authoritative. | APPROVED |

## SUB-001 — Platform Subscription Management
- The module contains three nested destinations: plan catalogue, provider subscriptions, and subscription requests. All require `subscriptions.view`.
- Plan creation/update sends the exact `plan_name`, `plan_price`, `plan_discount`, `plan_validity`, `plan_desc`, and nested `features[{feature_id, plan_feature_value, status}]` fields. A feature quota of `-1` means unlimited per the API model.
- Plan enable/disable is gated by `subscriptions.delete` because the seeded permission description explicitly includes deactivation/deletion; plan editing requires `subscriptions.edit`.
- Request approval and rejection are separately gated by `subscriptions.approve` and `subscriptions.reject`. Rejection requires `rejection_reason`; approval uses optional `request_note`.
- Provider subscription extension uses `POST /provider-subscriptions/{id}/extend` with `additional_days` and requires `subscriptions.edit`.
- Feature consumption is fetched from the dedicated consumption endpoint and displayed as returned. No client-side quota usage or financial calculations are performed.
- The platform dashboard does not expose operational `consume` or `activate-early` actions; those remain in the network workspace context.
- Subscription and feature catalogue endpoints must enforce server-side permission middleware. UI-only permission hiding is insufficient.
