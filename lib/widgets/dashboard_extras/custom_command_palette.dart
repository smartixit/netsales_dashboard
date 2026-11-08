import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_shortcut_hint.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

@immutable
class CommandPaletteItem {
  const CommandPaletteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.keywords = const [],
  });
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> keywords;
}

class CustomCommandPalette {
  const CustomCommandPalette._();

  static Future<void> show({
    required BuildContext context,
    required List<CommandPaletteItem> items,
    required TextEditingController queryController,
    required RxString query,
    required ValueChanged<CommandPaletteItem> onSelected,
  }) async {
    queryController.clear();
    query.value = '';
    final l10n = AppLocalizations.of(context);
    await CustomDialog.show(
      type: DialogType.custom,
      title: l10n.text('command_palette'),
      maxWidth: 660,
      confirmLabel: l10n.text('close'),
      content: _CommandPaletteBody(
        items: items,
        queryController: queryController,
        query: query,
        onSelected: (item) {
          Get.back<void>();
          onSelected(item);
        },
      ),
    );
  }
}

class _CommandPaletteBody extends StatelessWidget {
  const _CommandPaletteBody({
    required this.items,
    required this.queryController,
    required this.query,
    required this.onSelected,
  });
  final List<CommandPaletteItem> items;
  final TextEditingController queryController;
  final RxString query;
  final ValueChanged<CommandPaletteItem> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: queryController,
          label: '',
          hint: AppLocalizations.of(context).text('search_hint'),
          isRequired: false,
          autofocus: true,
          prefixIcon: const Icon(Icons.search_rounded),
          onChanged: (value) => query.value = value,
        ),
        AppSpacing.vMd,
        Obx(() {
          final term = query.value.trim().toLowerCase();
          final filtered = items
              .where(
                (item) =>
                    term.isEmpty ||
                    item.title.toLowerCase().contains(term) ||
                    item.subtitle.toLowerCase().contains(term) ||
                    item.keywords.any(
                      (word) => word.toLowerCase().contains(term),
                    ),
              )
              .toList(growable: false);
          if (filtered.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Text(
                AppLocalizations.of(context).text('no_results'),
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            );
          }
          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filtered.length,
              separatorBuilder: (_, _) => AppSpacing.vXs,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return CustomButton.text(
                  width: double.infinity,
                  onPressed: () => onSelected(item),
                  child: Row(
                    children: [
                      Icon(item.icon, color: colors.primary),
                      AppSpacing.hMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTypography.titleSmall.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            Text(
                              item.subtitle,
                              style: AppTypography.caption.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.north_west_rounded,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
        AppSpacing.vMd,
        const CustomShortcutHint(keys: ['Ctrl', 'K']),
      ],
    );
  }
}
