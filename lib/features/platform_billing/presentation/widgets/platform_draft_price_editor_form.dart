import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformDraftPriceEditorForm extends StatelessWidget {
  const PlatformDraftPriceEditorForm({super.key, required this.controller});

  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) {
    final currencyItems = controller.currencies
        .where((currency) => currency.isActive)
        .map((currency) => DropdownItem<int>(
              value: currency.id,
              child: Text(currency.code + ' · ' + currency.name),
            ))
        .toList(growable: false);

    const intervals = <String, String>{
      'DAY': 'يومي',
      'WEEK': 'أسبوعي',
      'MONTH': 'شهري',
      'YEAR': 'سنوي',
      'ONE_TIME': 'مرة واحدة',
    };
    final intervalItems = intervals.entries
        .map((entry) => DropdownItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'أضف تعرفة مستقلة لهذه العملة. لن يتغير أي سعر آخر في الإصدار.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        CustomDropdown<int>(
          items: currencyItems,
          valueListenable: controller.selectedPlanCurrencyId,
          onChanged: (value) => controller.selectedPlanCurrencyId.value = value,
          label: 'العملة',
          hint: 'اختر العملة',
          searchEnabled: true,
          itemSearchText: (value) => controller.currencies
              .firstWhere((currency) => currency.id == value)
              .code,
          isRequired: true,
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: intervalItems,
          valueListenable: controller.selectedPlanBillingInterval,
          onChanged: (value) => controller.selectedPlanBillingInterval.value = value,
          label: 'دورة الفوترة',
          hint: 'اختر الدورة',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth >= 560
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: width,
                  child: CustomTextField(
                    controller: controller.planUnitAmountController,
                    label: 'قيمة الاشتراك',
                    hint: '5000.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: CustomTextField(
                    controller: controller.planSetupFeeController,
                    label: 'رسوم التفعيل',
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          'يُرفض السعر المكرر لنفس العملة ودورة الفوترة. التحقق النهائي يتم أيضاً في Laravel عند النشر.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}
