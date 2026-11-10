import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_billing/data/datasources/platform_billing_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_billing/data/datasources/platform_billing_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_billing/data/repositories/platform_billing_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/repositories/platform_billing_repository.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/usecases/platform_billing_use_cases.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';

class PlatformBillingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlatformBillingRemoteDataSource>()) {
      Get.lazyPut<PlatformBillingRemoteDataSource>(PlatformBillingRemoteDataSourceImpl.new);
    }
    if (!Get.isRegistered<PlatformBillingRepository>()) {
      Get.lazyPut<PlatformBillingRepository>(
        () => PlatformBillingRepositoryImpl(Get.find<PlatformBillingRemoteDataSource>()),
      );
    }

    final repository = () => Get.find<PlatformBillingRepository>();
    Get.lazyPut(() => GetBillingOverviewUseCase(repository()));
    Get.lazyPut(() => GetBillingCurrenciesUseCase(repository()));
    Get.lazyPut(() => GetBillingPlansUseCase(repository()));
    Get.lazyPut(() => GetBillingProductsUseCase(repository()));
    Get.lazyPut(() => CreateBillingProductUseCase(repository()));
    Get.lazyPut(() => CreateBillingPlanUseCase(repository()));
    Get.lazyPut(() => CreateBillingDraftVersionUseCase(repository()));
    Get.lazyPut(() => AddBillingPlanPriceUseCase(repository()));
    Get.lazyPut(() => AddBillingPlanFeatureUseCase(repository()));
    Get.lazyPut(() => PublishBillingPlanVersionUseCase(repository()));
    Get.lazyPut(() => GetBillingPlanVersionsUseCase(repository()));
    Get.lazyPut(() => GetBillingTrialPoliciesUseCase(repository()));
    Get.lazyPut(() => GetBillingTrialPolicyVersionsUseCase(repository()));
    Get.lazyPut(() => GetBillingDunningPoliciesUseCase(repository()));
    Get.lazyPut(() => GetBillingDunningPolicyVersionsUseCase(repository()));
    Get.lazyPut(() => GetBillingPendingTrialRedemptionsUseCase(repository()));
    Get.lazyPut(() => CreateBillingTrialPolicyUseCase(repository()));
    Get.lazyPut(() => CreateBillingDunningPolicyUseCase(repository()));
    Get.lazyPut(() => CreateBillingTrialPolicyVersionUseCase(repository()));
    Get.lazyPut(() => CreateBillingDunningPolicyVersionUseCase(repository()));
    Get.lazyPut(() => PublishBillingTrialPolicyVersionUseCase(repository()));
    Get.lazyPut(() => PublishBillingDunningPolicyVersionUseCase(repository()));
    Get.lazyPut(() => AssignBillingPlanPoliciesUseCase(repository()));
    Get.lazyPut(() => AssignBillingPricePoliciesUseCase(repository()));
    Get.lazyPut(() => ApproveBillingTrialRedemptionUseCase(repository()));
    Get.lazyPut(() => RejectBillingTrialRedemptionUseCase(repository()));
    Get.lazyPut(() => AdjustBillingSubscriptionTrialUseCase(repository()));
    Get.lazyPut(() => GetBillingAccountsUseCase(repository()));
    Get.lazyPut(() => GetBillingSubscriptionsUseCase(repository()));
    Get.lazyPut(() => GetBillingSubscriptionUseCase(repository()));
    Get.lazyPut(() => GetBillingInvoicesUseCase(repository()));
    Get.lazyPut(() => GetBillingPaymentsUseCase(repository()));
    Get.lazyPut(() => GetBillingTreasuryAccountsUseCase(repository()));
    Get.lazyPut(() => GetBillingJournalEntriesUseCase(repository()));
    Get.lazyPut(() => GetBillingExchangeRatesUseCase(repository()));
    Get.lazyPut(() => GetBillingConversionsUseCase(repository()));
    Get.lazyPut(() => CreateBillingAccountUseCase(repository()));
    Get.lazyPut(() => CreateBillingSubscriptionUseCase(repository()));
    Get.lazyPut(() => CancelBillingSubscriptionUseCase(repository()));
    Get.lazyPut(() => VerifyBillingPaymentUseCase(repository()));
    Get.lazyPut(() => RejectBillingPaymentUseCase(repository()));

    Get.lazyPut<PlatformBillingController>(
      () => PlatformBillingController(
        getOverview: Get.find<GetBillingOverviewUseCase>(),
        getCurrencies: Get.find<GetBillingCurrenciesUseCase>(),
        getPlans: Get.find<GetBillingPlansUseCase>(),
        getProducts: Get.find<GetBillingProductsUseCase>(),
        createProduct: Get.find<CreateBillingProductUseCase>(),
        createPlan: Get.find<CreateBillingPlanUseCase>(),
        createDraftVersion: Get.find<CreateBillingDraftVersionUseCase>(),
        addPlanPrice: Get.find<AddBillingPlanPriceUseCase>(),
        addPlanFeature: Get.find<AddBillingPlanFeatureUseCase>(),
        publishPlanVersion: Get.find<PublishBillingPlanVersionUseCase>(),
        getPlanVersions: Get.find<GetBillingPlanVersionsUseCase>(),
        getTrialPolicies: Get.find<GetBillingTrialPoliciesUseCase>(),
        getTrialPolicyVersions: Get.find<GetBillingTrialPolicyVersionsUseCase>(),
        getDunningPolicies: Get.find<GetBillingDunningPoliciesUseCase>(),
        getDunningPolicyVersions: Get.find<GetBillingDunningPolicyVersionsUseCase>(),
        getPendingTrialRedemptions: Get.find<GetBillingPendingTrialRedemptionsUseCase>(),
        createTrialPolicy: Get.find<CreateBillingTrialPolicyUseCase>(),
        createDunningPolicy: Get.find<CreateBillingDunningPolicyUseCase>(),
        createTrialPolicyVersion: Get.find<CreateBillingTrialPolicyVersionUseCase>(),
        createDunningPolicyVersion: Get.find<CreateBillingDunningPolicyVersionUseCase>(),
        publishTrialPolicyVersion: Get.find<PublishBillingTrialPolicyVersionUseCase>(),
        publishDunningPolicyVersion: Get.find<PublishBillingDunningPolicyVersionUseCase>(),
        assignPlanPolicies: Get.find<AssignBillingPlanPoliciesUseCase>(),
        assignPricePolicies: Get.find<AssignBillingPricePoliciesUseCase>(),
        approveTrialRedemption: Get.find<ApproveBillingTrialRedemptionUseCase>(),
        rejectTrialRedemption: Get.find<RejectBillingTrialRedemptionUseCase>(),
        adjustSubscriptionTrial: Get.find<AdjustBillingSubscriptionTrialUseCase>(),
        getSubscriptions: Get.find<GetBillingSubscriptionsUseCase>(),
        getInvoices: Get.find<GetBillingInvoicesUseCase>(),
        getPayments: Get.find<GetBillingPaymentsUseCase>(),
        getTreasuryAccounts: Get.find<GetBillingTreasuryAccountsUseCase>(),
      ),
    );
  }
}
