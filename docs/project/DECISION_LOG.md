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


| DS-001 | 2026-11-09 | The standalone Windows Dashboard and responsive Web use fixed Flutter logical-pixel design tokens. Shared typography, spacing, radii, and theme geometry must not be scaled against the full window. Adaptive composition is handled by AppBreakpoints and actual layout constraints. ScreenUtil may remain temporarily as a compatibility shim for legacy leaf widgets, but width/height/text scaling is disabled globally. | APPROVED |

## DS-001 — Desktop Logical-Pixel Design System
- `AppTypography`, `AppSpacing`, `AppRadius`, and `AppThemes` are expressed in stable logical pixels; TextStyle line-height remains a unitless multiplier.
- ScreenUtil is not a responsive layout engine for this desktop product. It is retained only until all legacy leaf-widget imports are migrated, with all scale factors disabled in the app bootstrap.
- Responsive behavior must select layouts, columns, margins, and bounded content widths through `AppBreakpoints` and actual constraints, never by multiplying all dimensions by the entire window width/height.

| DOC-001 | 2026-11-09 | One internal reusable package, document_engine, with separate Document and Reporting domains, immutable generic contracts, host-supplied adapters, and explicit client/server rendering policies. Official financial artifacts remain backend-finalized and immutable; large reports use backend jobs. | APPROVED |

## DOC-001 — Reusable Document and Reporting Engine (APPROVED)
- Approved by the project owner through review and merge of PR #19 on 2026-11-09. The approval authorizes staged implementation of the internal reusable package within the approved architecture; it does not approve unselected dependencies, API routes/migrations, invoice migration, or official-document renderer changes.
- The first implementation candidate is one local package at packages/document_engine; public extraction is deferred until its API proves stable and reusable by a second host application.
- The package must not depend on NetSales business models, GetX, Laravel clients, host authorization, or application storage services.
- Three generation paths remain explicit: bounded non-official client rendering, backend-finalized official artifacts, and backend asynchronous large-report generation.
- Official artifacts are represented by immutable server snapshots and stored final PDF bytes with template/renderer metadata and a digest. SHA-256 is integrity detection, not a digital signature.
- The Arabic text-shaping implementation, client rendering limits, exact output adapter contracts, and server job endpoints remain open research/design items until their proof-of-concept and contract reviews are approved.
- Implementation is milestone-gated. M1 covers pure-Dart core contracts and the template registry. PDF rendering, Arabic shaping provider selection, backend endpoints, invoice migration, and reporting UI require their own explicit gates.

| DOC-002 | 2026-11-09 | M1 delivers immutable generic document contracts, stable identifiers, exact template versions, capabilities, and deterministic in-memory registry; no renderer, backend integration, persistence, or host UI. | APPROVED |

## DOC-002 — Document Engine M1 Core Contracts
- M1 package path: `packages/document_engine`.
- Runtime package API is Dart-only and framework-agnostic; no GetX, Flutter widgets, Laravel client, NetSales business entities, storage, or rendering dependencies.
- Decimal business values are preserved as canonical base-10 strings; the engine performs no arithmetic, totals, aggregation, rounding, currency conversion, or document numbering.
- Template lookup is exact by `(TemplateId, TemplateVersion)`. Registration rejects duplicate versions and ambiguous default templates per document type.
- Collections exposed by document snapshots and definitions are defensive immutable copies.
- M1 verification must include focused tests and static analysis in a dedicated CI job. No package integration into the host app occurs in M1.

| DOC-003 | 2026-11-09 | M2 introduces a bounded client-side PDF renderer behind a generic renderer port. It must validate template/document compatibility and declared capabilities, use explicit page geometry and generation time, preserve immutable artifact bytes with SHA-256 provenance, and reject complex RTL scripts until a shaping provider is validated. | APPROVED |

## DOC-003 — Document Engine M2 PDF Renderer
- M2 uses the existing `pdf` Dart package as the concrete PDF backend and `crypto` for artifact integrity metadata.
- The package exposes a renderer port and typed success/failure outcomes; renderer-specific widgets and mutable PDF layout objects are not part of the public API.
- Page geometry is expressed in PDF points. Supported initial profiles are A4 portrait, A4 landscape, and Letter portrait; margins must leave a positive printable area.
- Every render operation receives its generation timestamp explicitly and has a bounded page count. The engine does not read the system clock or derive document dates.
- The PDF renderer validates document type, template locale, requested capabilities, and page orientation before layout.
- Artifact bytes are defensively copied and SHA-256 is computed at the artifact boundary. The digest is integrity detection, not a digital signature.
- Complex RTL scripts are rejected explicitly until the separate Arabic typography POC selects and verifies a shaping implementation.
- M2 does not implement official invoice rendering, financial calculations, Laravel APIs, report criteria, preview/printing UI, or host application integration.
