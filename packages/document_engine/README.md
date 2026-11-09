# document_engine

Reusable, framework-agnostic document contracts and template registry for Flutter/Dart hosts.

## M1 scope

- Stable typed identifiers for documents, document types, and templates.
- Exact semantic template versions.
- Locale and reading-direction metadata.
- Typed document values and immutable content nodes.
- Structured tables with validated column/row consistency.
- Immutable document sections and snapshots.
- Template capability declarations and deterministic in-memory registration.

## Deliberate non-goals in M1

- No PDF rendering or pdf/printing dependency.
- No Arabic shaping provider selection.
- No Flutter widgets, GetX, routing, or application-specific models.
- No Laravel client, API endpoint, authorization policy, or persistence adapter.
- No financial arithmetic, totals, currency conversion, or data aggregation.
- No implicit clock, document numbering, template-version upgrade, or default selection.

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
  supportedLocaleTags: const ['ar', 'en'],
  capabilities: TemplateCapabilities({
    TemplateCapability.tables,
    TemplateCapability.pageNumbering,
  }),
  isDefault: true,
);

final registry = TemplateRegistry()..register(definition);

final selected = registry.require(
  id: templateId,
  version: TemplateVersion(major: 1, minor: 0, patch: 0),
);
```

Decimal values remain canonical base-10 strings and are never converted to floating-point numbers.

## Verification

From the repository root:

```sh
flutter pub get
dart analyze packages/document_engine
flutter test packages/document_engine/test
```
