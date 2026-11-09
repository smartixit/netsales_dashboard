# NetSales Document Engine — Architecture Blueprint

**Status:** PROPOSED — architecture review only  
**Owner:** NetSales Dashboard / shared reusable Flutter capability  
**Date:** 2026-11-09  
**Target package:** packages/document_engine  
**Decision authority:** Explicit project-owner approval is required before implementation  
**Scope of this document:** Architecture, contracts, boundaries, risks, and delivery roadmap. It does not authorize package implementation, dependency changes, invoice migration, or API changes.

---

## 1. Executive Decision

Build one reusable, internally maintained Flutter/Dart package named **document_engine**. It is a document-generation and reporting platform, not a PDF export helper and not a NetSales feature module.

The package is designed for reuse by unrelated Flutter applications. Its stable public contracts must not import or depend on:

- NetSales business entities, API models, routes, permissions, or database identifiers.
- GetX, Provider, Riverpod, Bloc, or any host application's state-management framework.
- NetSales services, design tokens, QR encryption, or business calculations.
- Laravel clients, authentication/session state, or tenant-selection logic.

The package owns generic document composition, template registration, report-configuration primitives, layout and pagination, PDF rendering, document preview components, and output orchestration contracts. The consuming application owns business data retrieval, authorization, branding inputs, localization policy, storage implementations, file destinations, and platform-specific integration.

**Primary architectural rule:** the engine renders supplied data. It does not discover, authorize, aggregate, calculate, or mutate business data.

### 1.1 Rendering strategy decision

Three distinct document paths are mandatory:

| Path | Document class | Generation owner | Flutter responsibility |
|---|---|---|---|
| A | Bounded, non-official reports and internal documents | Client may render from a server-approved bounded snapshot | Compose, render, preview, save, share, print |
| B | Official financial/transactional documents | Backend generates or finalizes and stores an immutable artifact | Retrieve and preview the exact artifact; save/share/print those same bytes |
| C | Large or expensive reports | Backend asynchronous job | Submit criteria, observe job state, retrieve the authorized result |

The caller must select a policy through the application integration. The engine must not silently switch an official document from Path B to Path A because a server endpoint is unavailable.

### 1.2 Initial delivery position

Start as a local package inside the existing repository. Do not publish it publicly, split it into multiple separately versioned packages, or add dependencies before the architecture is approved and a compatibility proof of concept is accepted.

A future extraction or publication is possible after the public API stabilizes and the package demonstrates independent reuse.

---

## 2. Goals and Non-Goals

### 2.1 Goals

1. Produce professional, multi-page PDF documents with repeatable visual quality.
2. Support reports, invoices, receipts, vouchers, statements, and other application-defined document types without embedding those business domains in the engine.
3. Support reusable templates, configurable sections, page profiles, branding, localization, tables, metric cards, charts, footers, headers, covers, watermarks, signatures, and verification marks.
4. Provide a schema-driven report configuration experience that adapts to each registered report definition.
5. Provide a custom PDF preview experience with a single host-controlled toolbar for Share, Save, and Print.
6. Ensure that preview, save, share, and print use the same artifact bytes unless the user explicitly regenerates a new document.
7. Keep official transactional documents immutable and backend-authoritative.
8. Support bounded client rendering and secure asynchronous backend artifacts for large reports.
9. Treat Arabic RTL, mixed Arabic/English content, font embedding, and pagination as first-class engineering requirements.
10. Expose extension points for future projects without requiring changes to the engine core.

### 2.2 Non-goals for the first release

- A full visual WYSIWYG template designer.
- A general-purpose spreadsheet/reporting query language.
- A client-side business analytics or financial-calculation engine.
- A replacement for Syncfusion DataGrid export or existing application export adapters.
- A public cloud document-hosting service.
- A generic authentication, authorization, tenant, or permission framework.
- A QR encryption implementation or QR scanner.
- A legal digital-signature service.
- A raw ESC/POS printer stack. Thermal PDF page sizes may be supported, but direct printer-language support is a separately scoped adapter.
- A second charting framework for application UI.
- Automatic conversion of every existing application PDF into the new package in the first implementation milestone.

---

## 3. Lessons from desktop_windowing

The existing desktop_windowing package is the architectural reference for package discipline, not a source of PDF-specific implementation.

Carry forward these proven patterns:

- A narrow, deliberate public barrel.
- Host-owned configuration rather than package-owned application decisions.
- Reusable value objects and explicit contracts.
- Platform-specific implementation behind a stable interface.
- An explicit unsupported-platform implementation instead of hidden runtime assumptions.
- Host-supplied persistence adapters.
- No dependency on GetX or the host router.
- Documented support boundaries and honest visual-validation requirements.

Do not copy window profiles, native window controllers, or route-profile behavior into document_engine. The document package has different responsibilities and different failure modes.

---

## 4. Package Boundary and Layering

### 4.1 Recommended package shape

The initial package is one package with internal modules and a small set of public entry points.

    packages/document_engine/
      README.md
      CHANGELOG.md
      pubspec.yaml
      analysis_options.yaml
      lib/
        document_engine.dart
        document_engine_flutter.dart
        src/
          core/
          document/
          templates/
          reporting/
          configuration/
          layout/
          pagination/
          typography/
          rendering/
            pdf/
            charts/
            tables/
            text_shaping/
          preview/
          output/
          storage/
          platform/
      test/
        contracts/
        document/
        templates/
        reporting/
        layout/
        pagination/
        typography/
        rendering/
        preview/
        output/
      example/
      docs/

This is a logical architecture, not permission to create these files before approval. It may be simplified where a proposed directory would contain only a trivial wrapper.

### 4.2 Public entry points

