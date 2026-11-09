import 'package:document_engine/document_engine.dart';
import 'package:document_engine/document_engine_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_overview_document_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class PlatformOverviewDocumentPreviewDialog extends GetView<PlatformOverviewDocumentController> {
  const PlatformOverviewDocumentPreviewDialog({
    required this.artifact,
    super.key,
  });

  final DocumentArtifact artifact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n.isArabic ? 'تقرير نظرة عامة على المنصة' : 'Platform overview report';

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1120,
          maxHeight: 820,
          minWidth: 320,
          minHeight: 420,
        ),
        child: DocumentArtifactPreview(
          artifact: artifact,
          title: title,
          toolbar: Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                CustomButton.outline(
                  text: l10n.text('save_pdf'),
                  prefix: const Icon(Icons.download_outlined, size: 16),
                  size: AppButtonSize.small,
                  loading: controller.isSaving.value,
                  onPressed: controller.isSaving.value
                      ? null
                      : () => controller.save(artifact),
                ),
                CustomButton.outline(
                  text: l10n.text('share_pdf'),
                  prefix: const Icon(Icons.share_outlined, size: 16),
                  size: AppButtonSize.small,
                  loading: controller.isSharing.value,
                  onPressed: controller.isSharing.value
                      ? null
                      : () => controller.share(artifact),
                ),
                CustomButton.outline(
                  text: l10n.text('print_pdf'),
                  prefix: const Icon(Icons.print_outlined, size: 16),
                  size: AppButtonSize.small,
                  loading: controller.isPrinting.value,
                  onPressed: controller.isPrinting.value
                      ? null
                      : () => controller.print(artifact),
                ),
                CustomButton.text(
                  text: l10n.text('close'),
                  onPressed: Get.back<void>,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
