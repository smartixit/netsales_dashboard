import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/core/services/file_export_service.dart';
import 'package:netsales_dashboard/core/services/share_service.dart';
import 'package:netsales_dashboard/features/platform_reports/domain/entities/platform_report_models.dart';

class PlatformReportsRepository {
  const PlatformReportsRepository();

  static const _base = '/platform/reports';

  Future<List<PlatformReportCatalogItem>> catalog() async {
    final response = await ApiService.instance.get<List<PlatformReportCatalogItem>>(
      '$_base/catalog',
      fromJson: (data) {
        if (data is! List) return const <PlatformReportCatalogItem>[];
        return data.whereType<Map>().map((row) =>
          PlatformReportCatalogItem.fromJson(Map<String, dynamic>.from(row))
        ).toList(growable: false);
      },
    );
    if (!response.success || response.data == null) {
      throw StateError(response.message.isEmpty ? 'تعذر تحميل كتالوج تقارير الفوترة.' : response.message);
    }
    return response.data!;
  }

  Future<PlatformReportRun> create({
    required String key,
    Map<String, dynamic> filters = const {},
  }) async {
    final response = await ApiService.instance.post<PlatformReportRun>(
      '$_base/runs',
      data: {'report_key': key, 'filters': filters},
      fromJson: (data) => PlatformReportRun.fromJson(Map<String, dynamic>.from(data as Map)),
    );
    if (!response.success || response.data == null) {
      throw StateError(response.message.isEmpty ? 'تعذر تسجيل التقرير.' : response.message);
    }
    return response.data!;
  }

  Future<PlatformReportRun> refresh(int id) async {
    final response = await ApiService.instance.get<PlatformReportRun>(
      '$_base/runs/$id',
      fromJson: (data) => PlatformReportRun.fromJson(Map<String, dynamic>.from(data as Map)),
    );
    if (!response.success || response.data == null) {
      throw StateError(response.message.isEmpty ? 'تعذر تحديث حالة التقرير.' : response.message);
    }
    return response.data!;
  }

  Future<void> share(PlatformReportRun run) async {
    final url = run.downloadUrl;
    if (!run.isCompleted || url == null || url.isEmpty) {
      throw StateError('ملف التقرير غير جاهز للمشاركة.');
    }
    final response = await ApiService.instance.dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) throw StateError('ملف التقرير فارغ.');
    await ShareService.instance.shareBytes(
      bytes: Uint8List.fromList(bytes),
      fileName: '${run.reportKey}.json',
      mimeType: 'application/json',
      subject: 'تقرير فوترة NetSales',
    );
  }

  Future<void> download(PlatformReportRun run) async {
    final url = run.downloadUrl;
    if (!run.isCompleted || url == null || url.isEmpty) {
      throw StateError('ملف التقرير غير جاهز للتنزيل.');
    }
    final response = await ApiService.instance.dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) throw StateError('ملف التقرير فارغ.');
    final result = await FileExportService.instance.saveFile(
      bytes: Uint8List.fromList(bytes),
      fileName: run.reportKey,
      extension: 'json',
      folderName: 'NetSales/PlatformReports',
      namingStrategy: FileNamingStrategy.report,
    );
    if (!result.isSuccess) throw StateError(result.errorMessage ?? 'تعذر حفظ الملف.');
  }
}
