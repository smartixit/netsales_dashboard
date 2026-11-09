import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_role_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/create_platform_user_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/get_platform_roles_use_case.dart';
import 'package:netsales_dashboard/features/platform_users/domain/usecases/update_platform_user_use_case.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

class PlatformUserFormController extends GetxController {
  PlatformUserFormController({
    required GetPlatformRolesUseCase getRoles,
    required CreatePlatformUserUseCase createUser,
    required UpdatePlatformUserUseCase updateUser,
  }) : _getRoles = getRoles,
       _createUser = createUser,
       _updateUser = updateUser;

  final GetPlatformRolesUseCase _getRoles;
  final CreatePlatformUserUseCase _createUser;
  final UpdatePlatformUserUseCase _updateUser;

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final roles = <PlatformRoleEntity>[].obs;
  final rolesLoading = false.obs;
  final rolesError = ''.obs;
  final selectedRoleId = RxnInt();
  final twoFactorEnabled = false.obs;
  final isSaving = false.obs;

  final Rxn<PlatformUserDetailEntity> editingDetail =
      Rxn<PlatformUserDetailEntity>();

  late final ValueListenable<int?> selectedRoleListenable =
      _RxIntValueListenable(selectedRoleId);

  int _rolesGeneration = 0;

  bool get isEditing => editingDetail.value != null;

  void prepareForCreate() {
    editingDetail.value = null;
    fullNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    selectedRoleId.value = null;
    twoFactorEnabled.value = false;
    unawaited(loadRoles());
  }

  void prepareForEdit(PlatformUserDetailEntity detail) {
    editingDetail.value = detail;
    fullNameController.text = detail.user.fullName;
    phoneController.text = detail.user.phoneNumber;
    emailController.text = detail.user.email ?? '';
    passwordController.clear();
    selectedRoleId.value = detail.roleId > 0 ? detail.roleId : null;
    twoFactorEnabled.value = detail.twoFactorEnabled;
    unawaited(loadRoles());
  }

  void selectRole(int? roleId) {
    selectedRoleId.value = roleId;
  }

  void toggleTwoFactor() {
    twoFactorEnabled.toggle();
  }

  Future<void> loadRoles() async {
    final generation = ++_rolesGeneration;
    rolesLoading.value = true;
    rolesError.value = '';

    try {
      final result = await _getRoles();
      if (generation != _rolesGeneration) return;

      roles.assignAll(
        result.where((role) => role.isActive && role.id > 0),
      );

      final currentRoleId = selectedRoleId.value;
      if (currentRoleId != null &&
          !roles.any((role) => role.id == currentRoleId)) {
        selectedRoleId.value = null;
      }
    } catch (error) {
      if (generation == _rolesGeneration) {
        rolesError.value = error.toString();
      }
    } finally {
      if (generation == _rolesGeneration) {
        rolesLoading.value = false;
      }
    }
  }

  Future<bool> save() async {
    if (isSaving.value) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    final roleId = selectedRoleId.value;
    if (roleId == null || !roles.any((role) => role.id == roleId)) {
      CustomSnackbar.show(
        title: 'الدور الوظيفي',
        message: 'اختر دوراً نشطاً من أدوار المنصة.',
        type: SnackType.warning,
      );
      return false;
    }

    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    final payload = <String, dynamic>{
      'role_id': roleId,
      'user_full_name': fullName,
      'user_phone_number': phone,
      'user_2fa_enabled': twoFactorEnabled.value,
      if (email.isNotEmpty) 'user_email': email,
      if (password.isNotEmpty) 'user_password': password,
      if (!isEditing) 'status': 'ACTIVE',
    };

    isSaving.value = true;
    try {
      await CustomAnimationOverlay.showLoading(
        message: isEditing ? 'جارٍ تحديث بيانات المستخدم...' : 'جارٍ إنشاء حساب المستخدم...',
      );

      final detail = editingDetail.value;
      if (detail == null) {
        await _createUser(payload);
      } else {
        await _updateUser(detail.user.id, payload);
      }

      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }

      Get.back<bool>(result: true);
      await CustomAnimationOverlay.showSuccess(
        message: isEditing
            ? 'تم تحديث بيانات المستخدم بنجاح.'
            : 'تم إنشاء حساب المستخدم بنجاح.',
      );
      return true;
    } catch (error) {
      CustomSnackbar.show(
        title: isEditing ? 'تعذر تحديث المستخدم' : 'تعذر إنشاء المستخدم',
        message: error.toString(),
        type: SnackType.error,
      );
      return false;
    } finally {
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    _rolesGeneration++;
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class _RxIntValueListenable implements ValueListenable<int?> {
  _RxIntValueListenable(this._source);

  final RxnInt _source;
  final Set<VoidCallback> _listeners = <VoidCallback>{};
  StreamSubscription<int?>? _subscription;

  @override
  int? get value => _source.value;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
    _syncSubscription();
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    _syncSubscription();
  }

  void _syncSubscription() {
    if (_listeners.isNotEmpty && _subscription == null) {
      _subscription = _source.stream.listen((_) {
        for (final listener in List<VoidCallback>.of(_listeners)) {
          listener();
        }
      });
    } else if (_listeners.isEmpty && _subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }
}
