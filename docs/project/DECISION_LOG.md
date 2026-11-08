# NetSales Dashboard — Decision Log

| USERS-002 | 2026-11-08 | Deliver a read-only platform user detail view using the existing UserResource and security endpoints; expose device/session/security data only to callers with `auth.view`. | APPROVED |

## USERS-002 — Platform User Detail
- Detail identity and account settings are sourced from `GET /api/v1/users/{id}`.
- Session data is sourced from `GET /api/v1/security/users/{id}/sessions` and is shown only when the caller has `auth.view`.
- Device and security-ban relationships are shown only when Laravel includes them for an `auth.view` caller.
- Device registration tokens are secrets and must never be serialized to the Dashboard.
- The initial delivery is read-only. Mutations must be delivered as complete workflows with server permission checks and confirmed endpoint contracts.

| ARCH-001 | 2026-11-08 | Data response models inherit their corresponding pure-Dart Domain entities; JSON parsing remains in Data, and repositories return these model instances directly through Domain contracts. Each remote datasource contract has a separate ApiService-backed `*_impl.dart` implementation registered in its feature Binding. | APPROVED |
