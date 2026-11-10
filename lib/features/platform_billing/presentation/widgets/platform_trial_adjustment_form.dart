import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformTrialAdjustmentForm extends StatelessWidget {
  const PlatformTrialAdjustmentForm({super.key, required this.controller});

  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) {
    const types = <String, String>{
      'EXTEND': 'تمديد فترة التجربة',
      'SHORTEN': 'تقليص فترة التجربة',
      'END_EARLY': 'إنهاء التجربة فوراً',
    };
    final items = types.entries
        .map((entry) => DropdownItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdown<String>(
          items: items,
          valueListenable: controller.trialAdjustmentType,
          onChanged: (value) => controller.trialAdjustmentType.value = value,
          label: 'نوع التعديل',
          hint: 'اختر الإجراء',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<String?>(
          valueListenable: controller.trialAdjustmentType,
          builder: (context, type, _) => type == 'END_EARLY'
              ? Text(
                  'سيتم إنهاء الاشتراك التجريبي الآن وإلغاء التنبيهات المعلقة المرتبطة به.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        height: 1.45,
                      ),
                )
              : CustomTextField(
                  controller: controller.trialAdjustmentDaysController,
                  label: 'عدد الأيام',
                  hint: '7',
                  keyboardType: TextInputType.number,
                ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller.trialDecisionReasonController,
          label: 'سبب التعديل (إلزامي)',
          hint: 'اكتب مبرراً واضحاً للتعديل',
          minLines: 2,
          maxLines: 4,
        ),
      ],
    );
  }
}
