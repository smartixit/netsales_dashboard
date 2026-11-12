# M8 — Document finishing primitives

## QR rendering
The host supplies an opaque verification payload. The engine encodes it into a
QR graphic and may display a human-readable reference supplied separately.
The engine never creates cryptographic tokens, signs payloads, decrypts
challenges, validates QR references, or decides document validity.

## Watermarks

Watermarks are image-only. The consuming application selects the identity asset
for the active workspace and injects its bytes:
- Network workspace: the active Network profile logo.
- POS workspace: the active POS profile logo.
- Fallback: the bundled NetSales application icon.

The engine never resolves tenant identity, loads host assets, or fetches image
URLs. The contract accepts PNG/JPEG bytes only, defensively copies them, caps
the payload at 2 MiB, and supports bounded opacity, rotation, and relative
width/height. It does not accept or render text watermarks. A watermark is a
visual mark only and never changes authoritative invoice or report status.


