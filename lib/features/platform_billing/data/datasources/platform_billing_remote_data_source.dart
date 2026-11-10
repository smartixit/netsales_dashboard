import 'package:netsales_dashboard/core/models/api_response.dart';

abstract interface class PlatformBillingRemoteDataSource {
  Future<ApiResponse<Map<String, dynamic>>> getOverview({int? currencyId});
  Future<ApiResponse<List<Map<String, dynamic>>>> getCurrencies();
  Future<ApiResponse<List<Map<String, dynamic>>>> getPlans({String? search, String? status, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getPlanVersions(int planId, {String? status, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getAccounts({int? networkId, int? currencyId, String? status, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getSubscriptions({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<Map<String, dynamic>>> getSubscription(int id);
  Future<ApiResponse<List<Map<String, dynamic>>>> getInvoices({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getPayments({int? networkId, int? accountId, int? invoiceId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getTreasuryAccounts({int? currencyId, String? status, String? search, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getJournalEntries({int? currencyId, String? sourceType, String? fromDate, String? toDate, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getExchangeRates({int? baseCurrencyId, int? quoteCurrencyId, String? cursor, int perPage = 20});
  Future<ApiResponse<List<Map<String, dynamic>>>> getConversions({int? fromCurrencyId, int? toCurrencyId, String? cursor, int perPage = 20});
  Future<ApiResponse<Map<String, dynamic>>> createBillingAccount({required int networkId, required int currencyId});
  Future<ApiResponse<Map<String, dynamic>>> createSubscription({required int accountId, required int priceId});
  Future<ApiResponse<Map<String, dynamic>>> cancelSubscription(int id, {required bool atPeriodEnd, required String reason});
  Future<ApiResponse<Map<String, dynamic>>> verifyPayment(int id, {required int treasuryAccountId, String? note});
  Future<ApiResponse<Map<String, dynamic>>> rejectPayment(int id, {required String reason});
  Future<ApiResponse<Map<String, dynamic>>> createTreasuryAccount(Map<String, dynamic> data);
  Future<ApiResponse<Map<String, dynamic>>> setTreasuryStatus(int id, String status);
}
