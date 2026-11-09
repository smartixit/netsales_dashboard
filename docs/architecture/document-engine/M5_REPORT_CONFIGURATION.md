# M5 — Report Definitions and Configuration Studio

**Status:** Initial implementation in progress  
**Package:** `packages/document_engine`  
**Authorization:** DOC-006

## Contract boundaries

- `ReportDefinition` is supplied by the consuming application. It is an allowlist of filter controls, output columns, metric slots, templates, locales, page profiles, and rendering policy.
- `ReportDefinitionRegistry` registers immutable report schema versions and resolves them only by exact report ID and version. Missing versions are never replaced with a latest schema.
- `ReportCriteria` stores typed user selections only. It never contains records, arbitrary query fragments, API routes, or tenant/authorization data.
- `ReportPresentationOptions` stores presentation choices only. The engine validates selected columns, sorting/grouping, template, locale, page profile, metrics, and charts against the same definition.
- The backend remains the only authority for permission checks, query execution, tenant isolation, and aggregation.
- A client-capable report must carry an explicit maximum client row count. A server-only report does not expose client pagination as a choice.

## Saved preset contract

A saved preset serializes:
- Stable preset identity and display name.
- Preset schema version.
- Report ID and exact report schema version.
- Typed criteria values.
- Presentation options.

It does not serialize report rows, tokens, signed URLs, tenant identity, permissions, or reusable grants. The JSON decoder rejects unknown top-level fields. An unsupported preset schema fails with an explicit migration/review message. Comparing a preset with a newer report definition produces a review-required compatibility result; no automatic field deletion or reinterpretation occurs.

Persistence, ownership, sharing, retention, and access policy belong to the host/backend and are not implemented in M5.

## Flutter Configuration Studio

The separate `document_engine_flutter.dart` entry point exposes a controlled responsive widget. The host supplies the current criteria/presentation state, a localization-key resolver, and callbacks. The widget does not use GetX, perform API calls, navigate, generate a PDF, or persist presets.

It renders only filters and presentation controls declared in the selected `ReportDefinition`. Preview and Save Preset actions are callbacks, not implicit operations.

## Initial verification matrix

- Domain: unique IDs, schema constraints, filter value types, allowlisted choices, exact registry version lookup.
- Criteria: required filters, unknown IDs, value kind, text length, decimal preservation, valid date ranges.
- Presentation: required/known columns, sortable/groupable fields, template/version, locale, page profile, metrics/charts capabilities.
- Presets: round trip, strict shape, unsupported preset version, report schema drift, wrong report identity.
- Flutter: schema-only control rendering, controlled value updates, responsive composition, host callbacks.
