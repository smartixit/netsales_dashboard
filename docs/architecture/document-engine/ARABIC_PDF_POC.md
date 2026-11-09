# Arabic PDF Rendering — M4 POC Outcome

**Status:** COMPLETE — constrained research outcome recorded; no production provider approved
**Package:** `packages/document_engine_poc`
**Pull request:** #36
**Decision:** vowel diacritics are outside acceptance scope

## Scope retained

The POC verifies readable Arabic letter joining, RTL paragraph direction,
Arabic/Latin mixed runs, western and Arabic-Indic digits, identifiers,
punctuation, font embedding, long text wrapping, table continuation, and
repeatable native output.

Vowel marks/diacritics are not a product requirement and are not an acceptance
gate. The corpus uses undiacritized Arabic text for the required cases.

## Candidate findings

| Candidate | Native generation | Observed result | Outcome |
|---|---|---|---|
| A — `pdf` baseline | Windows and Ubuntu | Arabic is readable, but unisolated mixed LTR values can reverse | Retain as baseline only |
| B — `pdf_text_shaper` / HarfBuzz | Windows and Ubuntu | Large output (~3 MB) and mixed-bidi/text extraction defects in the fixture | Reject for this iteration |
| D — `payv` | Windows and Ubuntu | Arabic joining is readable; isolated LTR runs preserve phone/identifier order; ~30 KB sample | Leading research candidate |

For Payv, values such as phone numbers, UUIDs, invoice references, and Latin
codes embedded in Arabic paragraphs must be enclosed in Unicode LTR isolates
(U+2066/U+2069). The unisolated phone fixture demonstrated reversed visual
ordering. This is a caller-input convention to carry into later report
rendering, not a financial transformation.

## Target coverage

- Windows and Ubuntu: native PDF files were generated successfully.
- Web: the Payv dependency graph is compile-checked to JavaScript. Browser runtime
  PDF generation, browser viewer behavior, download/print behavior, and visual
  parity are not claimed by M4.
- Text extraction is diagnostic. Copy/search and viewer accessibility still
  require end-to-end testing in the preview/output milestone.

## Exit decision

M4's bounded POC comparison is closed. Payv is the preferred candidate for a
future isolated non-official rendering integration experiment because it is
pure Dart and compiled to JavaScript, but **it is not selected or approved for
production**. The production renderer, dependencies, and complex-RTL rejection
guard remain unchanged.

A future production decision must separately approve the provider, viewer
accessibility behavior, supported target matrix, maintenance/version policy,
font licensing, and measured performance budgets.

## Next milestone

M5 proceeds with generic ReportDefinition, schema-driven configuration
contracts/Studio, and SavedReportPreset serialization. M5 remains independent
of a production Arabic renderer choice and must not allow presets to carry
records, tenant authorization, bearer tokens, or signed URLs.
