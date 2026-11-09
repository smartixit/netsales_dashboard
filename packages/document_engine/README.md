# document_engine

Reusable, framework-agnostic document contracts, template registry, and bounded PDF renderer for Dart/Flutter hosts.

## M1 — Core contracts

- Stable typed identifiers for documents, document types, and templates.
- Exact semantic template versions.
- Locale and reading-direction metadata.
- Typed document values and immutable content nodes.
- Structured tables with validated column/row consistency.
- Immutable document sections and snapshots.
- Template capability declarations and deterministic in-memory registration.

## M2 — PDF rendering foundation

- Renderer port with typed success/failure results.
- Immutable page profiles and render options.
- Concrete PDF backend with multipage layout, headers, footers, page numbers, metrics, and structured tables.
- Artifact provenance, byte length, SHA-256 digest, and defensive byte copies.
- Template/document type, locale, capability, and orientation validation before rendering.
- Complex RTL scripts are explicitly rejected until the Arabic shaping milestone; this renderer does not claim Arabic PDF support.

## M3 — Reusable visual components

- Styled multipage tables with repeated headers, compact density, optional alternating rows, border control, and validated relative column weights.
- Metric grids composed only from supplied values; no totals or aggregates are calculated by the engine.
- Native vector bar, line, pie, and donut charts generated from caller-supplied series and categories.
- Chart inputs are bounded (up to eight series, 24 Cartesian points per series, and twelve pie/donut slices) and validated before rendering.
- Chart source labels and optional exact display values are retained in a companion data table; numeric chart coordinates are presentation-only.
- Optional standalone cover page, cover metadata, and first-content-page-specific headers/footers.
- Cover pages are included in the configured maximum page budget.

## Deliberate non-goals

- No Arabic shaping provider selection or RTL PDF output.
- No printing/preview widgets or platform output adapters.
- No Flutter widgets, GetX, routing, or application-specific models.
- No Laravel client, API endpoint, authorization policy, or persistence adapter.
- No financial arithmetic, totals, currency conversion, or data aggregation.
- No implicit clock, document numbering, template-version upgrade, or default selection.
- No reliance on Syncfusion/Flutter UI widget capture for vector PDF charts.

## Usage

```dart
import 'package:document_engine/document_engine.dart';

final documentType = DocumentTypeId('sales.invoice');
final templateId = TemplateId('sales.invoice.standard');

final definition = DocumentTemplateDefinition(
  id: templateId,
  version: TemplateVersion(major: 1, minor: 0, patch: 0),
  documentTypeId: documentType,
  displayName: 'Standard invoice',
  supportedLocaleTags: const ['en'],
  capabilities: TemplateCapabilities({
    TemplateCapability.tables,
    TemplateCapability.metrics,
    TemplateCapability.charts,
    TemplateCapability.coverPage,
    TemplateCapability.pageNumbering,
    TemplateCapability.portraitPage,
  }),
);

final registry = TemplateRegistry()..register(definition);
```

Decimal business values remain canonical base-10 strings. The chart model accepts numeric coordinates only for plotting and retains optional exact display strings separately. The engine does not calculate or aggregate source values.

## Verification

From the repository root:

```sh
flutter pub get
dart analyze packages/document_engine
flutter test packages/document_engine/test
```
