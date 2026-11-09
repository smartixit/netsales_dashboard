import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_breakpoints.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/controllers/platform_user_form_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_dropdown.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_field.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_text_field.dart';
import 'package:netsales_dashboard/widgets/sheets/custom_bottom_sheet.dart';

Future<bool?> showPlatformUserForm({
  required AppLocalizations l10n,
  PlatformUserDetailEntity? detail,
}) async {
  final controller = Get.find<PlatformUserFormController>();
  if (detail == null) {
    controller.prepareForCreate();
  } else {
    controller.prepareForEdit(detail);
  }

  final isEditing = detail != null;
  return CustomBottomSheet.show<bool>(
    title: l10n.text(isEditing ? 'edit_platform_user' : 'create_platform_user'),
    subtitle: l10n.text('platform_user_form_description'),
    leadingIcon: Icons.manage_accounts_rounded,
    maxHeightFactor: 0.9,
    scrollable: true,
    child: PlatformUserFormFields(controller: controller, l10n: l10n),
    actions: [
      Expanded(
        child: CustomButton.outline(
          text: l10n.text('cancel'),
          onPressed: () => Get.back<bool>(),
        ),
      ),
      AppSpacing.hSm,
      Expanded(
        child: Obx(
          () => CustomButton.primary(
            text: l10n.text('save'),
            loading: controller.isSaving.value,
            onPressed: controller.isSaving.value
                ? null
                : () => controller.save(),
          ),
        ),
      ),
    ],
  );
}

class PlatformUserFormFields extends StatelessWidget {
  const PlatformUserFormFields({
    super.key,
    required this.controller,
    required this.l10n,
  });

  final PlatformUserFormController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.rolesLoading.value && controller.roles.isEmpty) {
        return const CustomSkeletonGrid(
          count: 3,
          crossAxisCount: 1,
          itemHeight: 76,
        );
      }

      if (controller.rolesError.value.isNotEmpty &&
          controller.roles.isEmpty) {
        return CustomErrorState.boxed(
          title: l10n.text('platform_roles_load_error'),
          subtitle: controller.rolesError.value,
          icon: Icons.admin_panel_settings_outlined,
          retryLabel: l10n.text('retry'),
          onRetry: controller.loadRoles,
        );
      }

      return Form(
        key: controller.formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useTwoColumns = constraints.maxWidth >= 720;

            final nameField = CustomTextField(
              controller: controller.fullNameController,
              label: l10n.text('full_name'),
              hint: l10n.text('platform_user_name_hint'),
              prefixIcon: const Icon(Icons.person_outline_rounded),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return l10n.text('field_required');
                }
                if (value!.trim().length > 100) {
                  return l10n.text('user_name_too_long');
                }
                return null;
              },
            );

            final phoneField = CustomTextField(
              controller: controller.phoneController,
              label: l10n.text('user_phone'),
              hint: l10n.text('platform_user_phone_hint'),
              prefixIcon: const Icon(Icons.phone_iphone_rounded),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final phone = (value ?? '').trim();
                if (phone.isEmpty) return l10n.text('field_required');
                if (phone.length > 20 ||
                    !RegExp(r'^[0-9+\\-\\s()]+$').hasMatch(phone)) {
                  return l10n.text('invalid_phone_number');
                }
                return null;
              },
            );

            final emailField = CustomTextField(
              controller: controller.emailController,
              label: l10n.text('email_optional'),
              hint: l10n.text('email'),
              prefixIcon: const Icon(Icons.alternate_email_rounded),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              isRequired: false,
              validator: (value) {
                final email = (value ?? '').trim();
                if (email.isNotEmpty &&
                    !RegExp(r'^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$')
                        .hasMatch(email)) {
                  return l10n.text('invalid_email');
                }
                return null;
              },
            );

            final passwordField = CustomPasswordField.newPassword(
              controller: controller.passwordController,
              label: l10n.text(
                controller.isEditing
                    ? 'new_password_optional'
                    : 'initial_password',
              ),
              hint: l10n.text('password_minimum_hint'),
              validator: (value) {
                final password = value ?? '';
                if (!controller.isEditing && password.isEmpty) {
                  return l10n.text('field_required');
                }
                if (password.isNotEmpty && password.length < 8) {
                  return l10n.text('password_minimum_error');
                }
                return null;
              },
            );

            final roleField = CustomDropdown<int>(
              label: l10n.text('platform_role'),
              hint: l10n.text('select_platform_role'),
              prefixIcon: Icons.admin_panel_settings_outlined,
              valueListenable: controller.selectedRoleListenable,
              items: controller.roles
                  .map(
                    (role) => DropdownItem<int>(
                      value: role.id,
                      child: Text(role.name),
                    ),
                  )
                  .toList(growable: false),
              itemSearchText: (id) => controller.roles
                  .firstWhereOrNull((role) => role.id == id)
                  ?.name ?? '',
              onChanged: controller.selectRole,
              isRequired: true,
              validator: (value) => value == null
                  ? l10n.text('select_platform_role')
                  : null,
            );

            final twoFactor = Obx(
              () => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerLow,
                  border: Border.all(
                    color: context.colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: context.colors.primary,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.text('two_factor_authentication')),
                          Text(
                            l10n.text(
                              controller.twoFactorEnabled.value
                                  ? 'two_factor_enabled'
                                  : 'two_factor_disabled',
                            ),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      text: l10n.text(
                        controller.twoFactorEnabled.value ? 'enabled' : 'disabled',
                      ),
                      variant: controller.twoFactorEnabled.value
                          ? AppButtonVariant.secondary
                          : AppButtonVariant.outline,
                      size: AppButtonSize.small,
                      onPressed: controller.toggleTwoFactor,
                    ),
                  ],
                ),
              ),
            );

            Widget pair(Widget first, Widget second) {
              if (!useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    first,
                    SizedBox(height: AppSpacing.md),
                    second,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: first),
                  SizedBox(width: AppSpacing.md),
                  Expanded(child: second),
                ],
              );
            }

            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  pair(nameField, phoneField),
                  SizedBox(height: AppSpacing.md),
                  pair(emailField, roleField),
                  SizedBox(height: AppSpacing.md),
                  passwordField,
                  SizedBox(height: AppSpacing.md),
                  twoFactor,
                  if (controller.isEditing) ...[
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.text('password_change_note'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
