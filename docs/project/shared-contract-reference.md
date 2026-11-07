# NetSales Dashboard — Shared Contract & Reference Index

This document provides direct mapping from Flutter feature domains to their canonical source specifications in `netsales_api/docs/project/`.

---

## 1. Canonical Reference Map

| Business Area | Canonical Specification File | Flutter Implementation Responsibility |
|---|---|---|
| **Product Scope & Anti-Definitions** | [`PRODUCT_SCOPE.md`](file:///d:/Smartix/NetSales/netsales_api/docs/project/PRODUCT_SCOPE.md) | Expose Platform Scope roles in this Dashboard; keep Network/POS workspaces in the separate mobile client and preserve product anti-definitions. |
| **Business Domains** | [`DOMAIN_MAP.md`](file:///d:/Smartix/NetSales/netsales_api/docs/project/DOMAIN_MAP.md) | Align feature directory names with official system domains. |
| **System Architecture** | [`ARCHITECTURE.md`](file:///d:/Smartix/NetSales/netsales_api/docs/project/ARCHITECTURE.md) | Enforce GetX Controllers, Bindings, and AppPages routing. |
| **API Wire Contracts & Enums** | [`API_CONTRACTS.md`](file:///d:/Smartix/NetSales/netsales_api/docs/project/API_CONTRACTS.md) | Parse exact Enum wire values and map translated `*_label` fields. |
| **RBAC & Tenant Scoping** | [`RBAC_AND_TENANT_CONTEXT.md`](file:///d:/Smartix/NetSales/netsales_api/docs/project/RBAC_AND_TENANT_CONTEXT.md) | Follow the endpoint's actual scope; do not invent tenant headers for global Platform Scope requests. |
| **Financial Authority** | [`FINANCIAL_INVARIANTS.md`](file:///d:/Smartix/NetSales/netsales_api/docs/project/FINANCIAL_INVARIANTS.md) | **Zero client-side calculations.** Render authoritative numbers; treat previews as non-binding. |
| **Active Project State** | `docs/project/PROJECT_STATE.md` | Check Dashboard-specific milestones and blockers before coding. |
| **Decision Register** | `docs/project/DECISION_LOG.md` | Follow Dashboard-specific decisions; shared API decisions remain in the API repository. |
| **Work History** | `docs/project/WORK_LOG.md` | Record Dashboard execution history locally. |

---

## 2. Invariant Rules for Flutter Engineers
1. **Never calculate financial balances on client:** Rely 100% on Laravel API responses.
2. **Reuse existing infrastructure (Mandatory):**
   - Use `lib/widgets/` for all UI components (`CustomDialog`, `CustomBottomSheet`, `CustomButton`, `CustomTextField`, `CustomSnackbar`, `CustomToast`, `CustomEmptyState`, `CustomLoadingState`, `CustomErrorState`, skeletons, pickers). Never invent fake names or redundant dialogs.
   - Use `lib/core/utils/` for formatters (`DateFormatter`, `AmountFormatter`, `TextFormatter`, `FileSizeFormatter`, `FormValidators`, `IdempotencyHelper`).
   - Use `lib/core/services/` for system services (`ApiService`, `WorkspaceService`, `SessionService`, `ThemeService`, `StorageService`, etc.).
   - Use `lib/core/themes/` and `lib/core/constants/` for tokens (`AppColors`, `AppTypography`, `AppRadius`, `AppSpacing`, `AppElevation`, `AppGradients`, `AppMotion`, `AppThemes`).
3. **Use GetX exclusively:** Prohibit Provider, Riverpod, Bloc, or stateful widget state machines.
4. **Desktop and Web Adaptation:** Build from actual window/viewport constraints; keep native window management inside `packages/desktop_windowing` and do not attempt to resize browser windows.
