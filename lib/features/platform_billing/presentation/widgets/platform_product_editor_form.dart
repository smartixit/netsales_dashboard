import 'package:flutter/material.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';

class PlatformProductEditorForm extends StatelessWidget {
  const PlatformProductEditorForm({super.key, required this.controller});

  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'المنتج هو الحاوية التجارية التي تضم خطط NetSales المختلفة. أنشئه مرة واحدة ثم اربط به أكثر من خطة.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 18),
      CustomTextField(
        controller: controller.productKeyController,
        label: 'المعرف البرمجي للمنتج',
        hint: 'netsales-platform',
        isRequired: true,
        allowSpaces: false,
      ),
      const SizedBox(height: 12),
      CustomTextField(
        controller: controller.productNameController,
        label: 'اسم المنتج',
        hint: 'NetSales Platform',
        isRequired: true,
      ),
      const SizedBox(height: 12),
      CustomTextField(
        controller: controller.productDescriptionController,
        label: 'وصف المنتج',
        hint: 'وصف مختصر للمنتج التجاري',
        isRequired: false,
        minLines: 2,
        maxLines: 3,
      ),
    ],
  );
}
