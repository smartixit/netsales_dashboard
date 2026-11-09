# M8 — Document finishing primitives

## QR rendering
The host supplies an opaque verification payload. The engine encodes it into a
QR graphic and may display a human-readable reference supplied separately.
The engine never creates cryptographic tokens, signs payloads, decrypts
challenges, validates QR references, or decides document validity.

## Watermarks
A bounded visual watermark supports draft, copy, confidential, and cancelled
presentation. It is not an authoritative status field and cannot promote or
invalidate a document. The host is responsible for selecting truthful wording
from backend-provided status.

## Signature and approval display
The signature area distinguishes:
- a supplied visual signature image;
- printed signer identity and role;
- server-supplied approval reference and timestamp.

None of these is represented as a cryptographic signature. Legal signing,
trusted timestamping, certificate validation, and regulatory seals remain
separate backend capabilities.

## Receipt page profiles
The 58 mm and 80 mm factories create explicit fixed-height PDF page geometry.
They do not implement raw ESC/POS, printer discovery, cutting, drawer pulses,
or printer command languages. The host must choose the height from the
document's content/layout requirements and create a new artifact when it
changes.

## Safety
QR payloads are opaque, size-bounded, and never logged by the package.
Visual signature bytes are copied defensively and capped at 1 MiB. Watermark,
QR, and signature features require explicit template capabilities. Arabic text
in labels/captions/watermarks remains rejected by the production renderer
until a separate provider approval and verification milestone.