- **document_engine.dart** exposes immutable document contracts, template/report definitions, renderer and storage/output ports, artifact metadata, and framework-neutral orchestration interfaces.
- **document_engine_flutter.dart** exposes Flutter widgets for report configuration and PDF preview. It remains independent of the host's state-management solution.
- Internal implementation types remain under src and are not imported directly by consuming applications.

Only add a further public entry point when a real integration use case requires it. Avoid exposing internal renderer classes merely for convenience.

### 4.3 Dependency direction

    Consuming Application
      ├── Business/API adapter
      ├── Permission and tenant policy
      ├── Branding, fonts, locale policy
      ├── Storage / file-export / sharing adapters
      ├── Host state management and routing
      └── document_engine public API
              ├── Document and Report contracts
              ├── Template registry
              ├── Layout and pagination
              ├── Renderer abstraction
              ├── PDF renderer implementation
              ├── Preview and configuration widgets
              └── Output orchestration

The package must never import an application adapter. Dependency injection flows inward from the host.

### 4.4 Separation of pure and Flutter-dependent code

Pure Dart contracts and policies must remain separable from Flutter widgets. The PDF renderer may use the Dart PDF package. Preview and configuration widgets necessarily use Flutter, but no state-management framework is mandated.

A consuming application may wrap a widget with GetX, a different state manager, or local host state. The package widget must not create hidden application-wide state or register dependencies globally.

---

## 5. Responsibility Matrix

| Concern | Document Engine | Consuming Flutter App | Laravel / authoritative backend |
|---|---|---|---|
| Document layout and pagination | Owns | Supplies options | May generate official artifact |
| Template registration | Defines registry contract | Registers app templates | Stores official template/version metadata where required |
| Branding and fonts | Accepts injected profiles/assets | Supplies brand identity and approved fonts | Supplies official snapshot metadata when relevant |
| Business data | Accepts typed document snapshot | Maps API data to generic contract | Retrieves, filters, aggregates, authorizes |
| Financial calculations | Prohibited | Prohibited | Sole authority |
| Report criteria schema | Renders declared controls | Defines report schema and allowed controls | Validates supported criteria and authorization |
| Permissions | No permission decisions | Uses permission data for UX only | Enforces every request and file retrieval |
| Tenant isolation | No tenant knowledge | Sends required context through app adapter | Validates tenant ownership/membership |
| PDF rendering | Client path only where policy allows | Chooses an approved template | Official and large-document rendering |
| Preview | Reusable UI surface | Routes and hosts the screen | Provides protected artifact |
| Save/share/print | Orchestrates injected ports | Implements platform integrations | Supplies artifact and access policy |
| Storage | Storage port only | Local export implementation | Private durable object storage for server artifacts |
| Verification QR | Draws supplied payload | Requests/validates through app | Issues verification reference and validates it |

---

## 6. Core Document Model

### 6.1 Design principles

- Immutable value objects.
- Strongly typed fields and enums.
- Explicit schema versions.
- No dependency on NetSales entities or API response classes.
- No unrestricted dynamic map as the primary public document contract.
- Clear distinction between content, presentation configuration, template metadata, and the final artifact.
- Unknown optional fields may be ignored only where forward-compatibility rules explicitly allow it; required unknown values must fail visibly.

### 6.2 Main contract catalogue

| Contract | Responsibility |
|---|---|
| DocumentDefinition | Application-owned type identity and content requirements |
| DocumentMetadata | Title, subtitle, identifiers, locale, time zone, generation context |
| DocumentSnapshot | Immutable supplied data used for a specific rendering |
| DocumentSection | Ordered semantic group of content |
| DocumentNode | Typed content tree node |
| DocumentParagraph | Localized text and direction hints |
| DocumentMetric | Supplied KPI label, value, comparison label, and semantic meaning |
| DocumentTable | Columns, row cells, widths, alignment, and split policy |
| DocumentChart | Chart kind, series, labels, units, and visual configuration |
| DocumentImage | Image bytes/reference resolved by the host or approved asset provider |
| DocumentQrCode | Opaque verification payload and presentation settings |
| DocumentSignatureBlock | Display-only signature area or verified signature metadata |
| DocumentWatermark | Text/image watermark configuration |
| DocumentPageProfile | Paper size, orientation, margins, printable area |
| DocumentBranding | Logo, brand colors, typography profile, organization identity |
| DocumentLocaleProfile | Language, direction, digit policy, date/number display policy |
| DocumentTemplateReference | Template identifier, immutable version, and compatibility metadata |
| DocumentRenderOptions | Output format, page profile, locale, theme, and supported feature flags |
| DocumentArtifact | Immutable generated bytes plus identity, digest, and metadata |
| DocumentArtifactReference | Secure remote artifact reference; not a public permanent URL |
| DocumentGenerationResult | Success or typed failure without leaking private details |

### 6.3 Typed content tree

Document content is represented as an ordered tree of typed nodes, not arbitrary HTML and not a giant collection of nullable fields.

Initial node families:

- Text: paragraph, heading, caption, label, rich-text run.
- Metrics: KPI card and financial highlight using supplied values.
- Tables: table, header, row, cell, subtotal/total rows whose values are already supplied.
- Charts: bar, line, pie, donut, comparison, trend, distribution, and explicitly registered future types.
- Media: logo, illustration, QR code, signature image, stamp image.
- Layout: columns, rows, spacer, divider, keep-together group, explicit page break, section break.
- Metadata: footnote, source note, confidentiality label, document reference.

A node must declare whether it is splittable across pages and whether it may be kept with adjacent content.

### 6.4 Data value safety

Use a small typed value algebra for supplied content: text, integer, decimal-as-display-text or exact decimal representation, boolean, date/time, localized label, and structured references. Do not require the engine to parse currency strings to recompute values.

Formatting financial values is presentation only. The authoritative server supplies the amount, scale, currency code, display precision, and any approved formatted representation. The engine may position and style the value but must not derive totals, discounts, tax, balances, percentages, or allocations.

