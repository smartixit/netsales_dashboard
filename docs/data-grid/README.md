
# NetSales Reusable DataGrid

## Engine and public entry point

The system uses Syncfusion Flutter DataGrid (SfDataGrid) as the rendering/interaction engine and exposes a stable NetSales wrapper:

```dart
import 'package:netsales/widgets/data_grid/data_grid.dart';
```

## Architecture

- `AppDataGridColumn<T>`: typed column definition, value getter, optional renderer/editor/parser/validator. An edit handler returns the updated typed record; null rejects the edit.
- `NetSalesDataGridSource<T>`: adapts host records to Syncfusion. Keep it long-lived in the feature controller/binding; never create it in build(). It supports guarded load-more callbacks and `appendRows()` for fetched batches; call `setHasMore(false)` when the source is exhausted. Remote page/load-more failures can be surfaced through the source failure callbacks.
- `AppDataGrid<T>`: Stateless UI wrapper for design tokens, toolbar, states, responsive rendering, selection and navigation. Local filter/sort lifecycle callbacks are exposed for active-filter chips and query synchronization.
- `AppDataGridColumnChooser<T>`: reusable visibility menu that prevents hiding the final visible column.
- `AppDataGridFeatures`: feature policy for one grid.
- `AppDataGridPagination`: page-based or cursor-based navigation; cursor mode has no fabricated total-page count. Page-based desktop/tablet mode uses Syncfusion `SfDataPager`; local data is paged automatically and remote page changes are delegated through `NetSalesDataGridSource.onPageChange`. Mobile uses the same page state with previous/next controls and does not slice an already server-paginated page.
- `AppDataGridExportController`: Excel/PDF export through the shared FileExportService.

## Remote-data safety

Set `dataMode: AppDataGridDataMode.remote` for API-backed partial datasets. Local filtering is disabled in remote mode. Sorting and filter-menu changes are intercepted and delegated to the feature controller (`onSortRequested` / `onFilterRequested`). Search, advanced filters, page/cursor navigation and server-side export must flow through feature Use Cases, repositories and Laravel API. Never sort/filter only the loaded cursor page and imply the result covers all records.

Exports from the grid controller contain currently loaded rows. A full filtered result export must use an authorized backend export endpoint/job and return the complete artifact.

The generic layer has no HTTP, permissions, workspace, financial or business logic. Editing only emits a typed callback; feature code performs mutations through Use Cases and refreshes from the authoritative response.

## Responsive and visual behavior

`AppDataGrid` uses its actual allocated width (not the physical monitor/window width) and the centralized `AppBreakpoints.dataGridCompactMax` breakpoint. Below that threshold it renders key/value record cards and hides grid-only export controls; at or above it, it renders `SfDataGrid` with horizontal scrolling. Feature-specific directories must use the same shared breakpoint when choosing between their list and `AppDataGrid`, and provide `mobileItemBuilder` for the compact presentation. Page/cursor pagination reflows vertically below 480 dp of inner width so long Arabic labels cannot force a horizontal `RenderFlex` overflow. Toolbar count chips wrap onto additional runs. Mobile selection uses checkboxes, page-based lists use previous/next controls, and guarded load-more/pull-to-refresh callbacks are supported when enabled. Light/Dark uses the active NetSales AppColors palette. RTL follows Directionality.

## Syncfusion capabilities surfaced

Column widgets, sorting and multi-sort, built-in filter menus, row/checkbox selection, editing hooks, column resizing/reordering/visibility, frozen columns/rows, grouping, stacked headers, summary rows, footer, pull-to-refresh/load-more hooks, page/cursor pagination, Excel/PDF export, dark/light and RTL.

## License

Syncfusion DataGrid and DataGrid Export require a commercial license or a valid Community License. Verify formal eligibility before distribution; this implementation does not assume license eligibility.
