# NetSales Dashboard — Project Overview

## Identity
A standalone Flutter application for NetSales Platform Scope. It is independent from the Network/POS mobile client.

## Users and scope
- Platform roles: `SUPER_ADMIN`, `SUPPORT_AGENT`, and platform `ACCOUNTANT`.
- Primary targets: Windows desktop and responsive Web.
- In scope: platform SaaS subscriptions/licensing, platform support, global operations, and platform accounting surfaces exposed by the canonical Laravel API.
- Out of scope: Network and POS workspaces, consumer retail checkout, voucher-card inventory, and router/RADIUS management.

## Repository boundaries
- Dashboard implementation, UI, local architecture, state, decisions, and work history live here.
- Shared API contracts, server authorization, financial invariants, and backend implementation remain canonical in `smartixit/netsales_api`.
- `smartixit/netsales` is an inherited-component reference only.

## Architecture
- Flutter feature-first Clean Architecture and GetX.
- Laravel API remains the sole authorization and financial authority.
- Generic UI frameworks under `lib/widgets` remain independent from NetSales business logic.
- Reusable desktop window management is maintained as a local package under `packages/desktop_windowing`.