### 6.5 Artifact identity

Each generated artifact records:

- Artifact ID and artifact kind.
- Document type and source reference when supplied.
- Template ID and immutable version.
- Document schema version.
- Renderer identity and version.
- Font asset fingerprints used in the rendering.
- Locale and page profile.
- Generation timestamp and time-zone context.
- Byte length, page count where known, and SHA-256 digest.
- Official/non-official classification.
- Source snapshot revision/reference where supplied.

SHA-256 detects byte changes; it is not a digital signature, proof of issuer identity, or legal non-repudiation mechanism.

---

## 7. Templates and Versioning

### 7.1 Four separate concepts

1. **Engine templates:** reusable generic page layouts and sections supplied by the package.
2. **Application templates:** templates registered by the consuming app for its document types.
3. **Template configuration:** options that a particular template explicitly supports.
4. **Saved report presets:** saved user choices for a report schema; not templates and not authorization grants.

Official issued-document snapshots and versions are a fifth, separate concept owned by the backend.

### 7.2 Template descriptor

A template descriptor should include:

- Stable template ID.
- Immutable semantic version.
- Document type compatibility.
- Supported locale/direction combinations.
- Supported page sizes/orientations.
- Supported sections and optional capabilities.
- Configurable properties with declared types, constraints, defaults, and visibility rules.
- Minimum renderer version.
- Whether it is eligible for non-official client rendering.
- Whether it is eligible for server official rendering.
- Preview example metadata, not privileged business data.

### 7.3 Capability-driven configuration

Every template advertises capabilities. The UI must never display an option that the selected template does not support.

Examples:

- Cover page supported or not.
- First-page-specific header.
- Repeating headers and footers.
- Page numbering.
- Charts and metric cards.
- Signature area.
- Watermark.
- QR verification mark.
- Landscape layout.
- Multi-language content.
- Long-table repeating headers.
- Compact/thermal page profile.

The app schema and template capabilities are intersected before configuration options are presented.

### 7.4 Versioning rules

- Template IDs are stable; versions are immutable.
- Changing the meaning or structure of a template creates a new version.
- A saved preset includes its report schema version and template reference.
- Preset migration is explicit and versioned. Do not silently reinterpret an old preset.
- Official document snapshots include the exact template version, renderer version, font fingerprints, and final PDF artifact.
- Changing current branding or a template never alters an already issued artifact.
- Reissuing/correcting an official document creates a new official revision with a traceable relationship to the prior revision. Never overwrite the issued file.

### 7.5 Visual template designer

A WYSIWYG designer is excluded from the initial release. Templates are registered programmatically with typed configuration. A visual designer may later edit a constrained template AST; it must not become an arbitrary code/HTML execution surface.

---

## 8. Reporting Model and Configuration Studio

### 8.1 Separate report definition from document presentation

- **ReportCriteria** determines which records the backend may return.
- **ReportDefinition** declares the permitted filters, fields, statuses, and grouping/sorting options supported by the application/API.
- **ReportPresentationOptions** determines which supplied values and sections are rendered and how they look.
- **DocumentRenderOptions** chooses page and renderer settings.
- **SavedReportPreset** stores configuration only.

Never send page styling or a preset to Laravel as evidence of permission. Never let a preset contain confidential records or reusable authorization.

### 8.2 Report definition supplied by the app

A report definition declares:

- Stable report ID and schema version.
- Localized title, subtitle, and description.
- Supported date range/filter controls.
- Supported server-side search/filter fields.
- Supported output columns with types and labels.
- Allowed sort choices and grouping choices.
- Backend-provided summary metric slots.
- Whether charts and metrics are available.
- Available template IDs.
- Permitted document languages and page profiles.
- Data volume classification or backend export policy.
- Whether the report can be client-rendered, must be server-rendered, or can use either path under declared limits.

The engine renders declared controls. It does not invent endpoint parameters or query capabilities.

### 8.3 Configuration Studio UX

One reusable configuration experience should adapt its presentation to available space.

- Narrow viewport: staged modal sheet or focused full-screen flow.
- Tablet/medium viewport: responsive sheet with progressive sections.
- Desktop: report workspace with configuration navigation, central preview/sample area, and a compact summary panel where useful.

The layout must be driven by actual constraints, not by assumptions about the device or full monitor size.

Suggested stages:

1. Report identity: title, subtitle, language, period, recipient if applicable.
2. Data criteria: only filters declared by the report definition.
3. Fields and ordering: only fields the server/API supports.
4. Presentation: detail/summary mode only if the backend supplies both; supported grouping and sort only if part of the server contract.
5. Document design: registered template, cover, headers/footers, logo visibility, watermark, signatures, page numbering.
6. Page/output: page profile, orientation, margins and PDF output options supported by the template.
7. Review: summary of criteria and a safe preview/sample if available.

No arbitrary grouping or local totals are introduced in Flutter. If the backend does not support an aggregation, the corresponding configuration control is absent.

### 8.4 Preset lifecycle

- Presets are scoped by the consuming app's authenticated user and organization/tenant model.
- Presets store criteria and presentation choices, not data rows, tokens, signed URLs, or permission grants.
- The backend must authorize every query again when a preset is reused.
- Presets have schema versions, names, ownership, timestamps, and optional sharing policy.
- Shared presets require explicit owner/admin and server-side access policy.
- If a preset references removed fields or unsupported options, show a migration/review step rather than silently dropping criteria.

The engine exposes a preset serialization contract. It does not persist presets by itself.

---

## 9. Rendering Architecture

### 9.1 Renderer interface

The engine defines a renderer port that accepts a validated DocumentSnapshot, a registered TemplateDescriptor/renderer, and DocumentRenderOptions, and returns a DocumentArtifact or a typed rendering failure.

