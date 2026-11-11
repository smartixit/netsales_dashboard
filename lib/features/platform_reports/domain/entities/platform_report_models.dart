class PlatformReportCatalogItem {
  const PlatformReportCatalogItem({
    required this.key,
    required this.title,
    required this.description,
    required this.version,
    required this.format,
    required this.filters,
    required this.maxRecords,
  });

  final String key;
  final String title;
  final String description;
  final String version;
  final String format;
  final Map<String, dynamic> filters;
  final int maxRecords;

  factory PlatformReportCatalogItem.fromJson(Map<String, dynamic> json) =>
      PlatformReportCatalogItem(
        key: json['key'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        version: json['definition_version'] as String? ?? '1.0.0',
        format: json['artifact_format'] as String? ?? 'JSON',
        filters: json['filters'] is Map
            ? Map<String, dynamic>.from(json['filters'] as Map)
            : const {},
        maxRecords: (json['max_records'] as num?)?.toInt() ?? 0,
      );
}

class PlatformReportRun {
  const PlatformReportRun({
    required this.id,
    required this.title,
    required this.reportKey,
    required this.status,
    required this.recordsCount,
    required this.isTruncated,
    this.downloadUrl,
    this.errorMessage,
    this.expiresAt,
  });

  final int id;
  final String title;
  final String reportKey;
  final String status;
  final int recordsCount;
  final bool isTruncated;
  final String? downloadUrl;
  final String? errorMessage;
  final DateTime? expiresAt;

  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isFailed => status.toUpperCase() == 'FAILED';
  String get statusLabel => switch (status.toUpperCase()) {
    'QUEUED' => 'في قائمة الانتظار',
    'RUNNING' => 'قيد التنفيذ',
    'COMPLETED' => 'مكتمل',
    'FAILED' => 'فشل التنفيذ',
    'EXPIRED' => 'انتهت صلاحية الملف',
    _ => 'حالة غير معروفة',
  };

  factory PlatformReportRun.fromJson(Map<String, dynamic> json) {
    final artifact = json['artifact'] is Map
        ? Map<String, dynamic>.from(json['artifact'] as Map)
        : const <String, dynamic>{};
    final error = json['error'] is Map
        ? Map<String, dynamic>.from(json['error'] as Map)
        : const <String, dynamic>{};
    return PlatformReportRun(
      id: (json['report_run_id'] as num).toInt(),
      title: json['report_title'] as String? ?? '',
      reportKey: json['report_key'] as String? ?? '',
      status: json['status'] as String? ?? 'QUEUED',
      recordsCount: (artifact['records_count'] as num?)?.toInt() ?? 0,
      isTruncated: artifact['is_truncated'] as bool? ?? false,
      downloadUrl: artifact['download_url'] as String?,
      errorMessage: error['message'] as String?,
      expiresAt: artifact['expires_at'] is String
          ? DateTime.tryParse(artifact['expires_at'] as String)
          : null,
    );
  }
}
