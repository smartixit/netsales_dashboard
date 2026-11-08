import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/controllers/platform_networks_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformNetworkFilterBar extends StatelessWidget {
  const PlatformNetworkFilterBar({
    required this.controller,
    required this.l10n,
    super.key,
  });

  final PlatformNetworksController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final search = SizedBox(
        width: constraints.maxWidth >= 780 ? 370 : double.infinity,
        child: CustomTextField(
          controller: controller.searchController,
          label: l10n.text('network_search'),
          hint: l10n.text('network_search_hint'),
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
            _Filter(label: l10n.text('all'), value: '', controller: controller),
            _Filter(
              label: l10n.text('network_status_active'),
              value: 'ACTIVE',
              controller: controller,
            ),
            _Filter(
              label: l10n.text('network_status_pending'),
              value: 'PENDING',
              controller: controller,
            ),
            _Filter(
              label: l10n.text('network_status_inactive'),
              value: 'INACTIVE',
              controller: controller,
            ),
            _Filter(
              label: l10n.text('network_status_rejected'),
              value: 'REJECTED',
              controller: controller,
            ),
            _Filter(
              label: l10n.text('network_status_banned'),
              value: 'BANNED',
              controller: controller,
            ),
          ],
        ),
      );
      return constraints.maxWidth >= 780
          ? Row(
              children: [
                search,
                SizedBox(width: AppSpacing.md),
                Expanded(child: filters),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                search,
                SizedBox(height: AppSpacing.md),
                filters,
              ],
            );
    },
  );
}

class _Filter extends StatelessWidget {
  const _Filter({
    required this.label,
    required this.value,
    required this.controller,
  });

  final String label;
  final String value;
  final PlatformNetworksController controller;

  @override
  Widget build(BuildContext context) => CustomButton(
    text: label,
    onPressed: () => controller.setStatus(value),
    variant: controller.selectedStatus.value == value
        ? AppButtonVariant.secondary
        : AppButtonVariant.text,
    size: AppButtonSize.small,
  );
}
