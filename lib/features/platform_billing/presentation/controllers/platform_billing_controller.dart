import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/usecases/platform_billing_use_cases.dart';

class PlatformBillingController extends GetxController {
  PlatformBillingController({
    required GetBillingOverviewUseCase getOverview,
    required GetBillingCurrenciesUseCase getCurrencies,
    required GetBillingPlansUseCase getPlans,
    required GetBillingProductsUseCase getProducts,
    required CreateBillingProductUseCase createProduct,
    required CreateBillingPlanUseCase createPlan,
    required CreateBillingDraftVersionUseCase createDraftVersion,
    required AddBillingPlanPriceUseCase addPlanPrice,
    required AddBillingPlanFeatureUseCase addPlanFeature,
    required PublishBillingPlanVersionUseCase publishPlanVersion,
    required GetBillingPlanVersionsUseCase getPlanVersions,
    required GetBillingTrialPoliciesUseCase getTrialPolicies,
    required GetBillingTrialPolicyVersionsUseCase getTrialPolicyVersions,
    required GetBillingDunningPoliciesUseCase getDunningPolicies,
    required GetBillingDunningPolicyVersionsUseCase getDunningPolicyVersions,
    required GetBillingPendingTrialRedemptionsUseCase getPendingTrialRedemptions,
    required CreateBillingTrialPolicyUseCase createTrialPolicy,
    required CreateBillingDunningPolicyUseCase createDunningPolicy,
    required CreateBillingTrialPolicyVersionUseCase createTrialPolicyVersion,
    required CreateBillingDunningPolicyVersionUseCase createDunningPolicyVersion,
    required PublishBillingTrialPolicyVersionUseCase publishTrialPolicyVersion,
    required PublishBillingDunningPolicyVersionUseCase publishDunningPolicyVersion,
    required AssignBillingPlanPoliciesUseCase assignPlanPolicies,
    required AssignBillingPricePoliciesUseCase assignPricePolicies,
    required ApproveBillingTrialRedemptionUseCase approveTrialRedemption,
    required RejectBillingTrialRedemptionUseCase rejectTrialRedemption,
    required AdjustBillingSubscriptionTrialUseCase adjustSubscriptionTrial,
    required GetBillingSubscriptionsUseCase getSubscriptions,
    required GetBillingInvoicesUseCase getInvoices,
    required GetBillingPaymentsUseCase getPayments,
    required GetBillingTreasuryAccountsUseCase getTreasuryAccounts,
  }) : _getOverview = getOverview,
       _getCurrencies = getCurrencies,
       _getPlans = getPlans,
       _getProducts = getProducts,
       _createProduct = createProduct,
       _createPlan = createPlan,
       _createDraftVersion = createDraftVersion,
       _addPlanPrice = addPlanPrice,
       _addPlanFeature = addPlanFeature,
       _publishPlanVersion = publishPlanVersion,
       _getPlanVersions = getPlanVersions,
       _getTrialPolicies = getTrialPolicies,
       _getTrialPolicyVersions = getTrialPolicyVersions,
       _getDunningPolicies = getDunningPolicies,
       _getDunningPolicyVersions = getDunningPolicyVersions,
       _getPendingTrialRedemptions = getPendingTrialRedemptions,
       _createTrialPolicy = createTrialPolicy,
       _createDunningPolicy = createDunningPolicy,
       _createTrialPolicyVersion = createTrialPolicyVersion,
       _createDunningPolicyVersion = createDunningPolicyVersion,
       _publishTrialPolicyVersion = publishTrialPolicyVersion,
       _publishDunningPolicyVersion = publishDunningPolicyVersion,
       _assignPlanPolicies = assignPlanPolicies,
       _assignPricePolicies = assignPricePolicies,
       _approveTrialRedemption = approveTrialRedemption,
       _rejectTrialRedemption = rejectTrialRedemption,
       _adjustSubscriptionTrial = adjustSubscriptionTrial,
       _getSubscriptions = getSubscriptions,
       _getInvoices = getInvoices,
       _getPayments = getPayments,
       _getTreasuryAccounts = getTreasuryAccounts;

  final GetBillingOverviewUseCase _getOverview;
  final GetBillingCurrenciesUseCase _getCurrencies;
  final GetBillingPlansUseCase _getPlans;
  final GetBillingProductsUseCase _getProducts;
  final CreateBillingProductUseCase _createProduct;
  final CreateBillingPlanUseCase _createPlan;
  final CreateBillingDraftVersionUseCase _createDraftVersion;
  final AddBillingPlanPriceUseCase _addPlanPrice;
  final AddBillingPlanFeatureUseCase _addPlanFeature;
  final PublishBillingPlanVersionUseCase _publishPlanVersion;
  final GetBillingPlanVersionsUseCase _getPlanVersions;
  final GetBillingTrialPoliciesUseCase _getTrialPolicies;
  final GetBillingTrialPolicyVersionsUseCase _getTrialPolicyVersions;
  final GetBillingDunningPoliciesUseCase _getDunningPolicies;
  final GetBillingDunningPolicyVersionsUseCase _getDunningPolicyVersions;
  final GetBillingPendingTrialRedemptionsUseCase _getPendingTrialRedemptions;
  final CreateBillingTrialPolicyUseCase _createTrialPolicy;
  final CreateBillingDunningPolicyUseCase _createDunningPolicy;
  final CreateBillingTrialPolicyVersionUseCase _createTrialPolicyVersion;
  final CreateBillingDunningPolicyVersionUseCase _createDunningPolicyVersion;
  final PublishBillingTrialPolicyVersionUseCase _publishTrialPolicyVersion;
  final PublishBillingDunningPolicyVersionUseCase _publishDunningPolicyVersion;
  final AssignBillingPlanPoliciesUseCase _assignPlanPolicies;
  final AssignBillingPricePoliciesUseCase _assignPricePolicies;
  final ApproveBillingTrialRedemptionUseCase _approveTrialRedemption;
  final RejectBillingTrialRedemptionUseCase _rejectTrialRedemption;
  final AdjustBillingSubscriptionTrialUseCase _adjustSubscriptionTrial;
  final GetBillingSubscriptionsUseCase _getSubscriptions;
  final GetBillingInvoicesUseCase _getInvoices;
  final GetBillingPaymentsUseCase _getPayments;
  final GetBillingTreasuryAccountsUseCase _getTreasuryAccounts;

  final overview = Rxn<BillingOverviewEntity>();
  final currencies = <BillingCurrencyEntity>[].obs;
  final plans = <BillingPlanEntity>[].obs;
  final products = <BillingProductEntity>[].obs;
  final trialPolicies = <BillingTrialPolicyEntity>[].obs;
  final dunningPolicies = <BillingDunningPolicyEntity>[].obs;
  final trialPolicyVersions = <int, List<BillingTrialPolicyVersionEntity>>{}.obs;
  final dunningPolicyVersions = <int, List<BillingDunningPolicyVersionEntity>>{}.obs;
  final pendingTrialRedemptions = <BillingTrialRedemptionEntity>[].obs;
  final isTrialPoliciesLoading = false.obs;
  final isDunningPoliciesLoading = false.obs;
  final isPendingRedemptionsLoading = false.obs;
  final isPolicyMutationInProgress = false.obs;
  final isTrialPolicyVersionsLoading = <int>{}.obs;
  final isDunningPolicyVersionsLoading = <int>{}.obs;

