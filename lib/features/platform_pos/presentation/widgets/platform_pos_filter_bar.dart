import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/controllers/platform_pos_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformPosFilterBar extends StatelessWidget {
  const PlatformPosFilterBar({required this.controller, required this.l10n, super.key});
  final PlatformPosController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final search = SizedBox(
      width: constraints.maxWidth >= 760 ? 360 : double.infinity,
      child: CustomTextField(
        controller: controller.searchController,
        label: l10n.text('search_pos'),
        hint: l10n.text('search_pos_hint'),
        prefixIcon: const Icon(Icons.search_rounded),
        isRequired: false,
        onChanged: controller.onSearchChanged,
      ),
    );
    final filters = Obx(() => Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        _Filter(label: l10n.text('all'), value: '', controller: controller),
        _Filter(label: l10n.text('pos_status_active'), value: 'ACTIVE', controller: controller),
        _Filter(label: l10n.text('pos_status_pending'), value: 'PENDING', controller: controller),
        _Filter(label: l10n.text('pos_status_inactive'), value: 'INACTIVE', controller: controller),
        _Filter(label: l10n.text('pos_status_rejected'), value: 'REJECTED', controller: controller),
        _Filter(label: l10n.text('pos_status_banned'), value: 'BANNED', controller: controller),
      ],
    ));
    return constraints.maxWidth >= 760
      ? Row(children: [search, SizedBox(width: AppSpacing.md), Expanded(child: filters)])
      : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [search, SizedBox(height: AppSpacing.md), filters]);
  });
}

class _Filter extends StatelessWidget {
  const _Filter({required this.label, required this.value, required this.controller});
  final String label;
  final String value;
  final PlatformPosController controller;

  @override
  Widget build(BuildContext context) => Obx(() => CustomButton(
    text: label,
    onPressed: () => controller.setStatus(value),
    variant: controller.selectedStatus.value == value ? AppButtonVariant.secondary : AppButtonVariant.text,
    size: AppButtonSize.small,
  ));
}
