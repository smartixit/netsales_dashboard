import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/provider_subscription_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_feature_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_plan_feature_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_features_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/approve_subscription_request_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/extend_provider_subscription_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_provider_subscriptions_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_plans_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_requests_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_request_receipt_use_case.dart';
import 'package:netsales_dashboard/core/services/file_export_service.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/reject_subscription_request_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/save_subscription_plan_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/toggle_subscription_plan_status_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/delete_subscription_plan_use_case.dart';

class PlatformSubscriptionsController extends GetxController {
  PlatformSubscriptionsController({
    required GetSubscriptionPlansUseCase getPlans,
    required GetSubscriptionFeaturesUseCase getFeatures,
    required GetProviderSubscriptionsUseCase getSubscriptions,
    required GetSubscriptionRequestsUseCase getRequests,
    required GetSubscriptionRequestReceiptUseCase getRequestReceipt,
    required SaveSubscriptionPlanUseCase savePlan,
    required ToggleSubscriptionPlanStatusUseCase togglePlan,
    required DeleteSubscriptionPlanUseCase deletePlan,
    required ApproveSubscriptionRequestUseCase approveRequest,
    required RejectSubscriptionRequestUseCase rejectRequest,
    required ExtendProviderSubscriptionUseCase extendSubscription,
  }) : _getPlans = getPlans,
       _getFeatures = getFeatures,
       _getSubscriptions = getSubscriptions,
       _getRequests = getRequests,
       _getRequestReceipt = getRequestReceipt,
       _savePlan = savePlan,
       _togglePlan = togglePlan,
       _deletePlan = deletePlan,
       _approveRequest = approveRequest,
       _rejectRequest = rejectRequest,
       _extendSubscription = extendSubscription;

  final GetSubscriptionPlansUseCase _getPlans;
  final GetSubscriptionFeaturesUseCase _getFeatures;
  final GetProviderSubscriptionsUseCase _getSubscriptions;
  final GetSubscriptionRequestsUseCase _getRequests;
  final GetSubscriptionRequestReceiptUseCase _getRequestReceipt;
  final SaveSubscriptionPlanUseCase _savePlan;
  final ToggleSubscriptionPlanStatusUseCase _togglePlan;
  final DeleteSubscriptionPlanUseCase _deletePlan;
  final ApproveSubscriptionRequestUseCase _approveRequest;
  final RejectSubscriptionRequestUseCase _rejectRequest;
  final ExtendProviderSubscriptionUseCase _extendSubscription;

  static const int pageSize = 20;
  final plans = <SubscriptionPlanEntity>[].obs;
  final featureCatalog = <SubscriptionFeatureEntity>[].obs;
  final selectedFeatureIds = <int>{}.obs;
  final Map<int, TextEditingController> featureLimitControllers = <int, TextEditingController>{};
  final subscriptions = <ProviderSubscriptionEntity>[].obs;
  final requests = <SubscriptionRequestEntity>[].obs;
  final plansLoading = true.obs;
  final subscriptionsLoading = true.obs;
  final requestsLoading = true.obs;
  final isMutating = false.obs;
  final plansError = ''.obs;
  final subscriptionsError = ''.obs;
  final requestsError = ''.obs;
  final planCursor = RxnString();
  final subscriptionCursor = RxnString();
  final requestCursor = RxnString();
  final planStatus = ''.obs;
  final subscriptionStatus = ''.obs;
  final requestStatus = 'PENDING'.obs;
  final planSearchController = TextEditingController();
  final requestSearchController = TextEditingController();
  final planNameController = TextEditingController();
  final planPriceController = TextEditingController();
  final planDiscountController = TextEditingController();
  final planValidityController = TextEditingController(text: '30');
  final planDescriptionController = TextEditingController();
  final rejectReasonController = TextEditingController();
  final reviewNoteController = TextEditingController();
  final extensionDaysController = TextEditingController(text: '30');
  Timer? _planDebounce;
  Timer? _requestDebounce;
  int _planGeneration = 0;
  int _subscriptionGeneration = 0;
  int _requestGeneration = 0;

