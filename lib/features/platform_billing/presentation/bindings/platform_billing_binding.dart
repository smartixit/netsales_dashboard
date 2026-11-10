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
        getSubscriptions: Get.find<GetBillingSubscriptionsUseCase>(),
        getInvoices: Get.find<GetBillingInvoicesUseCase>(),
        getPayments: Get.find<GetBillingPaymentsUseCase>(),
        getTreasuryAccounts: Get.find<GetBillingTreasuryAccountsUseCase>(),
      ),
    );
  }
}
