import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_switch_list_tile.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformTrialPolicyEditorForm extends StatelessWidget {
  const PlatformTrialPolicyEditorForm({super.key, required this.controller, this.showIdentityFields = true});

  final PlatformBillingController controller;
  final bool showIdentityFields;

  @override
  Widget build(BuildContext context) {
    const units = <String, String>{
      'HOUR': 'ساعة',
      'DAY': 'يوم',
      'WEEK': 'أسبوع',
      'MONTH': 'شهر',
    };
    const triggers = <String, String>{
      'PURCHASE': 'عند إنشاء الاشتراك',
      'FIRST_ACTIVATION': 'عند أول تفعيل',
    };
    const scopes = <String, String>{
      'NETWORK': 'على مستوى الشبكة',
      'BILLING_ACCOUNT': 'على مستوى حساب الفوترة',
      'PRODUCT': 'على مستوى المنتج',
    };
    const eligibility = <String, String>{
      'ANY': 'جميع الحسابات',
      'NEW_NETWORK': 'شبكة جديدة فقط',
      'NEW_BILLING_ACCOUNT': 'حساب فوترة جديد فقط',
    };
    const endings = <String, String>{
      'CREATE_INVOICE': 'إصدار فاتورة بعد التجربة',
      'EXPIRE': 'إنهاء الاشتراك',
    };
    const entitlements = <String, String>{
      'FULL_PLAN': 'صلاحيات الخطة كاملة',
      'RESTRICTED': 'صلاحيات محددة',
      'NONE': 'بدون صلاحيات تشغيلية',
    };

    List<DropdownItem<String>> items(Map<String, String> values) =>
        values.entries
            .map((entry) => DropdownItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                ))
            .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'سياسة التجربة تُنشأ كمسودة. لن تؤثر على الاشتراكات إلا بعد نشر إصدارها وربطه بإصدار خطة أو سعر.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        if (showIdentityFields) ...[
        CustomTextField(
          controller: controller.trialPolicyKeyController,
          label: 'المعرف البرمجي',
          hint: 'new-customer-trial',
          allowSpaces: false,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller.trialPolicyNameController,
          label: 'اسم السياسة',
          hint: 'تجربة العملاء الجدد',
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller.trialPolicyDescriptionController,
          label: 'الوصف',
          hint: 'متى وكيف يستحق العميل فترة التجربة؟',
          isRequired: false,
          minLines: 2,
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        ],
        ValueListenableBuilder<bool>(
          valueListenable: controller.trialIsEnabled,
          builder: (context, value, _) => CustomSwitchListTile(
            title: 'تفعيل مدة التجربة في هذا الإصدار',
            subtitle: 'يمكن حفظ إصدار معطّل دون حذف السياسة.',
            value: value,
            onChanged: (next) => controller.trialIsEnabled.value = next,
            icon: Icons.hourglass_top_rounded,
          ),
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
                    controller: controller.trialDurationController,
                    label: 'مدة التجربة',
                    hint: '14',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: ValueListenableBuilder<String?>(
                    valueListenable: controller.trialDurationUnit,
                    builder: (context, value, _) => CustomDropdown<String>(
                      items: items(units),
                      valueListenable: controller.trialDurationUnit,
                      onChanged: (next) => controller.trialDurationUnit.value = next,
                      label: 'وحدة المدة',
                      hint: 'اختر الوحدة',
                      searchEnabled: false,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: items(triggers),
          valueListenable: controller.trialStartTrigger,
          onChanged: (value) => controller.trialStartTrigger.value = value,
          label: 'متى تبدأ المدة؟',
          hint: 'اختر وقت البداية',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: items(scopes),
          valueListenable: controller.trialRedemptionScope,
          onChanged: (value) => controller.trialRedemptionScope.value = value,
          label: 'نطاق منع تكرار التجربة',
          hint: 'اختر النطاق',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: items(eligibility),
          valueListenable: controller.trialEligibilityMode,
          onChanged: (value) => controller.trialEligibilityMode.value = value,
          label: 'شروط الاستحقاق',
          hint: 'اختر الشروط',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<bool>(
          valueListenable: controller.trialRequiresApproval,
          builder: (context, value, _) => CustomSwitchListTile(
            title: 'اعتماد يدوي قبل بدء التجربة',
            subtitle: 'ينشأ طلب معلق ويحتاج إلى مراجعة فريق المنصة.',
            value: value,
            onChanged: (next) => controller.trialRequiresApproval.value = next,
            icon: Icons.fact_check_outlined,
          ),
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: items(endings),
          valueListenable: controller.trialEndBehavior,
          onChanged: (value) => controller.trialEndBehavior.value = value,
          label: 'الإجراء عند انتهاء التجربة',
          hint: 'اختر الإجراء',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        CustomDropdown<String>(
          items: items(entitlements),
          valueListenable: controller.trialEntitlementMode,
          onChanged: (value) => controller.trialEntitlementMode.value = value,
          label: 'مستوى الصلاحيات أثناء التجربة',
          hint: 'اختر مستوى الصلاحيات',
          searchEnabled: false,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller.trialEntitlementConfigController,
          label: 'إعدادات الصلاحيات بصيغة JSON (اختياري)',
          hint: '{"max_pos_count":1}',
          isRequired: false,
          minLines: 2,
          maxLines: 4,
        ),
      ],
    );
  }
}
