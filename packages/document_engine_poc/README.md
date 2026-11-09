# Arabic PDF typography POC

This is an isolated M4 research harness. It is not imported by the Dashboard
application and is not a dependency of the production `document_engine`
package.

## Compared paths

- Candidate A: plain `pdf` 3.13.1 with IBM Plex Sans Arabic and explicit RTL.
- Candidate B: `pdf_text_shaper` 1.1.1 using HarfBuzz FFI and shaped glyph
  outlines embedded in PDF. Its package metadata does not advertise Web.
- Candidate D: `payv` 0.1.2, a pure-Dart OpenType shaper and independent PDF
  writer. It compiles to JavaScript, but its early release maturity and separate
  PDF writer remain risks.
- Candidate C (backend-generated documents) remains an architecture alternative
  only. This POC makes no Laravel/API changes.

## Corpus and fonts

The fixed synthetic corpus covers Arabic letter joining, lam-alef forms,
mixed Arabic/Latin runs, punctuation, bidi isolates, Arabic-Indic and Western
digits, supplied currency/date/phone/UUID strings, long paragraphs, and long
table cells. **Vowel diacritics are not an acceptance requirement.** The corpus
contains no customer data. No amount is calculated or changed.

IBM Plex Sans Arabic and Vazirmatn TTF fixtures are byte-for-byte upstream
files. Their SIL OFL 1.1 license texts are included beside the fixtures.
Exact upstream blob identifiers are recorded in `FONT_SOURCES.md`.

## Run

From this directory:

1. Run `flutter pub get`.
2. Run `dart format --output=none --set-exit-if-changed .`.
3. Run `dart analyze`.
4. Run `flutter test test`.
5. Run `dart run bin/generate_poc.dart`.
6. Run `dart compile js bin/payv_web_compile.dart -o build/payv_web_compile.js`.

The generator writes three candidate PDFs and a JSON measurement report under
`build/poc-artifacts`. It records byte length and generation time; these
figures are diagnostics, not proof of visual correctness.

The JavaScript step validates that the pure-Dart Payv renderer and its
transitive dependencies compile for Web. It does **not** claim browser runtime
PDF generation or browser-viewer acceptance.

## Manual findings

- Candidate A rendered Arabic joining, but unisolated mixed LTR values require
  explicit directional isolation.
- Candidate B increased output to roughly 3 MB and showed mixed-bidi/extraction
  ordering defects in the fixture.
- Candidate D rendered Arabic joining with output around 30 KB in the Linux
  sample. An LTR phone value was visually ordered correctly when wrapped in
  Unicode LTR isolates (U+2066/U+2069); the unisolated sample was reversed.
- Native Ubuntu and Windows generation both completed successfully on the
  recorded exact head. Native output sizes were consistent across the two runs.
- Text extraction showed the same distinction: isolated LTR values preserve the
  expected order; extraction alone is not a visual acceptance test.

These findings make Payv the leading **research candidate**, not an approved
production provider. The host must supply explicit direction boundaries for
Latin/numeric runs embedded in Arabic paragraphs.

## Production boundary

No production dependency, renderer switch, public API change, host app
integration, Laravel change, invoice migration, financial logic, or official
document policy is approved by this POC. The production complex-RTL rejection
guard remains unchanged. A separate owner decision is required before
production provider integration.