  bool get hasMorePlans => planCursor.value?.isNotEmpty ?? false;
  bool get hasMoreSubscriptions => subscriptionCursor.value?.isNotEmpty ?? false;
  bool get hasMoreRequests => requestCursor.value?.isNotEmpty ?? false;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
    loadFeatureCatalog();
    loadSubscriptions();
    loadRequests();
  }

  Future<void> loadPlans({bool append = false}) async {
    if (append && (!hasMorePlans || plansLoading.value)) return;
    final generation = ++_planGeneration;
    plansLoading.value = true;
    if (!append) { plansError.value = ''; planCursor.value = null; }
    try {
      final r = await _getPlans(search: planSearchController.text, status: planStatus.value, cursor: append ? planCursor.value : null, perPage: pageSize);
      if (generation != _planGeneration) return;
      _ensure(r.success, r.message);
      if (append) { plans.addAll(r.data ?? const []); } else { plans.assignAll(r.data ?? const []); }
      planCursor.value = r.nextCursor;
    } catch (e) { if (generation == _planGeneration) plansError.value = e.toString(); }
    finally { if (generation == _planGeneration) plansLoading.value = false; }
  }

  Future<void> loadFeatureCatalog() async {
    try {
      final response = await _getFeatures(status: '1', perPage: 100);
      if (response.success) featureCatalog.assignAll(response.data ?? const <SubscriptionFeatureEntity>[]);
    } catch (_) {
      featureCatalog.clear();
    }
  }

  Future<void> loadSubscriptions({bool append = false}) async {
    if (append && (!hasMoreSubscriptions || subscriptionsLoading.value)) return;
    final generation = ++_subscriptionGeneration;
    subscriptionsLoading.value = true;
    if (!append) { subscriptionsError.value = ''; subscriptionCursor.value = null; }
    try {
      final r = await _getSubscriptions(status: subscriptionStatus.value, cursor: append ? subscriptionCursor.value : null, perPage: pageSize);
      if (generation != _subscriptionGeneration) return;
      _ensure(r.success, r.message);
      if (append) { subscriptions.addAll(r.data ?? const []); } else { subscriptions.assignAll(r.data ?? const []); }
      subscriptionCursor.value = r.nextCursor;
    } catch (e) { if (generation == _subscriptionGeneration) subscriptionsError.value = e.toString(); }
    finally { if (generation == _subscriptionGeneration) subscriptionsLoading.value = false; }
  }

  Future<void> loadRequests({bool append = false}) async {
    if (append && (!hasMoreRequests || requestsLoading.value)) return;
    final generation = ++_requestGeneration;
    requestsLoading.value = true;
    if (!append) { requestsError.value = ''; requestCursor.value = null; }
    try {
      final r = await _getRequests(status: requestStatus.value, search: requestSearchController.text, cursor: append ? requestCursor.value : null, perPage: pageSize);
      if (generation != _requestGeneration) return;
      _ensure(r.success, r.message);
      if (append) { requests.addAll(r.data ?? const []); } else { requests.assignAll(r.data ?? const []); }
      requestCursor.value = r.nextCursor;
    } catch (e) { if (generation == _requestGeneration) requestsError.value = e.toString(); }
    finally { if (generation == _requestGeneration) requestsLoading.value = false; }
  }

  void onPlanSearchChanged(String _) { _planDebounce?.cancel(); _planDebounce = Timer(const Duration(milliseconds: 400), loadPlans); }
  void onRequestSearchChanged(String _) { _requestDebounce?.cancel(); _requestDebounce = Timer(const Duration(milliseconds: 400), loadRequests); }

  Future<void> savePlan({int? id}) async {
    final name = planNameController.text.trim();
    final price = planPriceController.text.trim();
    final validity = int.tryParse(planValidityController.text.trim());
    if (name.isEmpty || price.isEmpty || num.tryParse(price) == null || validity == null || validity < 1) {
      throw Exception('أدخل اسم الباقة والسعر ومدة صلاحية صحيحة.');
    }
    final data = <String, dynamic>{
      'plan_name': name,
      'plan_price': price,
      'plan_discount': planDiscountController.text.trim().isEmpty ? 0 : planDiscountController.text.trim(),
      'plan_validity': validity,
      'plan_desc': planDescriptionController.text.trim(),
      'features': selectedFeatureIds.map((id) => <String, dynamic>{
        'feature_id': id,
        'plan_feature_value': featureLimitControllers[id]?.text.trim().isNotEmpty == true ? featureLimitControllers[id]!.text.trim() : '-1',
        'status': true,
      }).toList(growable: false),
    };
    isMutating.value = true;
    try {
      if (id == null) { await _savePlan.create(data); } else { await _savePlan.update(id, data); }
      await loadPlans();
    } finally { isMutating.value = false; }
  }

  Future<void> togglePlan(SubscriptionPlanEntity plan) async {
    isMutating.value = true;
    try { await _togglePlan(plan.id); await loadPlans(); }
    finally { isMutating.value = false; }
  }

  Future<void> removePlan(int id) async {
    isMutating.value = true;
    try { await _deletePlan(id); await loadPlans(); }
    finally { isMutating.value = false; }
  }

  Future<void> openReceipt(SubscriptionRequestEntity request) async {
    isMutating.value = true;
    try {
      final bytes = await _getRequestReceipt(request.id);
      final rawExtension = request.receiptPath?.split('.').last.toLowerCase();
      final extension = rawExtension != null && rawExtension.length <= 5 ? rawExtension : null;
      final result = await FileExportService.instance.saveFile(
        bytes: bytes,
        fileName: 'subscription-receipt-${request.id}',
        extension: extension,
        folderName: 'Subscription Receipts',
        autoOpen: true,
        showFeedback: true,
      );
      if (!result.isSuccess) throw Exception(result.errorMessage ?? 'Unable to open receipt.');
    } catch (error) {
      CustomSnackbar.show(title: 'Receipt', message: error.toString(), type: SnackType.error);
    } finally {
      isMutating.value = false;
    }
  }

  Future<void> approve(SubscriptionRequestEntity request) async {
    isMutating.value = true;
    try { await _approveRequest(request.id, note: reviewNoteController.text.trim()); await loadRequests(); await loadSubscriptions(); }
    finally { isMutating.value = false; }
  }

  Future<void> reject(SubscriptionRequestEntity request) async {
    final reason = rejectReasonController.text.trim();
    if (reason.isEmpty) throw Exception('سبب الرفض مطلوب.');
    isMutating.value = true;
    try { await _rejectRequest(request.id, reason: reason, note: reviewNoteController.text.trim()); await loadRequests(); }
    finally { isMutating.value = false; }
  }

  Future<void> extend(ProviderSubscriptionEntity subscription) async {
    final days = int.tryParse(extensionDaysController.text.trim());
    if (days == null || days < 1 || days > 3650) throw Exception('أدخل عدد أيام من 1 إلى 3650.');
    isMutating.value = true;
    try { await _extendSubscription(subscription.id, days); await loadSubscriptions(); }
    finally { isMutating.value = false; }
  }

  void resetPlanForm([SubscriptionPlanEntity? plan]) {
    final planFeatures = plan?.planFeatures ??
        const <SubscriptionPlanFeatureEntity>[];
    planNameController.text = plan?.name ?? '';
    planPriceController.text = plan?.price ?? '';
    planDiscountController.text = plan?.discount ?? '0';
    planValidityController.text = (plan?.validityDays ?? 30).toString();
    planDescriptionController.text = plan?.description ?? '';
    selectedFeatureIds.assignAll(planFeatures.where((feature) => feature.isActive).map((feature) => feature.featureId));
    for (final controller in featureLimitControllers.values) { controller.dispose(); }
    featureLimitControllers.clear();
    for (final feature in planFeatures) {
      featureLimitControllers[feature.featureId] = TextEditingController(text: feature.value);
    }
  }

  void toggleFeatureSelection(SubscriptionFeatureEntity feature, {String? currentValue}) {
    if (selectedFeatureIds.contains(feature.id)) {
      selectedFeatureIds.remove(feature.id);
      featureLimitControllers.remove(feature.id)?.dispose();
    } else {
      selectedFeatureIds.add(feature.id);
      featureLimitControllers[feature.id] = TextEditingController(text: currentValue ?? feature.defaultValue ?? '-1');
    }
  }

  void _ensure(bool success, String message) {
    if (!success) throw Exception(message.isEmpty ? 'تعذر تحميل بيانات الاشتراكات.' : message);
  }

  @override
  void onClose() {
    _planGeneration++; _subscriptionGeneration++; _requestGeneration++;
    _planDebounce?.cancel(); _requestDebounce?.cancel();
    for (final c in featureLimitControllers.values) { c.dispose(); }
    for (final c in [planSearchController, requestSearchController, planNameController, planPriceController, planDiscountController, planValidityController, planDescriptionController, rejectReasonController, reviewNoteController, extensionDaysController]) { c.dispose(); }
    super.onClose();
  }
}