The public contract must not expose PDF package widgets or mutable internal layout objects.

### 9.2 PDF renderer

The initial concrete renderer uses the existing Dart PDF dependency as the first candidate. It must support:

- Page composition and margins.
- Portrait and landscape page profiles.
- Optional cover page.
- First-page and subsequent-page headers.
- Repeating footers and page numbers.
- Repeating table headers.
- Row wrapping and table continuation.
- Keep-together groups and controlled page breaks.
- Images, QR marks, signatures, and watermarks.
- Vector charts and metric/table components.
- Embedded fonts and locale-specific text shaping strategy.

Do not let a Flutter UI Widget tree be the source of truth for printable layout. The PDF composition model is its own renderer-neutral document tree.

### 9.3 Layout and pagination responsibilities

The layout system must explicitly account for:

- Available page height after margins, header, and footer.
- First-page versus subsequent-page geometry.
- Repeated table headings.
- Long cells and wrapped content.
- Keep-together constraints for headings and small groups.
- Orphan headings and stranded totals.
- Row split policy (allow, avoid, or keep-together where feasible).
- Section breaks and explicit page breaks.
- Page count and page numbering.
- Variable paper profiles.

If a content group cannot fit on any supported page, return a typed layout error or apply an explicitly declared fallback; do not silently clip or overlap content.

### 9.4 Tables

The table model needs:

- Dynamic columns and stable column IDs.
- Explicit/relative column widths and minimum widths.
- Header labels and alignment.
- Text direction per cell/run where necessary.
- Numeric alignment and decimal alignment where feasible.
- Row wrapping and row split policy.
- Repeating column headers.
- Alternating row presentation as an optional style, not a universal default.
- Explicit supplied subtotals/totals.
- Long-text handling and overflow policy.
- Landscape alternatives for wide reports.
- Column visibility/order controlled by the report definition and user permission policy.

Hundreds or thousands of rows are not a reason to send unbounded records to Flutter. Very large tables should use backend generation.

### 9.5 Charts and metric cards

Charts are rendered from supplied series, labels, and units. They are not computed by the PDF layer.

Prefer PDF vector drawing for charts. Raster output may be used only for explicitly unsupported chart types or supplied images and must have a documented resolution policy.

Candidate chart types include bar, line, pie, donut, area/trend, comparison, and distribution. The first release should prioritize the types actually registered by consuming applications and add the rest through renderer capabilities.

Do not depend on the application’s Syncfusion UI chart widgets for PDF export. The document chart contract must be generic and the PDF chart renderer independent of the app UI charting library.

### 9.6 Performance and resource safety

The renderer must expose measurable limits rather than promising unlimited data support:

- Maximum client-render rows by policy.
- Maximum estimated snapshot size.
- Maximum image byte budget and decoded dimensions.
- Maximum page count for client rendering.
- Maximum generated PDF size.
- Render duration telemetry and cancellation boundaries.
- Memory budget per supported platform.
- Concurrency limits for simultaneous generations.

Initial thresholds are **NEEDS BENCHMARK**. Calibrate them through representative Windows, Web, and supported mobile/tablet scenarios. Do not choose arbitrary row-count thresholds without measuring the actual templates and data.

The renderer must release temporary images, fonts, buffers, and document objects after generation.

---

## 10. Arabic, RTL, Fonts, and Mixed Content

Arabic is a release-critical rendering capability, not a cosmetic toggle.

### 10.1 Requirements

- Correct Arabic glyph shaping and joining.
- Correct bidi ordering for Arabic/English mixed paragraphs.
- Stable rendering of phone numbers, invoice references, UUIDs, dates, and currency codes inside RTL paragraphs.
- Explicit direction for paragraphs, table cells, and rich-text runs.
- Locale-aware digit display policy supplied by the host/document.
- Embedded font subsets or approved embedded fonts so the artifact does not depend on the recipient's installed fonts.
- Correct fallback for Arabic, Latin, punctuation, and symbols.
- No artificial letter spacing that breaks Arabic joining.
- Consistent table wrapping and page breaks with long Arabic strings.
- Search/copy/select text behavior evaluated; visual correctness alone is not enough.
- No silent fallback to a font that lacks Arabic glyphs.

### 10.2 Typography service boundary

Define a TextShaper/TypographyProvider contract behind the renderer. It receives logical text runs, direction, and font-role references and produces a shaped representation suitable for the selected PDF renderer.

This abstraction allows alternative implementations to be evaluated without changing document contracts.

### 10.3 Required proof of concept

Before fixing the implementation dependency, compare:

1. Existing Dart PDF rendering with IBM Plex Sans Arabic fonts.
2. A shaping-enabled approach such as a HarfBuzz-backed implementation, subject to platform compatibility and license review. The pdf_text_shaper package is a research candidate only; platform support, Web limitations, mixed-script behavior, text extraction/copy behavior, maintenance, and licensing must be demonstrated before selection. It is not an approved dependency.
3. Server-generated official artifacts where the backend uses a different rendering stack.

The proof of concept must include Arabic-only, English-only, mixed-script, Arabic digits and Western digits, punctuation, parentheses, currency codes, long cells, multi-page tables, and copy/search behavior.

Native Flutter/desktop and Web support must be assessed independently. If a selected shaper is unavailable on Web, define an explicit Web strategy rather than relying on a broken conditional import fallback.

### 10.4 NetSales integration

NetSales may inject its existing IBM Plex Sans Arabic font assets and brand configuration. The package must not hardcode IBM family names or NetSales assets as defaults. Other projects must be able to inject their own font roles and logo resources.

---

## 11. Document Preview Experience

### 11.1 Custom preview is mandatory

The package provides a dedicated preview shell built around PDF page rendering. It must not expose the printing package's default toolbar as a second action bar.

