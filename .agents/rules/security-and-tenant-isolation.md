---
trigger: always_on
description: Flutter client-side authorization boundaries and tenant context propagation.
---

# Rule: Security and Tenant Isolation Invariants (Flutter)

## 1. Client-Side Checks are Presentation-Only
- All client-side role checks, workspace switches, and UI permission toggles exist solely to improve usability and navigation.
- Flutter checks do **NOT** provide security enforcement.
- The Laravel API is the sole authorization authority. Never rely on client state to prevent unauthorized data access.

## 2. Platform Scope and Tenant Context
- Platform Dashboard endpoints MUST follow their actual Laravel route and permission contract. Do not invent or attach Network/POS tenant identifiers to global Platform Scope requests.
- When a feature explicitly operates on a Network or POS resource, pass the tenant context required by the API and rely on Laravel to validate membership and permission.
- Never infer platform authority from a client-side role label or route name.

## 3. Graceful Authorization Failure
- On 401 Unauthorized or 403 Forbidden responses, handle the failure gracefully through the established session and authorization flow. Platform users must not be redirected into Network/POS workspace selection unless the API contract explicitly requires it.
