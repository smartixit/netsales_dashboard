# NetSales Dashboard — Project Documentation & Canonical Authority

## 1. Authority Boundaries
- Shared product scope, API contracts, RBAC, financial invariants, and backend state remain canonical in `netsales_api/docs/project/`.
- Dashboard-specific architecture, decisions, project state, and work history are maintained locally in this repository.
- Do not write Dashboard-specific decisions or work logs into `netsales_api`.

---

## 2. Local Documentation Index
- **[PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md):** Independent Dashboard purpose, roles, platforms, and scope.
- **[PROJECT_STATE.md](./PROJECT_STATE.md):** Current Dashboard implementation state and blockers.
- **[DECISION_LOG.md](./DECISION_LOG.md):** Dashboard-specific approved/proposed decisions.
- **[WORK_LOG.md](./WORK_LOG.md):** Dashboard execution history.
- **[shared-contract-reference.md](./shared-contract-reference.md):** Maps Dashboard integration to canonical Laravel API contracts.
- **[AGENTS.md](../../AGENTS.md):** Permanent constitutional rules and invariants for Flutter development.
- **[.agents/rules/](../../.agents/rules/):** Modular rules governing GetX state management, theme preservation, and security boundaries.

---

## 3. Proposed Architecture Work
- [Document Engine Architecture Blueprint](../architecture/document-engine/ARCHITECTURE_BLUEPRINT.md): proposed reusable document/reporting engine architecture. Design-only; implementation requires explicit approval.
- [Arabic PDF Typography POC](../architecture/document-engine/ARABIC_PDF_POC.md): evidence matrix for Arabic shaping, mixed RTL/LTR text, and PDF output. No dependency is approved by this plan.

---

## 4. Cross-Repository Verification Tool
To verify that canonical documentation exists and is accessible from the Flutter workspace without cross-platform symlink issues:
```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify-project-governance.ps1
```
This script checks the status and synchronization of canonical documents in `netsales_api/docs/project/`.
