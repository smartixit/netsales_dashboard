import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class CustomFilterBar extends StatelessWidget {
  const CustomFilterBar({
    super.key,
    this.searchController,
    this.searchHint,
    this.clearLabel = 'Clear filters',
    this.onSearchChanged,
    this.filters = const [],
    this.onClear,
    this.dateRangeSelector,
    this.actions = const [],
  });
  final TextEditingController? searchController;
  final String? searchHint;
  final String clearLabel;
  final ValueChanged<String>? onSearchChanged;
  final List<Widget> filters;
  final VoidCallback? onClear;
  final Widget? dateRangeSelector;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (searchController != null)
              SizedBox(
                width: AppBreakpoints.filterSearchWidth,
                child: CustomTextField(
                  controller: searchController!,
                  label: '',
                  hint: searchHint,
                  isRequired: false,
                  prefixIcon: const Icon(Icons.search_rounded),
                  onChanged: onSearchChanged,
                ),
              ),
            ...filters,
            ?dateRangeSelector,
            ?(onClear == null
                ? null
                : CustomButton.text(
                    text: clearLabel,
                    onPressed: onClear,
                    size: AppButtonSize.small,
                    prefix: const Icon(Icons.filter_alt_off_outlined, size: 18),
                  )),
          ],
        ),
        if (actions.isNotEmpty)
          Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: actions),
      ],
    );
  }
}