The preview UI includes:

- Document title and identity.
- Page count.
- Smooth page navigation and scaling.
- Page boundaries and restrained shadows/background.
- Loading and generation states.
- Error and retry states.
- Optional metadata/info panel.
- Zoom controls or native pinch/scroll behavior where supported.
- Responsive layout for compact, medium, and wide screens.
- Keyboard and pointer affordances on desktop.
- Correct RTL/LTR toolbar order and directional icons.

### 11.2 Toolbar

The primary actions are:

- **Share:** native platform sharing of the current artifact.
- **Save:** export the current bytes to the host-selected destination.
- **Print:** print the current artifact bytes.
- **More/Info:** optional metadata and artifact information.

Optional actions such as regenerate or return-to-settings must be host-provided callbacks. They must not cause hidden data reloads or silently mutate the artifact.

### 11.3 printing package integration

The current dashboard resolves printing 5.15.1 and pdf 3.13.1 in pubspec.lock. The main NetSales app resolves printing 5.15.1 and pdf 3.13.1 as well. Declared pubspec constraints are minimum compatible ranges and must not be mistaken for the exact lockfile version.

The preview adapter should use the installed PdfPreview API with built-in actions disabled. For the currently resolved printing 5.15.1 API, evaluate and explicitly configure useActions: false, allowPrinting: false, and allowSharing: false, plus canChangePageFormat: false and canChangeOrientation: false for a prebuilt artifact. Verify the exact availability and semantics of each property against the lockfile version before implementation; do not copy signatures from a different package version. The host toolbar performs the actions independently.

The design must verify the exact API of the lockfile version at implementation time; do not copy APIs from latest documentation if they differ from the pinned version.

### 11.4 One artifact, all actions

The same immutable PDF bytes must back:

- Preview.
- Save.
- Share.
- Print.

Do not call the renderer again separately for each action. Regeneration creates a new DocumentArtifact with a new artifact identity/digest, after explicit changes to configuration or source data.

Printing a fixed artifact must not silently regenerate it in a different paper format. If the user chooses another page profile, return to the configuration workflow and create a new artifact intentionally.

---

## 12. Output and Storage Adapters

### 12.1 Output ports

Define independent contracts for:

- DocumentSavePort.
- DocumentSharePort.
- DocumentPrintPort.
- TemporaryFilePort if needed for platforms that cannot share bytes directly.
- DocumentStoragePort for durable/local/remote retrieval, where that capability belongs to the host.

The engine coordinates these operations but does not implement app-specific filesystem policy.

### 12.2 Save semantics

Different destinations are not equivalent. The host must choose and label the action clearly:

- App export directory.
- User-selected Save As destination.
- Browser download.
- Mobile share/export destination.

Do not label app-directory save as "Choose where to save". Cancellation is a distinct non-error outcome. A failed save must not be reported as success.

### 12.3 Existing NetSales adapters

Current reusable host services include:

- FileExportService / IFileExportService for app-managed file export.
- ShareService for text, links, files, and bytes.
- Printing integration for print/share APIs.
- FilePickerService and file_picker dependency for user file selection where supported.
- Existing path/provider and file-opening dependencies.

The document engine must depend on interfaces only. A NetSales adapter can delegate to the existing services. Avoid another save/share dependency unless a tested platform gap proves it necessary.

The current FileExportService writes to the app's managed export directory; this does not automatically satisfy a user-selected Save As requirement. Its implementation and platform behavior must be considered when mapping the host port.

### 12.4 Local versus external storage

The package may define storage contracts, but it must not assume that its local filesystem is durable, private, shared across devices, or appropriate for official records.

For official and large server artifacts, Laravel owns durable storage. NetSales cloud guidance identifies private object storage and temporary authorized access as the server-side pattern; generated private artifacts must never be made public simply for preview convenience.

---

## 13. Backend Integration and Large Reports

### 13.1 Backend responsibilities

Laravel remains authoritative for:

- Authentication and authorization.
- Tenant/network/POS scope validation.
- Filter validation.
- Report query planning and stable ordering.
- Aggregations and business metrics.
- Financial calculations.
- Invoice, receipt, and voucher snapshots.
- Official document identifiers and revisions.
- Generation jobs, retries, state, and cancellation policy.
- Durable private artifact storage.
- Artifact access authorization and retention policy.
- Verification-token issuance and verification endpoints.

### 13.2 Client-generated bounded report flow

1. User selects an application-registered ReportDefinition.
2. The host gathers criteria and presentation options.
3. Laravel validates user, scope, permissions, and supported criteria.
4. Laravel returns a bounded, consistent snapshot with a report snapshot ID/version and any authoritative summaries.
5. Host maps that response into the generic DocumentSnapshot.
6. Engine renders a non-official PDF.
7. Preview, save, share, and print use the same artifact bytes.

The data snapshot must be bounded, explicit, and tied to the query execution. The package must not issue its own network requests.

### 13.3 Large report asynchronous flow

1. Host submits report criteria and idempotency/correlation reference to Laravel.
2. Laravel validates authorization and scope before dispatching work.
3. Laravel creates a durable job record and queues report processing.
4. Flutter observes status through the approved API contract or polling adapter.
5. Backend processes bounded chunks/streams and writes a private artifact to durable storage.
6. Backend records page count, size, digest, renderer identity/version, and snapshot reference where available.
7. Flutter retrieves an authorized artifact reference.
8. Every retrieval is re-authorized; access URLs/tokens are short-lived and are not stored in presets or logs.

Job states should include queued, running, succeeded, failed, expired, and cancelled where cancellation is supported. Retries, duplicate submission, timeout, retention, and partial output cleanup must be explicitly specified by the API contract.

### 13.4 API contract design

Potential backend API capabilities to design and approve separately:

