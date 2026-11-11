import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformPlanEditorForm extends StatelessWidget {
  const PlatformPlanEditorForm({super.key, required this.controller});

  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final productItems = controller.products
        .map((item) => DropdownItem<int>(
              value: item.id,
              child: Text(item.name + ' · ' + item.key),
            ))
        .toList(growable: false);
    final currencyItems = controller.currencies
        .where((item) => item.isActive)
        .map((item) => DropdownItem<int>(
              value: item.id,
              child: Text(item.code + ' · ' + item.name),
            ))
        .toList(growable: false);

    const intervalLabels = <String, String>{
      'DAY': 'يومي',
      'WEEK': 'أسبوعي',
      'MONTH': 'شهري',
      'YEAR': 'سنوي',
      'ONE_TIME': 'مرة واحدة',
    };
    final intervalItems = intervalLabels.entries
        .map((item) => DropdownItem<String>(
              value: item.key,
              child: Text(item.value),
            ))
        .toList(growable: false);

    const featureLabels = <String, String>{
      'BOOLEAN': 'تشغيل / إيقاف',
      'RESOURCE_LIMIT': 'حد موارد',
      'METERED': 'استهلاك مقاس',
      'TEXT': 'قيمة نصية',
      'JSON': 'إعدادات JSON',
    };
    final featureItems = featureLabels.entries
        .map((item) => DropdownItem<String>(
              value: item.key,
              child: Text(item.value),
            ))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'هوية الخطة',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        CustomDropdown<int>(
          items: productItems,
          valueListenable: controller.selectedProductId,
          onChanged: (value) => controller.selectedProductId.value = value,
          label: 'المنتج',
          hint: controller.products.isEmpty ? 'أنشئ منتجاً أولاً' : 'اختر المنتج',
          searchEnabled: true,
          itemSearchText: (value) => controller.products
              .firstWhere((item) => item.id == value)
              .name,
          isRequired: true,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final fieldWidth = constraints.maxWidth >= 620
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planKeyController,
                    label: 'المعرف البرمجي للخطة',
                    hint: 'starter-monthly',
                    allowSpaces: false,
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planNameController,
                    label: 'اسم الخطة',
                    hint: 'Starter',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller.planDescriptionController,
          label: 'وصف الخطة',
          hint: 'ما الذي تقدمه هذه الخطة؟',
          isRequired: false,
          minLines: 2,
          maxLines: 3,
        ),
        const SizedBox(height: 22),
        Text(
          'السعر الأول للإصدار',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        CustomDropdown<int>(
          items: currencyItems,
          valueListenable: controller.selectedPlanCurrencyId,
          onChanged: (value) => controller.selectedPlanCurrencyId.value = value,
          label: 'عملة السعر',
          hint: 'اختر العملة',
          searchEnabled: true,
          itemSearchText: (value) => controller.currencies
              .firstWhere((item) => item.id == value)
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
            final fieldWidth = constraints.maxWidth >= 620
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planUnitAmountController,
                    label: 'قيمة الاشتراك',
                    hint: '5000.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
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
        const SizedBox(height: 8),
        Text(
          'يُرسل المبلغ كنص عشري إلى Laravel، ويحوّله الخادم إلى وحدات العملة الصغرى وفق دقة العملة. لا يجري التطبيق أي تقريب أو تحويل للعملة.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant, height: 1.45),
        ),
        const SizedBox(height: 22),
        Text(
          'ميزة أولى (اختيارية)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'يمكن ترك هذه الحقول فارغة وإضافة المزايا لاحقاً إلى إصدار المسودة.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final fieldWidth = constraints.maxWidth >= 620
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planFeatureKeyController,
                    label: 'معرف الميزة',
                    hint: 'max_pos_count',
                    isRequired: false,
                    allowSpaces: false,
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planFeatureNameController,
                    label: 'اسم الميزة',
                    hint: 'عدد نقاط البيع',
                    isRequired: false,
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
          isRequired: false,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final fieldWidth = constraints.maxWidth >= 620
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planFeatureValueController,
                    label: 'قيمة الميزة',
                    hint: '-1',
                    isRequired: false,
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: CustomTextField(
                    controller: controller.planFeatureUnitController,
                    label: 'وحدة القياس',
                    hint: 'نقطة بيع / مستخدم / GB',
                    isRequired: false,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'في ميزات RESOURCE_LIMIT وMETERED تعني القيمة -1 غير محدود. أما BOOLEAN فتقبل true أو false. قيمة JSON يجب أن تكون JSON صالحاً.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant, height: 1.45),
        ),
      ],
    );
  }
}
