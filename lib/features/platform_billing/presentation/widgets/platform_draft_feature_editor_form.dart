import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformDraftFeatureEditorForm extends StatelessWidget {
  const PlatformDraftFeatureEditorForm({super.key, required this.controller});

  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) {
    const featureTypes = <String, String>{
      'BOOLEAN': 'تشغيل / إيقاف',
      'RESOURCE_LIMIT': 'حد موارد',
      'METERED': 'استهلاك مقاس',
      'TEXT': 'قيمة نصية',
      'JSON': 'إعدادات JSON',
    };
    final featureItems = featureTypes.entries
        .map((entry) => DropdownItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ستُضاف الميزة إلى هذا الإصدار فقط. لا تؤثر إضافة الميزة على إصدار منشور أو اشتراكات سابقة.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
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
                    controller: controller.planFeatureKeyController,
                    label: 'معرف الميزة',
                    hint: 'max_pos_count',
                    allowSpaces: false,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: CustomTextField(
                    controller: controller.planFeatureNameController,
                    label: 'اسم الميزة',
                    hint: 'عدد نقاط البيع',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: featureItems,
          valueListenable: controller.selectedPlanFeatureType,
          onChanged: (value) => controller.selectedPlanFeatureType.value = value,
          label: 'نوع الميزة',
          hint: 'اختر النوع',
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
                    controller: controller.planFeatureValueController,
                    label: 'قيمة الميزة',
                    hint: '-1',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: CustomTextField(
                    controller: controller.planFeatureUnitController,
                    label: 'وحدة القياس',
                    hint: 'مستخدم / نقطة بيع / GB',
                    isRequired: false,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          'RESOURCE_LIMIT وMETERED يقبلان -1 للدلالة على غير محدود. BOOLEAN يقبل true أو false، وJSON يتطلب محتوى صالحاً.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}
