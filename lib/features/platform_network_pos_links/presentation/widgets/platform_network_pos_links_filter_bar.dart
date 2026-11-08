import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/controllers/platform_network_pos_links_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformNetworkPosLinksFilterBar extends StatelessWidget {
  const PlatformNetworkPosLinksFilterBar({
    required this.controller,
    required this.l10n,
    super.key,
  });

  final PlatformNetworkPosLinksController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final search = SizedBox(
        width: constraints.maxWidth >= 850 ? 340 : double.infinity,
        child: CustomTextField(
          controller: controller.searchController,
          label: l10n.text('search_network_pos_links'),
          hint: l10n.text('search_network_pos_links_hint'),
          prefixIcon: const Icon(Icons.search_rounded),
          isRequired: false,
          onChanged: controller.onSearchChanged,
        ),
      );
      final filters = Obx(
        () => Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _StatusFilter(controller: controller, value: '', label: l10n.text('all')),
            _StatusFilter(controller: controller, value: 'true', label: l10n.text('link_status_active')),
            _StatusFilter(controller: controller, value: 'false', label: l10n.text('link_status_inactive')),
          ],
        ),
      );
      return constraints.maxWidth >= 850
          ? Row(
              children: [
                search,
                SizedBox(width: AppSpacing.md),
                Expanded(child: filters),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [search, SizedBox(height: AppSpacing.sm), filters],
            );
    },
  );
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({
    required this.controller,
    required this.value,
    required this.label,
  });

  final PlatformNetworkPosLinksController controller;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => CustomButton(
    text: label,
    size: AppButtonSize.small,
    variant: controller.statusFilter.value == value
        ? AppButtonVariant.secondary
        : AppButtonVariant.text,
    onPressed: () => controller.applyFilters(status: value),
  );
}
