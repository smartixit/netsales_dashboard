import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/usecases/platform_billing_use_cases.dart';

class PlatformBillingController extends GetxController {
  PlatformBillingController({
    required GetBillingOverviewUseCase getOverview,
    required GetBillingCurrenciesUseCase getCurrencies,
    required GetBillingPlansUseCase getPlans,
    required GetBillingPlanVersionsUseCase getPlanVersions,
    required GetBillingSubscriptionsUseCase getSubscriptions,
    required GetBillingInvoicesUseCase getInvoices,
    required GetBillingPaymentsUseCase getPayments,
    required GetBillingTreasuryAccountsUseCase getTreasuryAccounts,
  }) : _getOverview = getOverview,
       _getCurrencies = getCurrencies,
       _getPlans = getPlans,
       _getPlanVersions = getPlanVersions,
       _getSubscriptions = getSubscriptions,
       _getInvoices = getInvoices,
       _getPayments = getPayments,
       _getTreasuryAccounts = getTreasuryAccounts;

  final GetBillingOverviewUseCase _getOverview;
  final GetBillingCurrenciesUseCase _getCurrencies;
  final GetBillingPlansUseCase _getPlans;
  final GetBillingPlanVersionsUseCase _getPlanVersions;
  final GetBillingSubscriptionsUseCase _getSubscriptions;
  final GetBillingInvoicesUseCase _getInvoices;
  final GetBillingPaymentsUseCase _getPayments;
  final GetBillingTreasuryAccountsUseCase _getTreasuryAccounts;

  final overview = Rxn<BillingOverviewEntity>();
  final currencies = <BillingCurrencyEntity>[].obs;
  final plans = <BillingPlanEntity>[].obs;
  final planVersions = <int, List<BillingPlanVersionEntity>>{}.obs;
  final loadingPlanVersions = <int>{}.obs;
  final subscriptions = <BillingSubscriptionEntity>[].obs;
  final invoices = <BillingInvoiceEntity>[].obs;
  final payments = <BillingPaymentEntity>[].obs;
  final treasuryAccounts = <BillingTreasuryAccountEntity>[].obs;

  final isOverviewLoading = false.obs;
  final isCurrenciesLoading = false.obs;
  final isPlansLoading = false.obs;
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
      if (response.success) currencies.assignAll(response.data ?? const []);
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

  Future<void> refresh() => loadInitial();
}