  final trialPolicyKeyController = TextEditingController();
  final trialPolicyNameController = TextEditingController();
  final trialPolicyDescriptionController = TextEditingController();
  final trialDurationController = TextEditingController(text: '14');
  final trialEntitlementConfigController = TextEditingController();
  final dunningPolicyKeyController = TextEditingController();
  final dunningPolicyNameController = TextEditingController();
  final dunningPolicyDescriptionController = TextEditingController();
  final dunningGraceDaysController = TextEditingController(text: '7');
  final dunningReminderDaysController = TextEditingController(text: '0,1,3,7');
  final dunningPreRenewalDaysController = TextEditingController(text: '3');
  final trialDurationUnit = ValueNotifier<String?>('DAY');
  final trialStartTrigger = ValueNotifier<String?>('PURCHASE');
  final trialRedemptionScope = ValueNotifier<String?>('BILLING_ACCOUNT');
  final trialEligibilityMode = ValueNotifier<String?>('NEW_BILLING_ACCOUNT');
  final trialRequiresApproval = ValueNotifier<bool>(false);
  final trialIsEnabled = ValueNotifier<bool>(true);
  final trialEndBehavior = ValueNotifier<String?>('CREATE_INVOICE');
  final trialEntitlementMode = ValueNotifier<String?>('FULL_PLAN');
  final dunningAutoSuspend = ValueNotifier<bool>(true);
  final selectedTrialPolicyVersionId = ValueNotifier<int?>(null);
  final selectedDunningPolicyVersionId = ValueNotifier<int?>(null);

  String? _trialPoliciesCursor;
  String? _dunningPoliciesCursor;
  String? _pendingRedemptionsCursor;
  int _trialPoliciesRequest = 0;
  int _dunningPoliciesRequest = 0;
  int _pendingRedemptionsRequest = 0;
  bool get canLoadMoreTrialPolicies => _trialPoliciesCursor != null && !isTrialPoliciesLoading.value;
  bool get canLoadMoreDunningPolicies => _dunningPoliciesCursor != null && !isDunningPoliciesLoading.value;
  bool get canLoadMorePendingRedemptions => _pendingRedemptionsCursor != null && !isPendingRedemptionsLoading.value;

  final planVersions = <int, List<BillingPlanVersionEntity>>{}.obs;
  final loadingPlanVersions = <int>{}.obs;
  final subscriptions = <BillingSubscriptionEntity>[].obs;
  final invoices = <BillingInvoiceEntity>[].obs;
  final payments = <BillingPaymentEntity>[].obs;
  final treasuryAccounts = <BillingTreasuryAccountEntity>[].obs;

  final isOverviewLoading = false.obs;
  final isCurrenciesLoading = false.obs;
  final isPlansLoading = false.obs;
  final isProductsLoading = false.obs;
  final isPlanMutationInProgress = false.obs;
  final isPlanPublishInProgress = false.obs;
  final lastCreatedPlanId = RxnInt();
  final lastCreatedDraftVersionId = RxnInt();
  final isSubscriptionsLoading = false.obs;
  final isInvoicesLoading = false.obs;
  final isPaymentsLoading = false.obs;
  final isTreasuryLoading = false.obs;

  final isSubscriptionsLoadingMore = false.obs;
  final isInvoicesLoadingMore = false.obs;
  final isPaymentsLoadingMore = false.obs;

  final subscriptionsError = RxnString();
  final invoicesError = RxnString();
  final paymentsError = RxnString();


  // All plan-editor state is owned by this GetX controller.
  final productKeyController = TextEditingController();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final planKeyController = TextEditingController();
  final planNameController = TextEditingController();
  final planDescriptionController = TextEditingController();
  final planUnitAmountController = TextEditingController();
  final planSetupFeeController = TextEditingController(text: '0');
  final planFeatureKeyController = TextEditingController();
  final planFeatureNameController = TextEditingController();
  final planFeatureValueController = TextEditingController(text: '-1');
  final planFeatureUnitController = TextEditingController();
  final selectedProductId = ValueNotifier<int?>(null);
  final selectedPlanCurrencyId = ValueNotifier<int?>(null);
  final selectedPlanBillingInterval = ValueNotifier<String?>('MONTH');
  final selectedPlanFeatureType = ValueNotifier<String?>('RESOURCE_LIMIT');

  int? _pendingPlanId;
  int? _pendingDraftVersionId;
  bool _pendingPriceAdded = false;
  bool _pendingFeatureAdded = false;
  Map<String, dynamic>? _pendingPlanPayload;
  Map<String, dynamic>? _pendingPricePayload;
  Map<String, dynamic>? _pendingFeaturePayload;

  bool get hasPendingPlanWorkflow => lastCreatedPlanId.value != null || lastCreatedDraftVersionId.value != null;

  final selectedCurrencyId = RxnInt();
  final subscriptionStatusFilter = RxnString();
  final invoiceStatusFilter = RxnString();
  final paymentStatusFilter = RxnString();
  final searchQuery = ''.obs;

  String? _subscriptionsCursor;
  String? _invoicesCursor;
  String? _paymentsCursor;
  int _subscriptionsRequest = 0;
  int _invoicesRequest = 0;
  int _paymentsRequest = 0;

