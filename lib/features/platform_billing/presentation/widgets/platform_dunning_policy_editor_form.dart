import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_switch_list_tile.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformDunningPolicyEditorForm extends StatelessWidget {
  const PlatformDunningPolicyEditorForm({super.key, required this.controller, this.showIdentityFields = true});

  final PlatformBillingController controller;
  final bool showIdentityFields;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'سياسة التحصيل تحدد مهلة السماح والتنبيهات قبل الإيقاف. تُحفظ كمسودة مستقلة ثم تُنشر وتُربط بالخطة أو السعر.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          if (showIdentityFields) ...[
          CustomTextField(
            controller: controller.dunningPolicyKeyController,
            label: 'المعرف البرمجي',
            hint: 'standard-dunning',
            allowSpaces: false,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller.dunningPolicyNameController,
            label: 'اسم السياسة',
            hint: 'التحصيل القياسي',
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller.dunningPolicyDescriptionController,
            label: 'الوصف',
            hint: 'ملخص طريقة متابعة المتأخرات',
            isRequired: false,
            minLines: 2,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          ],
          CustomTextField(
            controller: controller.dunningGraceDaysController,
            label: 'مهلة السماح بالأيام',
            hint: '7',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: controller.dunningAutoSuspend,
            builder: (context, value, _) => CustomSwitchListTile(
              title: 'إيقاف الاشتراك تلقائياً بعد مهلة السماح',
              subtitle: 'يُنفذ المحرك الإيقاف عند انتهاء المهلة إذا بقيت الفاتورة غير مسددة.',
              value: value,
              onChanged: (next) => controller.dunningAutoSuspend.value = next,
              icon: Icons.pause_circle_outline_rounded,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller.dunningReminderDaysController,
            label: 'أيام التذكير بعد الاستحقاق',
            hint: '0,1,3,7',
            isRequired: true,
          ),
          const SizedBox(height: 6),
          Text(
            'أدخل أرقام الأيام مفصولة بفواصل. اليوم 0 يعني يوم الاستحقاق، وتقبل السياسة حتى 10 مواعيد بين 0 و90 يوماً.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller.dunningPreRenewalDaysController,
            label: 'تنبيهات ما قبل التجديد',
            hint: '3',
            isRequired: true,
          ),
          const SizedBox(height: 6),
          Text(
            'أيام قبل موعد التجديد، مفصولة بفواصل. مثال: 7,3,1.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      );
}
