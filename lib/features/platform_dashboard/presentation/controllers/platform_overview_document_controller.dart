import 'package:document_engine/document_engine.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/services/locale_service.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/create_platform_overview_document_use_case.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

class PlatformOverviewDocumentController extends GetxController {
  PlatformOverviewDocumentController({
    required this.createDocument,
    required this.output,
  });

  final CreatePlatformOverviewDocumentUseCase createDocument;
  final DocumentOutputCoordinator output;

  final RxBool isGenerating = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isSharing = false.obs;
  final RxBool isPrinting = false.obs;

  Future<DocumentArtifact?> generate(PlatformDashboardOverviewEntity data) async {
    if (isGenerating.value) return null;
    isGenerating.value = true;
    try {
      final result = await createDocument.execute(data);
      if (result is DocumentRenderSuccess) return result.artifact;
      if (result is DocumentRenderFailure) {
        _showError(result.message);
      }
      return null;
    } catch (_) {
      _showError(null);
      return null;
    } finally {
      isGenerating.value = false;
    }
  }

  Future<void> save(DocumentArtifact artifact) async {
    if (isSaving.value) return;
    isSaving.value = true;
    try {
      _handleOutput(
        await output.save(
          artifact: artifact,
          fileName: _fileName(artifact),
        ),
        successMessage: LocaleService.to.isArabic
            ? 'تم حفظ التقرير في مجلد NetSales.'
            : 'The report was saved to the NetSales export folder.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> share(DocumentArtifact artifact) async {
    if (isSharing.value) return;
    isSharing.value = true;
    try {
      _handleOutput(
        await output.share(
          artifact: artifact,
          fileName: _fileName(artifact),
        ),
        successMessage: LocaleService.to.isArabic
            ? 'تم فتح مشاركة التقرير.'
            : 'The report was sent to the share sheet.',
      );
    } finally {
      isSharing.value = false;
    }
  }

  Future<void> print(DocumentArtifact artifact) async {
    if (isPrinting.value) return;
    isPrinting.value = true;
    try {
      _handleOutput(
        await output.print(
          artifact: artifact,
          fileName: _fileName(artifact),
        ),
        successMessage: LocaleService.to.isArabic
            ? 'تم إرسال التقرير إلى الطباعة.'
            : 'The report was sent to the print dialog.',
      );
    } finally {
      isPrinting.value = false;
    }
  }

  String _fileName(DocumentArtifact artifact) =>
      'Platform-Overview-${artifact.documentId.value}';

  void _handleOutput(
    DocumentOutputResult result, {
    required String successMessage,
  }) {
    if (result is DocumentOutputCancelled) return;
    if (result is DocumentOutputSuccess) {
      CustomSnackbar.show(
        title: LocaleService.to.isArabic ? 'نجاح' : 'Success',
        message: successMessage,
        type: SnackType.success,
      );
      return;
    }
    if (result is DocumentOutputFailure) _showError(result.message);
  }

  void _showError(String? detail) {
    final isArabic = LocaleService.to.isArabic;
    CustomSnackbar.show(
      title: isArabic ? 'تعذر إنشاء أو إخراج التقرير' : 'PDF operation failed',
      message: detail ??
          (isArabic
              ? 'حدث خطأ غير متوقع. حاول مرة أخرى.'
              : 'An unexpected error occurred. Please try again.'),
      type: SnackType.error,
    );
  }
}
