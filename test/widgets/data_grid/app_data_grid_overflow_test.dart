import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/net_sales_data_grid_source.dart';
import 'package:netsales_dashboard/widgets/data_grid/app_data_grid.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_column.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_features.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_pagination.dart';

class _Record {
  const _Record(this.id, this.name);

  final int id;
  final String name;
}

void main() {
  late NetSalesDataGridSource<_Record> source;

  setUp(() {
    source = NetSalesDataGridSource<_Record>(
      items: const <_Record>[
        _Record(1, 'شبكة الاختبار الأولى'),
        _Record(2, 'شبكة الاختبار الثانية'),
      ],
      columns: const <AppDataGridColumn<_Record>>[
        AppDataGridColumn<_Record>(
          name: 'id',
          label: 'المعرف',
          valueGetter: _recordId,
          width: 90,
        ),
        AppDataGridColumn<_Record>(
          name: 'name',
          label: 'اسم الشبكة',
          valueGetter: _recordName,
          width: 220,
        ),
      ],
    );
  });

  testWidgets(
    'uses compact cards and wraps long cursor pagination in a narrow allocation',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1440, 900),
          builder: (context, child) => MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 420,
                    height: 620,
                    child: AppDataGrid<_Record>(
                      source: source,
                      features: const AppDataGridFeatures(
                        dataMode: AppDataGridDataMode.remote,
                        allowSorting: false,
                        allowFiltering: false,
                      ),
                      title: 'شبكات المنصة',
                      pagination: AppDataGridPagination.cursorBased(
                        hasPrevious: false,
                        hasNext: true,
                        onPrevious: _noop,
                        onNext: _noop,
                        pageLabel:
                            'عرض النتائج المحملة حالياً من سجلات الشبكات مع إمكانية تحميل المزيد من النتائج',
                      ),
                      mobileItemBuilder: (context, item) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(item.name),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('data-grid-mobile')), findsOneWidget);
      expect(find.byTooltip('التالي'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    },
  );

  testWidgets(
    'uses tabular DataGrid when the allocated width is above the compact breakpoint',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1440, 900),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 900,
                  height: 620,
                  child: AppDataGrid<_Record>(
                    source: source,
                    features: const AppDataGridFeatures(
                      dataMode: AppDataGridDataMode.remote,
                      allowSorting: false,
                      allowFiltering: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('data-grid-desktop')), findsOneWidget);
      expect(find.byKey(const ValueKey('data-grid-mobile')), findsNothing);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    },
  );
}

Object? _recordId(_Record record) => record.id;
Object? _recordName(_Record record) => record.name;

Future<void> _noop() async {}