- Create report job.
- Get report job status.
- Cancel report job where safe.
- Retrieve artifact metadata.
- Retrieve artifact bytes through protected access.
- Retrieve official document snapshot/artifact by official identifier.
- Verify a document reference/QR.

These are **design candidates only**. No route, migration, table, permission, job, or endpoint is approved or created by this blueprint.

### 13.5 Tenant and sensitive-data isolation

- Do not put tenant identifiers into generic presets unless a host contract explicitly requires and validates them.
- Presets never grant access.
- No permanent public artifact URLs.
- Avoid logging signed URLs, verification secrets, sensitive document payloads, or raw PDF bytes.
- Access must be revalidated on every request/download.
- Server artifacts must use private storage and controlled expiry/retention.
- Client-side route and permission checks are UX only.

---

## 14. Official Document Integrity

### 14.1 Immutable issuance record

For an official invoice, receipt, collection/payment voucher, or financial statement, the backend should preserve:

- Official document ID and type.
- Source transaction ID.
- Immutable data snapshot/revision.
- Template ID/version.
- Renderer identity/version.
- Font asset fingerprint/version where relevant.
- Branding snapshot where legally/operationally relevant.
- Issue timestamp and timezone.
- Final PDF bytes in durable private storage.
- SHA-256 digest of the stored bytes.
- Related correction/reissue reference if a new revision is issued.

### 14.2 Prohibitions

The Flutter engine must never:

- Recalculate invoice line amounts, totals, discounts, fees, taxes, paid or remaining amounts.
- Change the transaction reference, official status, payment allocation, or issued timestamp.
- Regenerate a historic official document with the current template and treat it as the original.
- Replace an official stored artifact with a newly generated PDF.
- Treat a client-generated PDF as official merely because its input came from an API.
- claim SHA-256 is a digital signature.

### 14.3 Reproducibility versus canonical artifact

The canonical official artifact is the stored issued PDF. Snapshot and renderer metadata support audit and possible forensic reproduction, but visual reproduction is not a substitute for the stored bytes.

A legal digital signature, trusted timestamp, or regulatory seal requires a separate backend capability and jurisdiction-specific review. A drawn signature image is not a cryptographic signature.

---

## 15. QR, Verification, Signatures, and Watermarks

### 15.1 QR

The engine renders a supplied QR payload. It does not encrypt, sign, or validate it.

- Laravel issues a verification reference/token.
- The consuming app requests it through an authorized contract.
- The engine draws the QR and human-readable reference supplied by the host.
- The existing NetSales QR cryptography and scanner remain app-level integration details.
- Other projects may use another verification scheme.

### 15.2 Verification scan

The QR resolves to a server-owned verification flow, not to a trust decision made by the PDF engine. The verifier endpoint returns validity, document identity, revision, and permitted public verification fields only.

### 15.3 Signature and stamp areas

Distinguish:
- Visual signature image.
- Typed/printed signer identity and role.
- Server-verified approval metadata.
- Cryptographic signature.

Do not label a visual signature/stamp as a digital signature.

### 15.4 Watermarks

Watermarks are presentation controls for draft, copy, confidential, or cancelled views. They must not alter authoritative document status or suggest legal validity that the backend has not declared.

---

## 16. Localization and Visual Design System

The engine provides generic document design tokens and accepts app branding:

- Brand palette and semantic color roles.
- Font roles and font assets.
- Logo/brand mark.
- Spacing, borders, radii, and section hierarchy.
- Header/footer and cover composition.
- Table density and chart palette.
- Locale and writing direction.

Do not import NetSales AppColors, AppTypography, AppSpacing, AppRadius, or GetX into the package. A NetSales adapter maps those tokens into a DocumentBranding/DocumentTheme profile.

Templates should offer polished corporate compositions rather than generic stacks of boxed widgets. Visual hierarchy, whitespace, readable dense tables, subtle separators, and print contrast are first-class requirements.

---

## 17. Compatibility and Dependency Strategy

### 17.1 Current repository facts

The inspected NetSales Dashboard main branch declares:

- Flutter SDK minimum 3.47.9 and Dart SDK range 3.13.7.
- printing constraint ^5.15.1; lock resolves 5.15.1.
- pdf constraint ^3.12.0; lock resolves 3.13.1.
- share_plus constraint ^12.0.2; lock resolves 12.0.2.
- path_provider constraint ^2.1.6; lock resolves 2.1.6.
- file_picker constraint ^11.0.2; lock resolves 11.0.3.
- open_filex constraint ^4.7.0; lock resolves 4.7.0.
- path constraint ^1.9.0; lock resolves 1.9.1.

The dashboard already has file-export and share services. It does not currently have a generic document-generation package.

### 17.2 Dependency policy

- Reuse the currently resolved PDF and printing stack as the initial candidate.
- Do not add a charting dependency to the engine merely to match application dashboard charts.
- Do not add another save/share dependency before mapping existing FileExportService, ShareService, file_picker, and Printing capabilities.
- Do not assume the same library works on all targets. Check Windows, Web, macOS, Linux, Android, and iOS separately where in scope.
- Avoid importing native-only APIs into public contracts.
- Keep optional platform behavior behind conditional implementations or host-supplied ports with explicit unsupported results.
- Review license, transitive dependencies, bundle size, maintenance state, platform coverage, and security before accepting any new package.

### 17.3 Publishing strategy

Initial use is a local path dependency. Package semantic versioning and public API stability must be established before extraction/publication. A later public release requires independent README, examples, CI, changelog, supported-platform matrix, API compatibility policy, and license review.

---

## 18. Failure Model and Operational Guarantees

Typed failures should distinguish at least:

