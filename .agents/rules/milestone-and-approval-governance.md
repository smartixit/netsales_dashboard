---
trigger: always_on
description: Mandatory milestone approval discipline and cross-repository governance rules for Flutter.
---

# Rule: Milestone and Approval Governance (Flutter)

## 1. Explicit Approval Prerequisite
- No Flutter feature implementation may commence without explicit user approval of the preceding milestone.
- Do not start Milestone 2 (Shell Navigation & Workspace Isolation) or subsequent feature milestones without explicit instruction.

## 2. Shared Project Memory Authority
- Shared product/API specifications remain canonical in `netsales_api/docs/project/`.
- Dashboard-specific project overview, state, decisions, and work history reside in this repository's `docs/project/`.
- The original `netsales` repository is a source reference for inherited components only.
- Always review this repository's `docs/project/PROJECT_STATE.md` and `docs/project/DECISION_LOG.md`, plus the shared API contract references, before implementation.

## 3. Work Logging and Diff Verification
- Keep git changes scoped exclusively to the authorized task.
- Verify analyzer health (`flutter analyze`) and run relevant tests before concluding.
- Record completed work in `docs/project/WORK_LOG.md`.
