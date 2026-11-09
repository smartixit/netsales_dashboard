# Arabic PDF Typography — Proof of Concept Plan

**Status:** PROPOSED — research plan only
**Package:** packages/document_engine
**Date:** 2026-11-09
**Purpose:** Determine whether the selected PDF rendering stack can produce correct Arabic and mixed-direction output across required application targets. This plan does not add a dependency or create production templates.

---

## 1. Questions the POC must answer

1. Are Arabic letters shaped and joined correctly in all contextual forms?
2. Is the visual order of mixed Arabic, Latin, numbers, punctuation, and identifiers correct?
3. Does the PDF preserve selectable/searchable text, or does the shaping path convert glyphs to vector paths?
4. Can the chosen strategy work on Windows and Web, not merely in a native mobile test?
5. Are embedded fonts correctly subset/embedded, and are all glyphs present?
6. Do long Arabic table cells wrap and paginate without clipped glyphs or reordered punctuation?
7. Does the chosen approach keep PDF size, generation latency, and memory within measured budgets?

## 2. Candidate strategies

| Candidate | Description | Why evaluate it | Decision |
|---|---|---|---|
| A | Existing pdf 3.13.1 renderer with embedded IBM Plex Sans Arabic and RTL direction | Lowest dependency cost; already used in the ecosystem | Baseline, not presumed correct |
| B | pdf plus a HarfBuzz-backed shaping provider, including evaluation of pdf_text_shaper | May improve complex-script shaping | Research candidate only; platform/API/license evidence required |
| C | Backend-generated PDF using a separately chosen server renderer | Useful for official artifacts and a possible Web fallback | Compare output and accessibility; not a replacement decision yet |

No candidate is approved solely from its package description or a simple Arabic sentence.

## 3. Fixed test corpus

Use stable fixtures with no customer or production data.

### A. Script and shaping cases

- Arabic words containing isolated, initial, medial, and final joining forms.
- Arabic phrases containing lam-alef ligatures and common diacritics.
- Arabic names with long sequences and punctuation.
- English words and identifiers within Arabic paragraphs.
- Arabic and English headings on the same page.
- Arabic text containing parentheses, slashes, hyphens, percent signs, and currency codes.

### B. Numeric and identifier cases

- Western digits and Arabic-Indic digits.
- Phone numbers.
- Invoice references and UUID-like values.
- Dates and time values.
- Decimal separators and thousands separators as pre-formatted strings supplied by the test fixture.
- Mixed currency code and amount placement.

The POC must not calculate or reformat financial values. It tests rendering of supplied strings.

### C. Table and pagination cases

- Narrow and wide columns.
- Long Arabic item descriptions.
- Mixed Arabic/English product or service labels.
- Multi-line cells spanning page boundaries.
- Repeating table headings on subsequent pages.
- Keep-together headings and summary blocks.
- Portrait and landscape.
- Several pages with header/footer and page numbering.

## 4. Target matrix

| Target | Required evidence |
|---|---|
| Windows desktop | Actual PDF output, print-preview readability, font embedding, copy/search |
| Responsive Web | Browser-generated/previewed PDF, bidi output, download and print consistency |
| macOS/Linux | Run only if these platforms are declared supported by the host package matrix |
| Android/iOS | Evaluate if they remain supported targets for the reusable package; do not infer support from Windows/Web |

A successful Windows run must not be used to claim Web or mobile compatibility.

## 5. Measurements and observations

For every candidate/target pair record:

- Visual correctness for every corpus case.
- Text selection and search behavior.
- Extracted text order where meaningful.
- Missing glyph count.
- PDF byte size.
- Generation elapsed time.
- Peak memory if measurable.
- Failure behavior when a font/glyph is absent.
- Platform/API limitations.
- License and transitive dependency review.

Use actual rendered PDF pages for visual review. Text extraction alone does not prove visual correctness.

## 6. Acceptance criteria

A strategy is eligible for adoption only when:

1. Arabic joining is correct across the corpus.
2. Mixed RTL/LTR runs and punctuation are stable.
3. Table cells wrap and paginate without clipping or overlap.
4. Font embedding is deterministic and missing glyphs are surfaced, not silently substituted.
5. PDF text accessibility (selection/search) tradeoffs are explicitly accepted.
6. All in-scope targets pass independently.
7. Performance and output-size budgets are measured and approved.
8. Dependency maintenance, license, bundle size, and platform support have been reviewed.
9. A renderer adapter can be replaced without changing public document contracts.

## 7. Decision record

At the end of the POC, record:

- Chosen provider per target (if different).
- Why rejected candidates were not suitable.
- Whether selectable text is preserved.
- Any Web/native fallback difference.
- Known limitations.
- Required dependency/version and licensing evidence.
- Explicit approval required before adding the dependency or implementation code.

Until this decision is approved, pdf_text_shaper and every other shaping package remain unselected research candidates.