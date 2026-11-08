import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/controllers/platform_network_pos_links_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';

class PlatformNetworkPosLinkCreateDialog {
  PlatformNetworkPosLinkCreateDialog._();

  static Future<bool?> show({
    required PlatformNetworkPosLinksController controller,
    required AppLocalizations l10n,
  }) => CustomDialog.custom(
    title: l10n.text('create_network_pos_link'),
    maxWidth: 620,
    confirmLabel: l10n.text('create_link'),
    cancelLabel: l10n.text('cancel'),
    onConfirm: () {
      if (controller.selectedNetworkListenable.value == null ||
          controller.selectedPosListenable.value == null) {
        return;
      }
      Navigator.of(Get.context!).pop(true);
    },
    content: _CreateContent(controller: controller, l10n: l10n),
  ).showDialog();
}

class _CreateContent extends StatelessWidget {
  const _CreateContent({required this.controller, required this.l10n});

  final PlatformNetworkPosLinksController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        l10n.text('network_pos_link_creation_note'),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      SizedBox(height: AppSpacing.lg),
      CustomDropdown<int>(
        label: l10n.text('network_name'),
        hint: l10n.text('select_network'),
        prefixIcon: Icons.router_outlined,
        isRequired: true,
        valueListenable: controller.selectedNetworkListenable,
        items: controller.networks
            .map(
              (network) => DropdownItem<int>(
                value: network.id,
                child: Text(network.name),
              ),
            )
            .toList(growable: false),
        itemSearchText: (id) => controller.networks
            .firstWhere((item) => item.id == id)
            .name,
        onChanged: (value) {
          controller.selectedNetworkId.value = value;
          controller.selectedNetworkListenable.value = value;
        },
      ),
      SizedBox(height: AppSpacing.md),
      CustomDropdown<int>(
        label: l10n.text('pos_name'),
        hint: l10n.text('select_pos'),
        prefixIcon: Icons.storefront_outlined,
        isRequired: true,
        valueListenable: controller.selectedPosListenable,
        items: controller.pointsOfSale
            .map(
              (pos) => DropdownItem<int>(
                value: pos.id,
                child: Text(pos.name),
              ),
            )
            .toList(growable: false),
        itemSearchText: (id) => controller.pointsOfSale
            .firstWhere((item) => item.id == id)
            .name,
        onChanged: (value) {
          controller.selectedPosId.value = value;
          controller.selectedPosListenable.value = value;
        },
      ),
      SizedBox(height: AppSpacing.md),
      Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(l10n.text('network_pos_link_wallet_note')),
            ),
          ],
        ),
      ),
    ],
  );
}