- Invalid document snapshot.
- Unknown document type.
- Unknown or incompatible template version.
- Unsupported template capability.
- Invalid render option.
- Missing font or unsupported glyph coverage.
- Text shaping failure.
- Pagination/layout overflow.
- Image/asset resolution failure.
- Rendering resource limit exceeded.
- Cancelled generation.
- Empty artifact.
- Save destination cancelled.
- Save/share/print unsupported on this platform.
- Output operation failed.
- Remote artifact expired or inaccessible.
- Authorization failure returned by host adapter.

Errors exposed to end users must be localized by the host. Diagnostic details must not leak secrets, raw financial payloads, or signed URLs.

A partial PDF must never be returned as a successful artifact. Cleanup of temporary files and renderer resources must occur on every failure/cancellation path.

---

## 19. Security, Privacy, and Threat Boundaries

Threats to address explicitly:

- Unauthorized report filters or object IDs.
- Cross-tenant artifact retrieval.
- Preset reuse after permission revocation.
- Public or long-lived document URLs.
- QR payload tampering or fake verification domains.
- PDF metadata leaking private data.
- Untrusted image/font URLs or arbitrary remote asset fetches.
- Oversized images, huge tables, excessive pages, decompression/resource exhaustion.
- Stale cached artifacts after access revocation.
- Sensitive content in crash reports, logs, telemetry, and temporary directories.
- File-name path traversal and unsafe export paths.
- Open redirects or external links embedded in PDF content.

The engine must not fetch arbitrary remote resources from a template. Asset bytes must be passed by the host or resolved through a host-controlled allowlisted asset provider.

The engine must validate output file names and avoid writing to a path supplied directly by untrusted document data.

The backend remains responsible for authorization and private storage. The client package is not a security boundary.

---

## 20. Quality Strategy and Acceptance Gates

Tests are required before production adoption, but implementation and tests are deferred until this architecture is approved.

### 20.1 Contract and unit coverage

- Immutable contract behavior and serialization.
- Template registry uniqueness and version compatibility.
- Capability intersection and invalid option rejection.
- Layout measurements and page profile calculations.
- Stable artifact identity and digest metadata.
- Preset schema versioning and migration failures.
- Typed renderer and output failures.
- Defensive handling of empty or malformed content.

### 20.2 PDF rendering coverage

- Single-page and multi-page documents.
- First-page and subsequent-page headers.
- Repeating footer and page numbering.
- Cover and no-cover templates.
- Portrait and landscape.
- Narrow/thermal PDF page profiles where declared.
- Long/wide tables and repeated headers.
- Long Arabic/English cells, keep-together groups, explicit page breaks.
- Charts, metrics, signatures, QR marks, stamps, and watermarks.
- Empty report and very long report boundary behavior.
- Embedded-font verification and missing-glyph failure behavior.

### 20.3 Arabic and visual acceptance

Create a fixed multilingual fixture corpus including:

- Arabic paragraphs and names.
- English paragraphs.
- Mixed Arabic-English sentences.
- Phone numbers, UUIDs, invoice identifiers, punctuation, brackets, and symbols.
- Western and locale-specific digits.
- Currency code placement.
- Very long Arabic words and table cells.
- Multiple pages with repeated table headers.

Inspect actual PDF pages at print resolution and common screen zoom levels. Automated text extraction does not prove visual shaping correctness. Visual regression comparisons must tolerate only documented rendering differences.

### 20.4 Output and preview coverage

- Preview uses the exact bytes captured in DocumentArtifact.
- Save bytes match the artifact digest.
- Share bytes match the artifact digest.
- Print callback receives the same byte sequence.
- Built-in PdfPreview action bar is absent.
- Page format/orientation cannot mutate an already-built artifact.
- Save cancellation is not a failure.
- Unsupported platform operations are explicit.
- Repeated taps do not trigger duplicate export/print/share operations.

### 20.5 Integration and visual QA

- NetSales host adapter integration.
- A second sample host app with a different branding profile and no GetX dependency.
- Windows compact/standard/wide window layouts.
- Responsive Web viewports.
- Light/Dark preview shell.
- Arabic RTL and English LTR.
- Keyboard, pointer, focus, and accessibility behavior.
- Native print workflow and output file validation.
- Large-report async lifecycle and secure download.
- Official artifact immutability and authorization integration.

### 20.6 Performance acceptance

Do not define final thresholds until baseline measurement is complete. Establish p95 generation latency, peak memory, output size, page throughput, and startup cost for representative templates on each supported platform. The measured threshold becomes a renderer policy with tests and a documented fallback to server generation.

---

## 21. Incremental Delivery Roadmap

The proposed sequence minimizes rework and makes each milestone independently reviewable.

| Milestone | Scope | Exit deliverable |
|---|---|---|
| M0 | Architecture/spec approval and Arabic/PDF proof-of-concept plan | Approved contracts, risk register, dependency decision |
| M1 | Core document contracts, immutable model, template registry, capabilities | Stable generic public API |
| M2 | Renderer port, PDF renderer, page profiles, pagination primitives | Multi-page non-official PDF baseline |
| M3 | Tables, metrics, vector charts, headers/footers/covers | Reusable visual components and template showcase |
| M4 | Locale/font/shaping adapters and Arabic proof-of-concept decision | Accepted Arabic/RTL rendering strategy |
| M5 | Report definitions, configuration Studio, preset contract | Schema-driven configuration workflow |
| M6 | Custom preview, artifact lifecycle, save/share/print ports | Single-artifact output workflow |
| M7 | Laravel async job and official artifact integration contracts | Secure remote artifact lifecycle design and integration |
| M8 | QR verification rendering, watermarks, signature metadata, optional thermal profiles | Document integrity and finishing capabilities |
| M9 | App integration, migration of selected existing documents, second-host reuse | Proven reuse and migration evidence |
| M10 | Full quality, performance, security, and visual review | Release candidate and package compatibility matrix |

No milestone begins implicitly because a previous milestone has been documented. Each requires explicit approval at the project's established gates.

