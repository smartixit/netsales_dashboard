---
trigger: always_on
description: Non-negotiable NetSales B2B product scope, operating workspaces, and explicit anti-definitions for Flutter.
---

# Rule: NetSales Dashboard Product and Business Invariants

## 1. Product Identity and Scope
This repository is the standalone **NetSales Platform Dashboard** for platform-scope roles: `SUPER_ADMIN`, `SUPPORT_AGENT`, and platform `ACCOUNTANT`. It targets Windows desktop and responsive Web. Network/POS workspaces remain in the separate mobile client.

## 2. Explicit Anti-Definitions [STRICT PROHIBITION]
- **NOT a Voucher-Card Inventory App:** No card vaults, PIN reveal screens, serial number batch scans, or physical warehouse stock tracking.
- **NOT a Consumer Retail POS:** No consumer shopping cart, citizen checkout, or retail sale screens.
- **NOT an ISP Gateway:** No MikroTik/RADIUS router integration screens.

## 3. Scope Boundaries
- Platform Dashboard screens, navigation, licensing, and platform support are IN SCOPE here when supported by the canonical API contract.
- Network and POS workspace screens are OUT OF SCOPE for this repository.
- Do not move platform authorization into the client; Laravel remains authoritative.
