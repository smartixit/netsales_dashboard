# Arabic PDF typography POC

This is an isolated M4 research harness. It is not imported by the Dashboard
application and is not a dependency of the production document_engine package.

## Compared paths

- Candidate A: plain pdf 3.13.1 with IBM Plex Sans Arabic and explicit RTL direction.
- Candidate B: pdf_text_shaper 1.1.1 using HarfBuzz FFI and shaped glyph outlines
  embedded in pdf, with an optional invisible Unicode text layer. Its package
  metadata does not advertise Web.
- Candidate D: payv 0.1.2, a pure-Dart OpenType shaper and independent vector PDF
  writer. It is the Web candidate, but its early maturity and separate PDF writer
  make it unsuitable for automatic adoption without further review.
- Candidate C (backend-generated documents) remains an architecture alternative
  only. This POC makes no Laravel/API changes.

## Corpus and fonts

The fixed synthetic corpus covers Arabic joining/diacritics, lam-alef forms,
mixed Arabic/Latin runs, punctuation, bidi isolates, Arabic-Indic and Western
digits, supplied currency/date/phone/UUID strings, long paragraphs, and long
table cells. It contains no customer data. No amount is calculated or changed.

The IBM Plex Sans Arabic and Vazirmatn TTF fixtures are byte-for-byte upstream
files. Their SIL OFL 1.1 license texts are included beside the fixtures. Exact
upstream blob identifiers are recorded in FONT_SOURCES.md.

## Run

From this directory:

1. Run flutter pub get.
2. Run dart format --output=none --set-exit-if-changed .
3. Run dart analyze.
4. Run flutter test test.
5. Run dart run bin/generate_poc.dart.

The generator writes three candidate PDFs and a JSON measurement report under
build/poc-artifacts. It records byte length and generation time; these figures
are diagnostics, not proof of visual correctness.

To compile the Payv browser path, enter web_example, run flutter pub get,
then flutter build web --release. Serve build/web, trigger the browser PDF
download, and review the downloaded file.

## Manual acceptance

Inspect every PDF in the same viewers on Windows and Web. Review joining forms,
diacritics, ligatures, bidi punctuation, digits, font embedding, long-cell
wrapping, pagination, headers, and footers. Test selection, copy/paste, search,
PDF metadata, and font subset sizes. Record OS and viewer versions.

Text extraction, a valid PDF signature, unit tests, and package descriptions
are diagnostics only; they do not prove correct rendered Arabic.

## Production boundary

No production dependency, renderer switch, public API change, host app
integration, Laravel change, invoice migration, or official-document policy
is approved by this POC. A separate provider recommendation and owner decision
are required before production implementation.
