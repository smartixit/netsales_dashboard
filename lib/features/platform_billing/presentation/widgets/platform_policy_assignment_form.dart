import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class PlatformPolicyAssignmentForm extends StatelessWidget {
  const PlatformPolicyAssignmentForm({
    super.key,
    required this.controller,
  });

  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) {
    final trialItems = controller.trialPolicies
        .where((policy) => policy.currentVersion?.isPublished == true)
        .map((policy) => DropdownItem<int>(
              value: policy.currentVersion!.id,
              child: Text(
                policy.name +
                    ' · v' +
                    policy.currentVersion!.versionNumber.toString(),
              ),
            ))
        .toList(growable: false);
    final dunningItems = controller.dunningPolicies
        .where((policy) => policy.currentVersion?.isPublished == true)
        .map((policy) => DropdownItem<int>(
              value: policy.currentVersion!.id,
              child: Text(
                policy.name +
                    ' · v' +
                    policy.currentVersion!.versionNumber.toString(),
              ),
            ))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'لا يمكن ربط إلا إصدار منشور من كل سياسة. تُنسخ مراجع هذه الإصدارات إلى نسخة الخطة أو السعر، وتبقى شروطها ثابتة.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        CustomDropdown<int>(
          items: trialItems,
          valueListenable: controller.selectedTrialPolicyVersionId,
          onChanged: (value) =>
              controller.selectedTrialPolicyVersionId.value = value,
          label: 'سياسة التجربة',
          hint: trialItems.isEmpty ? 'لا توجد سياسة تجربة منشورة' : 'بدون سياسة تجربة',
          isRequired: false,
          searchEnabled: true,
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: CustomButton.text(
            text: 'إزالة ارتباط سياسة التجربة',
            size: AppButtonSize.small,
            onPressed: () => controller.selectedTrialPolicyVersionId.value = null,
          ),
        ),
        const SizedBox(height: 12),
        CustomDropdown<int>(
          items: dunningItems,
          valueListenable: controller.selectedDunningPolicyVersionId,
          onChanged: (value) =>
              controller.selectedDunningPolicyVersionId.value = value,
          label: 'سياسة التحصيل',
          hint: dunningItems.isEmpty ? 'لا توجد سياسة تحصيل منشورة' : 'بدون سياسة تحصيل',
          isRequired: false,
          searchEnabled: true,
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: CustomButton.text(
            text: 'إزالة ارتباط سياسة التحصيل',
            size: AppButtonSize.small,
            onPressed: () => controller.selectedDunningPolicyVersionId.value = null,
          ),
        ),
      ],
    );
  }
}
