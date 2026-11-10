import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';

abstract interface class PlatformBillingRepository {
  Future<ApiResponse<BillingOverviewEntity>> getOverview({int? currencyId});
  Future<ApiResponse<List<BillingCurrencyEntity>>> getCurrencies();
  Future<ApiResponse<List<BillingPlanEntity>>> getPlans({String? search, String? status, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingAccountEntity>>> getAccounts({int? networkId, int? currencyId, String? status, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingSubscriptionEntity>>> getSubscriptions({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<BillingSubscriptionEntity>> getSubscription(int id);
  Future<ApiResponse<List<BillingInvoiceEntity>>> getInvoices({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingPaymentEntity>>> getPayments({int? networkId, int? accountId, int? invoiceId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingTreasuryAccountEntity>>> getTreasuryAccounts({int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingJournalEntryEntity>>> getJournalEntries({int? currencyId, String? sourceType, String? fromDate, String? toDate, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingExchangeRateEntity>>> getExchangeRates({int? baseCurrencyId, int? quoteCurrencyId, String? cursor, int perPage = 20});
  Future<ApiResponse<List<BillingConversionEntity>>> getConversions({int? fromCurrencyId, int? toCurrencyId, String? cursor, int perPage = 20});
  Future<ApiResponse<BillingAccountEntity>> createBillingAccount({required int networkId, required int currencyId});
  Future<ApiResponse<BillingSubscriptionEntity>> createSubscription({required int accountId, required int priceId});
  Future<ApiResponse<BillingSubscriptionEntity>> cancelSubscription(int id, {required bool atPeriodEnd, required String reason});
  Future<ApiResponse<BillingPaymentEntity>> verifyPayment(int id, {required int treasuryAccountId, String? note});
  Future<ApiResponse<BillingPaymentEntity>> rejectPayment(int id, {required String reason});
  Future<ApiResponse<BillingTreasuryAccountEntity>> createTreasuryAccount(Map<String, dynamic> data);
  Future<ApiResponse<BillingTreasuryAccountEntity>> setTreasuryStatus(int id, String status);
}
