import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_users_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformUsersFilterBar extends StatelessWidget {
  const PlatformUsersFilterBar({
    super.key,
    required this.controller,
    required this.l10n,
    this.showStatusFilters = true,
  });
  final PlatformUsersController controller;
  final AppLocalizations l10n;
  final bool showStatusFilters;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final search = SizedBox(
        width: constraints.maxWidth >= 760 ? 360 : double.infinity,
        child: CustomTextField(
          controller: controller.searchController,
          label: l10n.text('search_users'),
          hint: l10n.text('search_users_hint'),
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
            if (showStatusFilters) _Filter(label: l10n.text('all'), value: '', controller: controller),
            if (showStatusFilters) _Filter(
              label: l10n.text('user_status_active'),
              value: 'ACTIVE',
              controller: controller,
            ),
            if (showStatusFilters) _Filter(
              label: l10n.text('user_status_inactive'),
              value: 'INACTIVE',
              controller: controller,
            ),
            if (showStatusFilters) _Filter(
              label: l10n.text('user_status_pending'),
              value: 'PENDING',
              controller: controller,
            ),
            if (showStatusFilters) _Filter(
              label: l10n.text('user_status_banned'),
              value: 'BANNED',
              controller: controller,
            ),
          ],
        ),
      );
      return constraints.maxWidth >= 760
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
  final PlatformUsersController controller;
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