---

## 22. NetSales Adoption Plan

### 22.1 First integration candidates

1. A non-official operational report with a bounded server-supplied snapshot.
2. A dashboard/analytics report whose chart data and metric values are already aggregated by Laravel.
3. An official invoice preview path that retrieves the finalized backend PDF rather than regenerating it.

### 22.2 Existing implementation inventory

The Dashboard currently has:

- FileExportService and IFileExportService.
- ShareService.
- MediaPdfViewerCard with PdfPreview and external file opening.
- NetSalesChartsExportAdapter that can capture a Flutter chart widget as PNG and place it in PDF.
- AppDataGridExportController that exports the rows currently loaded in the grid to Excel/PDF.
- Resolved pdf and printing packages in the lockfile.

The original NetSales app contains an InvoiceDocumentService that currently composes invoice PDF from the application invoice entity. That implementation is a source reference only and is not the Dashboard's application feature. Its existence demonstrates why a future generic package must accept app-provided document snapshots rather than importing the InvoiceEntity.

### 22.3 Migration rules

- Do not delete existing export functionality while the new engine is only proposed or partially delivered.
- Do not move authoritative financial logic into the package during migration.
- Select one report/document at a time.
- Preserve existing API values and official server artifacts.
- Retain a fallback route until parity and acceptance evidence is recorded.
- Remove duplicated implementation only after the replacement is verified and approved.

---

## 23. Risks and Open Research Items

| Risk / question | Why it matters | Required resolution |
|---|---|---|
| Arabic text shaping across native and Web targets | Incorrect glyph order/joining invalidates business documents | POC comparing current PDF text engine, shaping libraries, and server output |
| Searchable/copyable Arabic PDF text | Vector glyph paths may look correct but reduce text accessibility | Include text extraction, selection, and accessibility in POC |
| Client memory for large PDFs | Desktop/Web/mobile budgets differ | Benchmark representative templates and set policy thresholds |
| Printing on Windows and browser print | Native print behavior differs by platform | Verify pinned printing API and native workflows per target |
| Save As behavior | App export directory is not a user-selected destination | Choose host-specific adapter behavior explicitly |
| Server/client visual parity | Laravel may use a different renderer than Flutter | Define semantic parity and canonical artifact rules; do not assume pixel identity |
| Font licensing and file size | Font embedding affects distribution and compliance | Review font licenses, subset embedding, and size |
| PDF signatures and legal validity | Visual stamp is not a digital signature | Backend/legal capability and jurisdiction review |
| Thermal printer support | PDF thermal page size differs from ESC/POS raw printing | Decide later whether an independent printer adapter is needed |
| Preset schema evolution | Old saved configurations may reference removed fields | Version and migration policy before storing presets |

### 23.1 Decisions that remain proposed

- Final public API naming and constructor design.
- Exact package dependency graph and permitted transitive dependencies.
- Final Arabic shaping package/implementation.
- Client rendering size/page/time thresholds.
- Precise async report API routes and job persistence schema.
- Preset storage ownership and sharing rules.
- Whether Save As must be offered in first release on every platform.
- Official document signature/retention requirements.
- Whether thermal PDF profiles are included in initial release or a follow-up.

These are not silently decided by this document.

---

## 24. Approval Checklist

The architecture is ready to be approved only after the project owner reviews the following:

- [ ] One internal reusable package named document_engine is the selected starting point.
- [ ] The package/API/business boundary and dependency direction are accepted.
- [ ] The three rendering paths are accepted.
- [ ] Official-document immutability and backend artifact ownership are accepted.
- [ ] The generic document and report contract catalogue is accepted.
- [ ] Template identity, capabilities, and versioning strategy are accepted.
- [ ] Report configuration and preset authorization semantics are accepted.
- [ ] Pagination/table/chart architecture is accepted.
- [ ] Arabic text shaping proof-of-concept scope and acceptance criteria are accepted.
- [ ] Custom preview and same-artifact output requirements are accepted.
- [ ] Host adapter responsibilities for save/share/print/storage are accepted.
- [ ] Async job and protected artifact lifecycle principles are accepted.
- [ ] Security/privacy and performance gates are accepted.
- [ ] Incremental roadmap and milestone approval gates are accepted.
- [ ] Open research items are either resolved or explicitly accepted as deferred.

Approval of this blueprint authorizes the next **design/technical-proof phase only if explicitly stated**. It does not automatically authorize production package implementation.

---

## 25. References Inspected

### NetSales Dashboard repository

- AGENTS.md and local Flutter architecture, financial, security, UI/UX, and milestone rules.
- docs/project/PROJECT_OVERVIEW.md, PROJECT_STATE.md, DECISION_LOG.md, WORK_LOG.md, and shared-contract-reference.md.
- packages/desktop_windowing/README.md, public barrel, configuration, platform stub, and geometry tests.
- pubspec.yaml and pubspec.lock.
- FileExportService, ShareService, MediaPdfViewerCard, NetSalesChartsExportAdapter, and AppDataGridExportController.

### Shared Laravel API repository

- AGENTS.md and canonical project documentation for product scope, architecture, API contracts, RBAC/tenant context, financial invariants, project state, decisions, and work history.
- Laravel API engineering, security, queue, storage, and best-practice references relevant to future report jobs and private artifacts.

### Package/documentation references

- printing package: https://pub.dev/packages/printing
- printing PdfPreview API: https://pub.dev/documentation/printing/latest/printing/PdfPreview-class.html
- pdf package: https://pub.dev/packages/pdf
- pdf package API: https://pub.dev/documentation/pdf/latest/
- file_picker package: https://pub.dev/packages/file_picker

Package versions written above are repository observations, not a promise that they remain current indefinitely. Re-check the lockfile and exact versioned API during implementation planning.