  bool get canLoadMoreSubscriptions => _subscriptionsCursor != null && !isSubscriptionsLoadingMore.value;
  bool get canLoadMoreInvoices => _invoicesCursor != null && !isInvoicesLoadingMore.value;
  bool get canLoadMorePayments => _paymentsCursor != null && !isPaymentsLoadingMore.value;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    await Future.wait([
      loadOverview(),
      loadCurrencies(),
      loadPlans(),
      loadProducts(),
      loadTrialPolicies(reset: true),
      loadDunningPolicies(reset: true),
      loadPendingTrialRedemptions(reset: true),
      loadSubscriptions(reset: true),
      loadInvoices(reset: true),
      loadPayments(reset: true),
      loadTreasuryAccounts(),
    ]);
  }

  Future<void> loadOverview() async {
    isOverviewLoading.value = true;
    try {
      final response = await _getOverview(currencyId: selectedCurrencyId.value);
      if (response.success) overview.value = response.data;
    } finally {
      isOverviewLoading.value = false;
    }
  }

  Future<void> loadCurrencies() async {
    isCurrenciesLoading.value = true;
    try {
      final response = await _getCurrencies();
      if (response.success) {
        currencies.assignAll(response.data ?? const []);
        if (selectedPlanCurrencyId.value == null) {
          for (final currency in currencies) {
            if (currency.isActive) {
              selectedPlanCurrencyId.value = currency.id;
              break;
            }
          }
        }
      }
    } finally {
      isCurrenciesLoading.value = false;
    }
  }

  Future<void> loadPlans() async {
    isPlansLoading.value = true;
    try {
      final response = await _getPlans(perPage: 30);
      if (response.success) plans.assignAll(response.data ?? const []);
    } finally {
      isPlansLoading.value = false;
    }
  }

  Future<void> loadProducts() async {
    isProductsLoading.value = true;
    try {
      final response = await _getProducts(perPage: 100);
      if (response.success) {
        products.assignAll(response.data ?? const []);
        if (selectedProductId.value == null && products.isNotEmpty) {
          selectedProductId.value = products.first.id;
        }
      }
    } finally {
      isProductsLoading.value = false;
    }
  }

  Future<void> loadPlanVersions(int planId) async {
    if (loadingPlanVersions.contains(planId)) return;
    loadingPlanVersions.add(planId);
    loadingPlanVersions.refresh();
    try {
      final response = await _getPlanVersions(planId, perPage: 30);
      if (response.success) {
        planVersions[planId] = response.data ?? const [];
        planVersions.refresh();
      }
    } finally {
      loadingPlanVersions.remove(planId);
      loadingPlanVersions.refresh();
    }
  }

  Future<void> loadTrialPolicies({bool reset = false}) async {
    if (reset) {
      _trialPoliciesCursor = null;
      trialPolicies.clear();
    } else if (!canLoadMoreTrialPolicies) {
      return;
    }
    isTrialPoliciesLoading.value = true;
    try {
      final response = await _getTrialPolicies(
        cursor: reset ? null : _trialPoliciesCursor,
        perPage: 100,
      );
      if (response.success) {
        if (reset) {
          trialPolicies.assignAll(response.data ?? const []);
        } else {
          trialPolicies.addAll(response.data ?? const []);
        }
        _trialPoliciesCursor = response.nextCursor;
      }
    } finally {
      isTrialPoliciesLoading.value = false;
    }
  }

  Future<void> loadDunningPolicies({bool reset = false}) async {
    if (reset) {
      _dunningPoliciesCursor = null;
      dunningPolicies.clear();
    } else if (!canLoadMoreDunningPolicies) {
      return;
    }
    isDunningPoliciesLoading.value = true;
    try {
      final response = await _getDunningPolicies(
        cursor: reset ? null : _dunningPoliciesCursor,
        perPage: 100,
      );
      if (response.success) {
        if (reset) {
          dunningPolicies.assignAll(response.data ?? const []);
        } else {
          dunningPolicies.addAll(response.data ?? const []);
        }
        _dunningPoliciesCursor = response.nextCursor;
      }
    } finally {
      isDunningPoliciesLoading.value = false;
    }
  }

  Future<void> loadTrialPolicyVersions(int policyId) async {
    if (isTrialPolicyVersionsLoading.contains(policyId)) return;
    isTrialPolicyVersionsLoading.add(policyId);
    isTrialPolicyVersionsLoading.refresh();
    try {
      final response = await _getTrialPolicyVersions(policyId, perPage: 100);
      if (response.success) {
        trialPolicyVersions[policyId] = response.data ?? const [];
        trialPolicyVersions.refresh();
      }
    } finally {
      isTrialPolicyVersionsLoading.remove(policyId);
      isTrialPolicyVersionsLoading.refresh();
    }
  }

  Future<void> loadDunningPolicyVersions(int policyId) async {
    if (isDunningPolicyVersionsLoading.contains(policyId)) return;
    isDunningPolicyVersionsLoading.add(policyId);
    isDunningPolicyVersionsLoading.refresh();
    try {
      final response = await _getDunningPolicyVersions(policyId, perPage: 100);
      if (response.success) {
        dunningPolicyVersions[policyId] = response.data ?? const [];
        dunningPolicyVersions.refresh();
      }
    } finally {
      isDunningPolicyVersionsLoading.remove(policyId);
      isDunningPolicyVersionsLoading.refresh();
    }
  }

  Future<void> loadPendingTrialRedemptions({bool reset = false}) async {
    if (reset) {
      _pendingRedemptionsCursor = null;
      pendingTrialRedemptions.clear();
    } else if (!canLoadMorePendingRedemptions) {
      return;
    }
    isPendingRedemptionsLoading.value = true;
    try {
      final response = await _getPendingTrialRedemptions(
        cursor: reset ? null : _pendingRedemptionsCursor,
        perPage: 50,
      );
      if (response.success) {
        if (reset) {
          pendingTrialRedemptions.assignAll(response.data ?? const []);
        } else {
          pendingTrialRedemptions.addAll(response.data ?? const []);
        }
        _pendingRedemptionsCursor = response.nextCursor;
      }
    } finally {
      isPendingRedemptionsLoading.value = false;
    }
  }

  Future<bool> _runPolicyMutation({
    required String loadingMessage,
    required String successMessage,
    required Future<void> Function() action,
  }) async {
    isPolicyMutationInProgress.value = true;
    var succeeded = false;
    try {
      await CustomAnimationOverlay.showLoading(message: loadingMessage);
      await action();
      succeeded = true;
    } catch (error) {
      CustomSnackbar.show(
        title: 'تعذر تنفيذ العملية',
        message: error.toString(),
        type: SnackType.error,
      );
    } finally {
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
      isPolicyMutationInProgress.value = false;
    }
    if (succeeded) {
      await CustomAnimationOverlay.showSuccess(message: successMessage);
    }
    return succeeded;
  }

  List<int>? _parsePolicyDays(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return <int>[];
    final parts = value.split(',');
    final days = <int>[];
    for (final part in parts) {
      final day = int.tryParse(part.trim());
      if (day == null || day < 0 || day > 90) return null;
      days.add(day);
    }
    return days.toSet().toList()..sort();
  }

  Map<String, dynamic>? _trialPolicyPayload() {
    final duration = int.tryParse(trialDurationController.text.trim());
    final unit = trialDurationUnit.value;
    final trigger = trialStartTrigger.value;
    final scope = trialRedemptionScope.value;
    final eligibility = trialEligibilityMode.value;
    final endBehavior = trialEndBehavior.value;
    final entitlementMode = trialEntitlementMode.value;
    if (duration == null || duration < 0 || duration > 3650 ||
        unit == null || trigger == null || scope == null ||
        eligibility == null || endBehavior == null || entitlementMode == null) {
      CustomSnackbar.show(
        title: 'إعدادات التجربة غير صالحة',
        message: 'تحقق من مدة التجربة ووحدتها ومحفز البداية ونطاق الاستحقاق.',
        type: SnackType.warning,
      );
      return null;
    }
    final configText = trialEntitlementConfigController.text.trim();
    Map<String, dynamic>? config;
    if (configText.isNotEmpty) {
      try {
        final decoded = jsonDecode(configText);
        if (decoded is! Map) throw const FormatException('Expected a JSON object.');
        config = Map<String, dynamic>.from(decoded);
      } catch (_) {
        CustomSnackbar.show(
          title: 'إعدادات الاستحقاق غير صالحة',
          message: 'يجب أن تكون إعدادات الاستحقاق كائن JSON صالحاً.',
          type: SnackType.warning,
        );
        return null;
      }
    }
    return {
      'is_enabled': trialIsEnabled.value,
      'duration_value': duration,
      'duration_unit': unit,
      'start_trigger': trigger,
      'redemption_scope': scope,
      'eligibility_mode': eligibility,
      'requires_manual_approval': trialRequiresApproval.value,
      'end_behavior': endBehavior,
      'entitlement_mode': entitlementMode,
      if (config != null) 'entitlement_config': config,
    };
  }

  Map<String, dynamic>? _dunningPolicyPayload() {
    final grace = int.tryParse(dunningGraceDaysController.text.trim());
    final reminders = _parsePolicyDays(dunningReminderDaysController.text);
    final preRenewal = _parsePolicyDays(dunningPreRenewalDaysController.text);
    if (grace == null || grace < 0 || grace > 90 || reminders == null || preRenewal == null) {
      CustomSnackbar.show(
        title: 'إعدادات التحصيل غير صالحة',
        message: 'أدخل فترة سماح من 0 إلى 90 يوماً، وأيام تذكير صحيحة مفصولة بفواصل.',
        type: SnackType.warning,
      );
      return null;
    }
    return {
      'grace_period_days': grace,
      'auto_suspend_after_grace': dunningAutoSuspend.value,
      'reminder_schedule_days': reminders,
      'pre_renewal_alert_days': preRenewal,
    };
  }

  Future<bool> createTrialPolicy() async {
    final key = trialPolicyKeyController.text.trim();
    final name = trialPolicyNameController.text.trim();
    final values = _trialPolicyPayload();
    if (key.isEmpty || name.isEmpty || values == null) {
      if (key.isEmpty || name.isEmpty) {
        CustomSnackbar.show(
          title: 'بيانات السياسة ناقصة',
          message: 'أدخل معرف سياسة التجربة واسمها.',
          type: SnackType.warning,
        );
      }
      return false;
    }
    return _runPolicyMutation(
      loadingMessage: 'إنشاء سياسة التجربة كمسودة...',
      successMessage: 'تم إنشاء سياسة التجربة وإصدارها الأول كمسودة.',
      action: () async {
        final response = await _createTrialPolicy({
          'policy_key': key,
          'name': name,
          if (trialPolicyDescriptionController.text.trim().isNotEmpty)
            'description': trialPolicyDescriptionController.text.trim(),
          ...values,
        });
        _requireSuccessful(response, 'تعذر إنشاء سياسة التجربة.');
        await loadTrialPolicies(reset: true);
        final policyId = _int(response.data!['trial_policy_id']);
        if (policyId > 0) await loadTrialPolicyVersions(policyId);
        trialPolicyKeyController.clear();
        trialPolicyNameController.clear();
        trialPolicyDescriptionController.clear();
      },
    );
  }

  Future<bool> createTrialPolicyVersion(int policyId) async {
    final values = _trialPolicyPayload();
    if (values == null) return false;
    return _runPolicyMutation(
      loadingMessage: 'إنشاء إصدار سياسة التجربة...',
      successMessage: 'تم إنشاء إصدار مسودة جديد لسياسة التجربة.',
      action: () async {
        final response = await _createTrialPolicyVersion(policyId, values);
        _requireSuccessful(response, 'تعذر إنشاء إصدار سياسة التجربة.');
        await loadTrialPolicyVersions(policyId);
        await loadTrialPolicies(reset: true);
      },
    );
  }

  Future<bool> createDunningPolicy() async {
    final key = dunningPolicyKeyController.text.trim();
    final name = dunningPolicyNameController.text.trim();
    final values = _dunningPolicyPayload();
    if (key.isEmpty || name.isEmpty || values == null) {
      if (key.isEmpty || name.isEmpty) {
        CustomSnackbar.show(
          title: 'بيانات السياسة ناقصة',
          message: 'أدخل معرف سياسة التحصيل واسمها.',
          type: SnackType.warning,
        );
      }
      return false;
    }
    return _runPolicyMutation(
      loadingMessage: 'إنشاء سياسة التحصيل كمسودة...',
      successMessage: 'تم إنشاء سياسة التحصيل وإصدارها الأول كمسودة.',
      action: () async {
        final response = await _createDunningPolicy({
          'policy_key': key,
          'name': name,
          if (dunningPolicyDescriptionController.text.trim().isNotEmpty)
            'description': dunningPolicyDescriptionController.text.trim(),
          ...values,
        });
        _requireSuccessful(response, 'تعذر إنشاء سياسة التحصيل.');
        await loadDunningPolicies(reset: true);
        final policyId = _int(response.data!['dunning_policy_id']);
        if (policyId > 0) await loadDunningPolicyVersions(policyId);
        dunningPolicyKeyController.clear();
        dunningPolicyNameController.clear();
        dunningPolicyDescriptionController.clear();
      },
    );
  }

  Future<bool> createDunningPolicyVersion(int policyId) async {
    final values = _dunningPolicyPayload();
    if (values == null) return false;
    return _runPolicyMutation(
      loadingMessage: 'إنشاء إصدار سياسة التحصيل...',
      successMessage: 'تم إنشاء إصدار مسودة جديد لسياسة التحصيل.',
      action: () async {
        final response = await _createDunningPolicyVersion(policyId, values);
        _requireSuccessful(response, 'تعذر إنشاء إصدار سياسة التحصيل.');
        await loadDunningPolicyVersions(policyId);
        await loadDunningPolicies(reset: true);
      },
    );
  }

  Future<bool> publishTrialPolicyVersion(int policyId, int versionId) async =>
      _runPolicyMutation(
        loadingMessage: 'نشر إصدار سياسة التجربة...',
        successMessage: 'تم نشر إصدار سياسة التجربة.',
        action: () async {
          final response = await _publishTrialPolicyVersion(versionId);
          _requireSuccessful(response, 'تعذر نشر سياسة التجربة.');
          await loadTrialPolicyVersions(policyId);
          await loadTrialPolicies(reset: true);
        },
      );

  Future<bool> publishDunningPolicyVersion(int policyId, int versionId) async =>
      _runPolicyMutation(
        loadingMessage: 'نشر إصدار سياسة التحصيل...',
        successMessage: 'تم نشر إصدار سياسة التحصيل.',
        action: () async {
          final response = await _publishDunningPolicyVersion(versionId);
          _requireSuccessful(response, 'تعذر نشر سياسة التحصيل.');
          await loadDunningPolicyVersions(policyId);
          await loadDunningPolicies(reset: true);
        },
      );

  Future<bool> assignPoliciesToPlanVersion(
    int planId,
    int versionId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) async {
    return _runPolicyMutation(
      loadingMessage: 'ربط سياسات الإصدار...',
      successMessage: 'تم ربط السياسات بإصدار الخطة.',
      action: () async {
        final response = await _assignPlanPolicies(
          versionId,
          trialPolicyVersionId: trialPolicyVersionId,
          dunningPolicyVersionId: dunningPolicyVersionId,
        );
        _requireSuccessful(response, 'تعذر ربط السياسات بإصدار الخطة.');
        await loadPlanVersions(planId);
      },
    );
  }

  Future<bool> assignPoliciesToPrice(
    int planId,
    int versionId,
    int priceId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) async {
    return _runPolicyMutation(
      loadingMessage: 'ربط السياسات بالسعر...',
      successMessage: 'تم ربط السياسات بالسعر.',
      action: () async {
        final response = await _assignPricePolicies(
          priceId,
          trialPolicyVersionId: trialPolicyVersionId,
          dunningPolicyVersionId: dunningPolicyVersionId,
        );
        _requireSuccessful(response, 'تعذر ربط السياسات بالسعر.');
        await loadPlanVersions(planId);
      },
    );
  }

  Future<bool> approveTrialRedemption(int redemptionId) async =>
      _runPolicyMutation(
        loadingMessage: 'اعتماد طلب التجربة...',
        successMessage: 'تم اعتماد طلب التجربة.',
        action: () async {
          final response = await _approveTrialRedemption(redemptionId);
          _requireSuccessful(response, 'تعذر اعتماد طلب التجربة.');
          await loadPendingTrialRedemptions(reset: true);
          await loadSubscriptions(reset: true);
        },
      );

  Future<bool> rejectTrialRedemption(int redemptionId, String reason) async {
    final value = reason.trim();
    if (value.length < 5) {
      CustomSnackbar.show(
        title: 'سبب الرفض مطلوب',
        message: 'اكتب سبباً لا يقل عن خمسة أحرف.',
        type: SnackType.warning,
      );
      return false;
    }
    return _runPolicyMutation(
      loadingMessage: 'رفض طلب التجربة...',
      successMessage: 'تم رفض طلب التجربة وتسجيل السبب.',
      action: () async {
        final response = await _rejectTrialRedemption(redemptionId, reason: value);
        _requireSuccessful(response, 'تعذر رفض طلب التجربة.');
        await loadPendingTrialRedemptions(reset: true);
        await loadSubscriptions(reset: true);
      },
    );
  }

  Future<bool> adjustSubscriptionTrial({
    required int subscriptionId,
    required String adjustmentType,
    int? days,
    required String reason,
  }) async {
    final value = reason.trim();
    if (value.length < 5 ||
        (adjustmentType != 'END_EARLY' && (days == null || days < 1 || days > 365))) {
      CustomSnackbar.show(
        title: 'بيانات تعديل التجربة غير مكتملة',
        message: 'حدد نوع التعديل وعدد الأيام الصحيح واكتب سبباً لا يقل عن خمسة أحرف.',
        type: SnackType.warning,
      );
      return false;
    }
    return _runPolicyMutation(
      loadingMessage: 'تعديل فترة التجربة...',
      successMessage: 'تم تعديل فترة التجربة وتسجيله في سجل التدقيق.',
      action: () async {
        final response = await _adjustSubscriptionTrial(
          subscriptionId,
          adjustmentType: adjustmentType,
          days: days,
          reason: value,
        );
        _requireSuccessful(response, 'تعذر تعديل فترة التجربة.');
        await loadSubscriptions(reset: true);
      },
    );
  }

  Future<void> loadSubscriptions({bool reset = false, String? status}) async {
    if (reset) {
      _subscriptionsCursor = null;
      subscriptions.clear();
      subscriptionsError.value = null;
      isSubscriptionsLoading.value = true;
    } else {
      if (!canLoadMoreSubscriptions) return;
      isSubscriptionsLoadingMore.value = true;
    }
    final requestId = ++_subscriptionsRequest;
    try {
      final response = await _getSubscriptions(
        currencyId: selectedCurrencyId.value,
        status: status ?? subscriptionStatusFilter.value,
        search: searchQuery.value.trim(),
        cursor: reset ? null : _subscriptionsCursor,
        perPage: 25,
      );
      if (requestId != _subscriptionsRequest) return;
      if (!response.success) {
        subscriptionsError.value = response.message;
        return;
      }
      if (reset) {
        subscriptions.assignAll(response.data ?? const []);
      } else {
        subscriptions.addAll(response.data ?? const []);
      }
      _subscriptionsCursor = response.nextCursor;
    } catch (error) {
      if (requestId == _subscriptionsRequest) subscriptionsError.value = error.toString();
    } finally {
      if (requestId == _subscriptionsRequest) {
        isSubscriptionsLoading.value = false;
        isSubscriptionsLoadingMore.value = false;
      }
    }
  }

  Future<void> loadInvoices({bool reset = false}) async {
    if (reset) {
      _invoicesCursor = null;
      invoices.clear();
      invoicesError.value = null;
      isInvoicesLoading.value = true;
    } else {
      if (!canLoadMoreInvoices) return;
      isInvoicesLoadingMore.value = true;
    }
    final requestId = ++_invoicesRequest;
    try {
      final response = await _getInvoices(
        currencyId: selectedCurrencyId.value,
        status: invoiceStatusFilter.value,
        search: searchQuery.value.trim(),
        cursor: reset ? null : _invoicesCursor,
        perPage: 25,
      );
      if (requestId != _invoicesRequest) return;
      if (!response.success) {
        invoicesError.value = response.message;
        return;
      }
      if (reset) {
        invoices.assignAll(response.data ?? const []);
      } else {
        invoices.addAll(response.data ?? const []);
      }
      _invoicesCursor = response.nextCursor;
    } catch (error) {
      if (requestId == _invoicesRequest) invoicesError.value = error.toString();
    } finally {
      if (requestId == _invoicesRequest) {
        isInvoicesLoading.value = false;
        isInvoicesLoadingMore.value = false;
      }
    }
  }

  Future<void> loadPayments({bool reset = false}) async {
    if (reset) {
      _paymentsCursor = null;
      payments.clear();
      paymentsError.value = null;
      isPaymentsLoading.value = true;
    } else {
      if (!canLoadMorePayments) return;
      isPaymentsLoadingMore.value = true;
    }
    final requestId = ++_paymentsRequest;
    try {
      final response = await _getPayments(
        currencyId: selectedCurrencyId.value,
        status: paymentStatusFilter.value,
        search: searchQuery.value.trim(),
        cursor: reset ? null : _paymentsCursor,
        perPage: 25,
      );
      if (requestId != _paymentsRequest) return;
      if (!response.success) {
        paymentsError.value = response.message;
        return;
      }
      if (reset) {
        payments.assignAll(response.data ?? const []);
      } else {
        payments.addAll(response.data ?? const []);
      }
      _paymentsCursor = response.nextCursor;
    } catch (error) {
      if (requestId == _paymentsRequest) paymentsError.value = error.toString();
    } finally {
      if (requestId == _paymentsRequest) {
        isPaymentsLoading.value = false;
        isPaymentsLoadingMore.value = false;
      }
    }
  }

  Future<void> loadTreasuryAccounts() async {
    isTreasuryLoading.value = true;
    try {
      final response = await _getTreasuryAccounts(currencyId: selectedCurrencyId.value, perPage: 100);
      if (response.success) treasuryAccounts.assignAll(response.data ?? const []);
    } finally {
      isTreasuryLoading.value = false;
    }
  }

  Future<void> applyCurrencyFilter(int? currencyId) async {
    if (selectedCurrencyId.value == currencyId) return;
    selectedCurrencyId.value = currencyId;
    await Future.wait([
      loadOverview(),
      loadSubscriptions(reset: true),
      loadInvoices(reset: true),
      loadPayments(reset: true),
      loadTreasuryAccounts(),
    ]);
  }

  Future<void> applySubscriptionStatus(String? status) async {
    subscriptionStatusFilter.value = status;
    await loadSubscriptions(reset: true);
  }

  Future<void> applyInvoiceStatus(String? status) async {
    invoiceStatusFilter.value = status;
    await loadInvoices(reset: true);
  }

  Future<void> applyPaymentStatus(String? status) async {
    paymentStatusFilter.value = status;
    await loadPayments(reset: true);
  }

  Future<void> applySearch(String value) async {
    searchQuery.value = value;
    await Future.wait([loadSubscriptions(reset: true), loadInvoices(reset: true), loadPayments(reset: true)]);
  }


  Future<bool> _runBillingMutation({
    required String loadingMessage,
    required String successMessage,
    required Future<void> Function() action,
  }) async {
    isPlanMutationInProgress.value = true;
    var succeeded = false;
    try {
      await CustomAnimationOverlay.showLoading(message: loadingMessage);
      await action();
      succeeded = true;
    } catch (error) {
      CustomSnackbar.show(
        title: 'تعذر تنفيذ العملية',
        message: error.toString(),
        type: SnackType.error,
      );
    } finally {
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
      isPlanMutationInProgress.value = false;
    }

    if (succeeded) {
      await CustomAnimationOverlay.showSuccess(message: successMessage);
    }
    return succeeded;
  }

  void _requireSuccessful<T>(ApiResponse<T> response, String fallback) {
    if (!response.success || response.data == null) {
      throw StateError(response.message.trim().isEmpty ? fallback : response.message);
    }
  }

  Future<bool> createBillingProduct({
    required String key,
    required String name,
    String? description,
  }) async {
    final productKey = key.trim();
    final productName = name.trim();
    if (productKey.isEmpty || productName.isEmpty) {
      CustomSnackbar.show(
        title: 'بيانات ناقصة',
        message: 'أدخل معرف المنتج واسمه قبل الحفظ.',
        type: SnackType.warning,
      );
      return false;
    }

    return _runBillingMutation(
      loadingMessage: 'إنشاء منتج الفوترة...',
      successMessage: 'تم إنشاء المنتج.',
      action: () async {
        final response = await _createProduct({
          'product_key': productKey,
          'name': productName,
          if (description?.trim().isNotEmpty == true) 'description': description!.trim(),
          'is_active': true,
        });
        _requireSuccessful(response, 'لم يتم إنشاء المنتج.');
        final created = response.data!;
        await loadProducts();
        selectedProductId.value = created.id;
        productKeyController.clear();
        productNameController.clear();
        productDescriptionController.clear();
      },
    );
  }

  Future<bool> createPlanWithInitialPrice() async {
    if (selectedProductId.value == null || selectedPlanCurrencyId.value == null) {
      CustomSnackbar.show(
        title: 'بيانات ناقصة',
        message: 'اختر المنتج وعملة السعر أولاً.',
        type: SnackType.warning,
      );
      return false;
    }

    final planKey = planKeyController.text.trim();
    final planName = planNameController.text.trim();
    final amount = planUnitAmountController.text.trim();
    final setupFee = planSetupFeeController.text.trim().isEmpty ? '0' : planSetupFeeController.text.trim();
    final interval = selectedPlanBillingInterval.value;
    BillingCurrencyEntity? selectedCurrency;
    for (final currency in currencies) {
      if (currency.id == selectedPlanCurrencyId.value) {
        selectedCurrency = currency;
        break;
      }
    }

    if (planKey.isEmpty || planName.isEmpty || amount.isEmpty || interval == null) {
      CustomSnackbar.show(
        title: 'بيانات ناقصة',
        message: 'أكمل معرف الخطة واسمها وفترة الفوترة والسعر.',
        type: SnackType.warning,
      );
      return false;
    }
    final decimalPattern = RegExp(r'^\d+(?:\.\d{1,4})?$');
    if (!decimalPattern.hasMatch(amount) || !decimalPattern.hasMatch(setupFee)) {
      CustomSnackbar.show(
        title: 'قيمة سعر غير صالحة',
        message: 'أدخل السعر ورسوم التفعيل بصيغة عشرية صحيحة وغير سالبة.',
        type: SnackType.warning,
      );
      return false;
    }
    final decimalCount = amount.contains('.') ? amount.split('.').last.length : 0;
    final setupDecimalCount = setupFee.contains('.') ? setupFee.split('.').last.length : 0;
    if (selectedCurrency != null &&
        (decimalCount > selectedCurrency.decimalPlaces || setupDecimalCount > selectedCurrency.decimalPlaces)) {
      CustomSnackbar.show(
        title: 'دقة العملة غير مطابقة',
        message: 'العملة ${selectedCurrency.code} تسمح بـ ${selectedCurrency.decimalPlaces} منازل عشرية فقط.',
        type: SnackType.warning,
      );
      return false;
    }

    final featureKey = planFeatureKeyController.text.trim();
    final featureName = planFeatureNameController.text.trim();
    final featureValue = planFeatureValueController.text.trim();
    if (featureKey.isNotEmpty || featureName.isNotEmpty || featureValue.isNotEmpty) {
      if (featureKey.isEmpty || featureName.isEmpty || featureValue.isEmpty || selectedPlanFeatureType.value == null) {
        CustomSnackbar.show(
          title: 'بيانات الميزة غير مكتملة',
          message: 'أكمل معرف الميزة واسمها وقيمتها أو أفرغ جميع حقول الميزة الاختيارية.',
          type: SnackType.warning,
        );
        return false;
      }
      _pendingFeaturePayload ??= {
        'feature_key': featureKey,
        'name': featureName,
        'feature_type': selectedPlanFeatureType.value,
        'value': featureValue,
        if (planFeatureUnitController.text.trim().isNotEmpty) 'unit': planFeatureUnitController.text.trim(),
        'aggregation': 'SUM',
        'overage_behavior': 'BLOCK',
      };
    }

    _pendingPlanPayload ??= {
      'product_id': selectedProductId.value,
      'plan_key': planKey,
      'name': planName,
      if (planDescriptionController.text.trim().isNotEmpty) 'description': planDescriptionController.text.trim(),
      'is_public': true,
      'is_active': true,
    };
    _pendingPricePayload ??= {
      'currency_id': selectedPlanCurrencyId.value,
      'billing_interval': interval,
      'interval_count': 1,
      'unit_amount': amount,
      'setup_fee': setupFee,
      'tax_behavior': 'EXCLUSIVE',
    };

    final result = await _runBillingMutation(
      loadingMessage: 'حفظ الخطة وإصدارها الأول...',
      successMessage: 'تم إنشاء الخطة وإصدارها كمسودة مع السعر الأول.',
      action: () async {
        if (_pendingPlanId == null) {
          final planResponse = await _createPlan(_pendingPlanPayload!);
          _requireSuccessful(planResponse, 'تعذر إنشاء الخطة.');
          _pendingPlanId = planResponse.data!.id;
          lastCreatedPlanId.value = _pendingPlanId;
        }

        if (_pendingDraftVersionId == null) {
          final draftResponse = await _createDraftVersion(_pendingPlanId!);
          _requireSuccessful(draftResponse, 'تعذر إنشاء إصدار المسودة.');
          _pendingDraftVersionId = draftResponse.data!.id;
          lastCreatedDraftVersionId.value = _pendingDraftVersionId;
        }

        if (!_pendingPriceAdded) {
          final priceResponse = await _addPlanPrice(_pendingDraftVersionId!, _pendingPricePayload!);
          _requireSuccessful(priceResponse, 'تعذر إضافة السعر إلى المسودة.');
          _pendingPriceAdded = true;
        }

        if (_pendingFeaturePayload != null && !_pendingFeatureAdded) {
          final featureResponse = await _addPlanFeature(_pendingDraftVersionId!, _pendingFeaturePayload!);
          _requireSuccessful(featureResponse, 'تعذر إضافة الميزة إلى المسودة.');
          _pendingFeatureAdded = true;
        }

        await loadPlans();
        await loadPlanVersions(_pendingPlanId!);
      },
    );

    if (!result && _pendingPlanId != null) {
      await loadPlans();
      if (_pendingDraftVersionId != null) {
        await loadPlanVersions(_pendingPlanId!);
      }
    }

    if (result) {
      _pendingPlanId = null;
      _pendingDraftVersionId = null;
      _pendingPriceAdded = false;
      _pendingFeatureAdded = false;
      _pendingPlanPayload = null;
      _pendingPricePayload = null;
      _pendingFeaturePayload = null;
      lastCreatedPlanId.value = null;
      lastCreatedDraftVersionId.value = null;
      _resetPlanEditor();
      Get.back<void>();
    }
    return result;
  }

  Future<void> loadTrialPolicies({bool reset = false, String? search}) async {
    if (isTrialPoliciesLoading.value) return;
    if (reset) _trialPoliciesCursor = null;
    isTrialPoliciesLoading.value = true;
    final requestId = ++_trialPoliciesRequest;
    try {
      final response = await _getTrialPolicies(
        search: search,
        cursor: reset ? null : _trialPoliciesCursor,
        perPage: 30,
      );
      if (requestId != _trialPoliciesRequest || !response.success) return;
      if (reset) {
        trialPolicies.assignAll(response.data ?? const []);
      } else {
        trialPolicies.addAll(response.data ?? const []);
      }
      _trialPoliciesCursor = response.nextCursor;
    } finally {
      if (requestId == _trialPoliciesRequest) isTrialPoliciesLoading.value = false;
    }
  }

  Future<void> loadDunningPolicies({bool reset = false, String? search}) async {
    if (isDunningPoliciesLoading.value) return;
    if (reset) _dunningPoliciesCursor = null;
    isDunningPoliciesLoading.value = true;
    final requestId = ++_dunningPoliciesRequest;
    try {
      final response = await _getDunningPolicies(
        search: search,
        cursor: reset ? null : _dunningPoliciesCursor,
        perPage: 30,
      );
      if (requestId != _dunningPoliciesRequest || !response.success) return;
      if (reset) {
        dunningPolicies.assignAll(response.data ?? const []);
      } else {
        dunningPolicies.addAll(response.data ?? const []);
      }
      _dunningPoliciesCursor = response.nextCursor;
    } finally {
      if (requestId == _dunningPoliciesRequest) isDunningPoliciesLoading.value = false;
    }
  }

  Future<void> loadPendingTrialRedemptions({bool reset = false}) async {
    if (isPendingRedemptionsLoading.value) return;
    if (reset) _pendingRedemptionsCursor = null;
    isPendingRedemptionsLoading.value = true;
    final requestId = ++_pendingRedemptionsRequest;
    try {
      final response = await _getPendingTrialRedemptions(
        cursor: reset ? null : _pendingRedemptionsCursor,
        perPage: 30,
      );
      if (requestId != _pendingRedemptionsRequest || !response.success) return;
      if (reset) {
        pendingTrialRedemptions.assignAll(response.data ?? const []);
      } else {
        pendingTrialRedemptions.addAll(response.data ?? const []);
      }
      _pendingRedemptionsCursor = response.nextCursor;
    } finally {
      if (requestId == _pendingRedemptionsRequest) isPendingRedemptionsLoading.value = false;
    }
  }

  Future<void> loadTrialPolicyVersions(int policyId) async {
    if (isTrialPolicyVersionsLoading.contains(policyId)) return;
    isTrialPolicyVersionsLoading.add(policyId);
    isTrialPolicyVersionsLoading.refresh();
    try {
      final response = await _getTrialPolicyVersions(policyId, perPage: 30);
      if (response.success) {
        trialPolicyVersions[policyId] = response.data ?? const [];
        trialPolicyVersions.refresh();
      }
    } finally {
      isTrialPolicyVersionsLoading.remove(policyId);
      isTrialPolicyVersionsLoading.refresh();
    }
  }

  Future<void> loadDunningPolicyVersions(int policyId) async {
    if (isDunningPolicyVersionsLoading.contains(policyId)) return;
    isDunningPolicyVersionsLoading.add(policyId);
    isDunningPolicyVersionsLoading.refresh();
    try {
      final response = await _getDunningPolicyVersions(policyId, perPage: 30);
      if (response.success) {
        dunningPolicyVersions[policyId] = response.data ?? const [];
        dunningPolicyVersions.refresh();
      }
    } finally {
      isDunningPolicyVersionsLoading.remove(policyId);
      isDunningPolicyVersionsLoading.refresh();
    }
  }

  Future<bool> _runPolicyMutation({
    required String loadingMessage,
    required String successMessage,
    required Future<void> Function() action,
  }) async {
    if (isPolicyMutationInProgress.value) return false;
    isPolicyMutationInProgress.value = true;
    var succeeded = false;
    try {
      await CustomAnimationOverlay.showLoading(message: loadingMessage);
      await action();
      succeeded = true;
    } catch (error) {
      CustomSnackbar.show(
        title: 'تعذر تنفيذ العملية',
        message: error.toString(),
        type: SnackType.error,
      );
    } finally {
      if (CustomAnimationOverlay.isShowing) {
        await CustomAnimationOverlay.hide();
      }
      isPolicyMutationInProgress.value = false;
    }
    if (succeeded) {
      await CustomAnimationOverlay.showSuccess(message: successMessage);
    }
    return succeeded;
  }

  Future<bool> createTrialPolicy(Map<String, dynamic> data) async =>
      _runPolicyMutation(
        loadingMessage: 'إنشاء سياسة التجربة كمسودة...',
        successMessage: 'تم إنشاء سياسة التجربة كمسودة.',
        action: () async {
          final response = await _createTrialPolicy(data);
          _requireSuccessful(response, 'تعذر إنشاء سياسة التجربة.');
          await loadTrialPolicies(reset: true);
        },
      );

  Future<bool> createDunningPolicy(Map<String, dynamic> data) async =>
      _runPolicyMutation(
        loadingMessage: 'إنشاء سياسة التحصيل كمسودة...',
        successMessage: 'تم إنشاء سياسة التحصيل كمسودة.',
        action: () async {
          final response = await _createDunningPolicy(data);
          _requireSuccessful(response, 'تعذر إنشاء سياسة التحصيل.');
          await loadDunningPolicies(reset: true);
        },
      );

  Future<bool> createTrialPolicyVersion(int policyId, Map<String, dynamic> data) async =>
      _runPolicyMutation(
        loadingMessage: 'إنشاء إصدار مسودة لسياسة التجربة...',
        successMessage: 'تم إنشاء إصدار المسودة.',
        action: () async {
          final response = await _createTrialPolicyVersion(policyId, data);
          _requireSuccessful(response, 'تعذر إنشاء إصدار سياسة التجربة.');
          await loadTrialPolicyVersions(policyId);
          await loadTrialPolicies(reset: true);
        },
      );

  Future<bool> createDunningPolicyVersion(int policyId, Map<String, dynamic> data) async =>
      _runPolicyMutation(
        loadingMessage: 'إنشاء إصدار مسودة لسياسة التحصيل...',
        successMessage: 'تم إنشاء إصدار المسودة.',
        action: () async {
          final response = await _createDunningPolicyVersion(policyId, data);
          _requireSuccessful(response, 'تعذر إنشاء إصدار سياسة التحصيل.');
          await loadDunningPolicyVersions(policyId);
          await loadDunningPolicies(reset: true);
        },
      );

  Future<bool> publishTrialPolicyVersion(int policyId, int versionId) async =>
      _runPolicyMutation(
        loadingMessage: 'نشر إصدار سياسة التجربة...',
        successMessage: 'تم نشر إصدار سياسة التجربة.',
        action: () async {
          final response = await _publishTrialPolicyVersion(versionId);
          _requireSuccessful(response, 'تعذر نشر إصدار سياسة التجربة.');
          await loadTrialPolicyVersions(policyId);
          await loadTrialPolicies(reset: true);
        },
      );

  Future<bool> publishDunningPolicyVersion(int policyId, int versionId) async =>
      _runPolicyMutation(
        loadingMessage: 'نشر إصدار سياسة التحصيل...',
        successMessage: 'تم نشر إصدار سياسة التحصيل.',
        action: () async {
          final response = await _publishDunningPolicyVersion(versionId);
          _requireSuccessful(response, 'تعذر نشر إصدار سياسة التحصيل.');
          await loadDunningPolicyVersions(policyId);
          await loadDunningPolicies(reset: true);
        },
      );

  Future<bool> assignPlanPolicies(
    int planVersionId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) async =>
      _runPolicyMutation(
        loadingMessage: 'ربط سياسات الاشتراك بإصدار الخطة...',
        successMessage: 'تم حفظ ارتباط السياسات.',
        action: () async {
          final response = await _assignPlanPolicies(
            planVersionId,
            trialPolicyVersionId: trialPolicyVersionId,
            dunningPolicyVersionId: dunningPolicyVersionId,
          );
          _requireSuccessful(response, 'تعذر ربط سياسات الاشتراك بإصدار الخطة.');
        },
      );

  Future<bool> assignPricePolicies(
    int priceId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) async =>
      _runPolicyMutation(
        loadingMessage: 'ربط سياسات الاشتراك بالسعر...',
        successMessage: 'تم حفظ ارتباط السياسات بالسعر.',
        action: () async {
          final response = await _assignPricePolicies(
            priceId,
            trialPolicyVersionId: trialPolicyVersionId,
            dunningPolicyVersionId: dunningPolicyVersionId,
          );
          _requireSuccessful(response, 'تعذر ربط سياسات الاشتراك بالسعر.');
        },
      );

  Future<bool> approveTrialRedemption(int redemptionId) async =>
      _runPolicyMutation(
        loadingMessage: 'اعتماد طلب التجربة...',
        successMessage: 'تم اعتماد طلب التجربة.',
        action: () async {
          final response = await _approveTrialRedemption(redemptionId);
          _requireSuccessful(response, 'تعذر اعتماد طلب التجربة.');
          await loadPendingTrialRedemptions(reset: true);
        },
      );

  Future<bool> rejectTrialRedemption(int redemptionId, String reason) async =>
      _runPolicyMutation(
        loadingMessage: 'رفض طلب التجربة...',
        successMessage: 'تم رفض طلب التجربة وإغلاق الاشتراك المعلق.',
        action: () async {
          final response = await _rejectTrialRedemption(redemptionId, reason: reason);
          _requireSuccessful(response, 'تعذر رفض طلب التجربة.');
          await loadPendingTrialRedemptions(reset: true);
        },
      );

  Future<bool> adjustSubscriptionTrial(
    int subscriptionId, {
    required String adjustmentType,
    int? days,
    required String reason,
  }) async =>
      _runPolicyMutation(
        loadingMessage: 'تعديل فترة التجربة...',
        successMessage: 'تم تسجيل تعديل فترة التجربة.',
        action: () async {
          final response = await _adjustSubscriptionTrial(
            subscriptionId,
            adjustmentType: adjustmentType,
            days: days,
            reason: reason,
          );
          _requireSuccessful(response, 'تعذر تعديل فترة التجربة.');
        },
      );

  void prepareDraftPriceEditor() {
    planUnitAmountController.clear();
    planSetupFeeController.text = '0';
    selectedPlanCurrencyId.value = null;
    selectedPlanBillingInterval.value = 'MONTH';
  }

  void prepareDraftFeatureEditor() {
    planFeatureKeyController.clear();
    planFeatureNameController.clear();
    planFeatureValueController.text = '-1';
    planFeatureUnitController.clear();
    selectedPlanFeatureType.value = 'RESOURCE_LIMIT';
  }

  BillingPlanVersionEntity? _findPlanVersion(int planId, int versionId) {
    for (final version in planVersions[planId] ?? const <BillingPlanVersionEntity>[]) {
      if (version.id == versionId) return version;
    }
    return null;
  }

  Future<bool> addPriceToDraft({
    required int planId,
    required int versionId,
    required int currencyId,
    required String billingInterval,
    required String unitAmount,
    required String setupFee,
  }) async {
    BillingCurrencyEntity? currency;
    for (final item in currencies) {
      if (item.id == currencyId && item.isActive) {
        currency = item;
        break;
      }
    }
    if (currency == null) {
      CustomSnackbar.show(
        title: 'العملة غير متاحة',
        message: 'اختر عملة نشطة من قائمة العملات.',
        type: SnackType.warning,
      );
      return false;
    }

    final amount = unitAmount.trim();
    final fee = setupFee.trim().isEmpty ? '0' : setupFee.trim();
    final decimalPattern = RegExp(r'^\d+(?:\.\d{1,4})?$');
    if (!decimalPattern.hasMatch(amount) || !decimalPattern.hasMatch(fee)) {
      CustomSnackbar.show(
        title: 'قيمة سعر غير صالحة',
        message: 'أدخل مبالغ عشرية صحيحة وغير سالبة.',
        type: SnackType.warning,
      );
      return false;
    }
    final amountPlaces = amount.contains('.') ? amount.split('.').last.length : 0;
    final feePlaces = fee.contains('.') ? fee.split('.').last.length : 0;
    if (amountPlaces > currency.decimalPlaces || feePlaces > currency.decimalPlaces) {
      CustomSnackbar.show(
        title: 'دقة العملة غير مطابقة',
        message: 'العملة ${currency.code} تسمح بـ ${currency.decimalPlaces} منازل عشرية فقط.',
        type: SnackType.warning,
      );
      return false;
    }

    var version = _findPlanVersion(planId, versionId);
    if (version == null) {
      await loadPlanVersions(planId);
      version = _findPlanVersion(planId, versionId);
    }
    if (version == null || version.typedStatus != BillingPlanVersionStatus.draft) {
      CustomSnackbar.show(
        title: 'الإصدار غير قابل للتعديل',
        message: 'يمكن إضافة الأسعار إلى إصدار مسودة فقط.',
        type: SnackType.warning,
      );
      return false;
    }
    final duplicate = version.prices.any((price) =>
        price.currencyId == currencyId &&
        price.billingInterval == billingInterval &&
        price.intervalCount == 1);
    if (duplicate) {
      CustomSnackbar.show(
        title: 'السعر موجود مسبقاً',
        message: 'هذا الإصدار يحتوي بالفعل على سعر بهذه العملة ودورة الفوترة.',
        type: SnackType.warning,
      );
      return false;
    }

    return _runBillingMutation(
      loadingMessage: 'إضافة السعر إلى إصدار المسودة...',
      successMessage: 'تمت إضافة السعر إلى إصدار المسودة.',
      action: () async {
        final response = await _addPlanPrice(versionId, {
          'currency_id': currencyId,
          'billing_interval': billingInterval,
          'interval_count': 1,
          'unit_amount': amount,
          'setup_fee': fee,
          'tax_behavior': 'EXCLUSIVE',
        });
        _requireSuccessful(response, 'تعذر إضافة السعر إلى الإصدار.');
        await loadPlanVersions(planId);
      },
    );
  }

  Future<bool> addFeatureToDraft({
    required int planId,
    required int versionId,
    required String featureKey,
    required String name,
    required String featureType,
    required String value,
    String? unit,
  }) async {
    final key = featureKey.trim();
    final featureName = name.trim();
    final featureValue = value.trim();
    if (key.isEmpty || featureName.isEmpty || featureValue.isEmpty) {
      CustomSnackbar.show(
        title: 'بيانات الميزة ناقصة',
        message: 'أدخل معرف الميزة واسمها وقيمتها.',
        type: SnackType.warning,
      );
      return false;
    }

    var version = _findPlanVersion(planId, versionId);
    if (version == null) {
      await loadPlanVersions(planId);
      version = _findPlanVersion(planId, versionId);
    }
    if (version == null || version.typedStatus != BillingPlanVersionStatus.draft) {
      CustomSnackbar.show(
        title: 'الإصدار غير قابل للتعديل',
        message: 'يمكن إضافة المزايا إلى إصدار مسودة فقط.',
        type: SnackType.warning,
      );
      return false;
    }
    if (version.features.any((feature) => feature.key == key)) {
      CustomSnackbar.show(
        title: 'معرف الميزة مستخدم',
        message: 'يوجد في الإصدار ميزة تحمل هذا المعرف بالفعل.',
        type: SnackType.warning,
      );
      return false;
    }

    return _runBillingMutation(
      loadingMessage: 'إضافة الميزة إلى إصدار المسودة...',
      successMessage: 'تمت إضافة الميزة إلى إصدار المسودة.',
      action: () async {
        final response = await _addPlanFeature(versionId, {
          'feature_key': key,
          'name': featureName,
          'feature_type': featureType,
          'value': featureValue,
          if (unit?.trim().isNotEmpty == true) 'unit': unit!.trim(),
          'aggregation': 'SUM',
          'overage_behavior': 'BLOCK',
        });
        _requireSuccessful(response, 'تعذر إضافة الميزة إلى الإصدار.');
        await loadPlanVersions(planId);
      },
    );
  }

  Future<bool> publishPlanDraft(int planId, int versionId) async {
    if (isPlanPublishInProgress.value) return false;
    isPlanPublishInProgress.value = true;
    try {
      return await _runBillingMutation(
        loadingMessage: 'التحقق من شروط النشر...',
        successMessage: 'تم نشر إصدار الخطة وتثبيت شروطه.',
        action: () async {
          final response = await _publishPlanVersion(versionId);
          _requireSuccessful(response, 'لم يتم نشر إصدار الخطة.');
          await loadPlans();
          await loadPlanVersions(planId);
        },
      );
    } finally {
      isPlanPublishInProgress.value = false;
    }
  }

  void _resetPlanEditor() {
    planKeyController.clear();
    planNameController.clear();
    planDescriptionController.clear();
    planUnitAmountController.clear();
    planSetupFeeController.text = '0';
    planFeatureKeyController.clear();
    planFeatureNameController.clear();
    planFeatureValueController.text = '-1';
    planFeatureUnitController.clear();
    selectedPlanBillingInterval.value = 'MONTH';
    selectedPlanFeatureType.value = 'RESOURCE_LIMIT';
  }

  Future<void> refresh() => loadInitial();

  @override
  void onClose() {
    productKeyController.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    planKeyController.dispose();
    planNameController.dispose();
    planDescriptionController.dispose();
    planUnitAmountController.dispose();
    planSetupFeeController.dispose();
    planFeatureKeyController.dispose();
    planFeatureNameController.dispose();
    planFeatureValueController.dispose();
    planFeatureUnitController.dispose();
    selectedProductId.dispose();
    selectedPlanCurrencyId.dispose();
    selectedPlanBillingInterval.dispose();
    selectedPlanFeatureType.dispose();
    trialPolicyKeyController.dispose();
    trialPolicyNameController.dispose();
    trialPolicyDescriptionController.dispose();
    trialDurationController.dispose();
    trialEntitlementConfigController.dispose();
    dunningPolicyKeyController.dispose();
    dunningPolicyNameController.dispose();
    dunningPolicyDescriptionController.dispose();
    dunningGraceDaysController.dispose();
    dunningReminderDaysController.dispose();
    dunningPreRenewalDaysController.dispose();
    trialDurationUnit.dispose();
    trialStartTrigger.dispose();
    trialRedemptionScope.dispose();
    trialEligibilityMode.dispose();
    trialRequiresApproval.dispose();
    trialIsEnabled.dispose();
    trialEndBehavior.dispose();
    trialEntitlementMode.dispose();
    dunningAutoSuspend.dispose();
    selectedTrialPolicyVersionId.dispose();
    selectedDunningPolicyVersionId.dispose();
    super.onClose();
  }
}
