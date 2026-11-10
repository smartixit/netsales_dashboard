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
  final GetBillingSubscriptionsUseCase _getSubscriptions;
  final GetBillingInvoicesUseCase _getInvoices;
  final GetBillingPaymentsUseCase _getPayments;
  final GetBillingTreasuryAccountsUseCase _getTreasuryAccounts;

  final overview = Rxn<BillingOverviewEntity>();
  final currencies = <BillingCurrencyEntity>[].obs;
  final plans = <BillingPlanEntity>[].obs;
  final products = <BillingProductEntity>[].obs;
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
    super.onClose();
  }
}
