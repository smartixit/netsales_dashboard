import 'package:netsales_dashboard/core/constants/api_constants.dart';
import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/core/services/api_service.dart';
import 'package:netsales_dashboard/features/platform_billing/data/datasources/platform_billing_remote_data_source.dart';

class PlatformBillingRemoteDataSourceImpl implements PlatformBillingRemoteDataSource {
  PlatformBillingRemoteDataSourceImpl({ApiService? apiService}) : _api = apiService ?? ApiService.instance;
  final ApiService _api;

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const FormatException('Unexpected billing API resource payload.');
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> _list(
    String path, {
    Map<String, dynamic> filters = const {},
    String? cursor,
    int perPage = 20,
  }) => _api.getList<Map<String, dynamic>>(
    path,
    fromJson: _map,
    queryParameters: {...filters, 'per_page': perPage},
    cursor: cursor,
    perPage: perPage,
  );

  Future<ApiResponse<Map<String, dynamic>>> _get(String path, {Map<String, dynamic>? query}) =>
      _api.get<Map<String, dynamic>>(path, fromJson: _map, queryParameters: query);

  @override
  Future<ApiResponse<Map<String, dynamic>>> getOverview({int? currencyId}) =>
      _get(ApiConstants.billingOverview, query: {'currency_id': ?currencyId});

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getCurrencies() =>
      _list(ApiConstants.billingCurrencies, perPage: 100);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getPlans({String? search, String? status, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingPlans, filters: {
        if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
        if (status?.isNotEmpty == true) 'status': status,
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getPlanVersions(int planId, {String? status, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingPlanVersions(planId), filters: {if (status?.isNotEmpty == true) 'status': status}, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getAccounts({int? networkId, int? currencyId, String? status, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingAccounts, filters: {
        'network_id': ?networkId, 'currency_id': ?currencyId,
        if (status?.isNotEmpty == true) 'status': status,
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getSubscriptions({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingSubscriptions, filters: {
        'network_id': ?networkId, 'billing_account_id': ?accountId, 'currency_id': ?currencyId,
        if (status?.isNotEmpty == true) 'status': status,
        if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<Map<String, dynamic>>> getSubscription(int id) =>
      _get(ApiConstants.billingSubscription(id));

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getInvoices({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingInvoices, filters: {
        'network_id': ?networkId, 'billing_account_id': ?accountId, 'currency_id': ?currencyId,
        if (status?.isNotEmpty == true) 'status': status,
        if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getPayments({int? networkId, int? accountId, int? invoiceId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingPayments, filters: {
        'network_id': ?networkId, 'billing_account_id': ?accountId, 'invoice_id': ?invoiceId, 'currency_id': ?currencyId,
        if (status?.isNotEmpty == true) 'status': status,
        if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getTreasuryAccounts({int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingTreasuryAccounts, filters: {
        'currency_id': ?currencyId,
        if (status?.isNotEmpty == true) 'status': status,
        if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getJournalEntries({int? currencyId, String? sourceType, String? fromDate, String? toDate, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingJournalEntries, filters: {
        'currency_id': ?currencyId,
        if (sourceType?.isNotEmpty == true) 'source_type': sourceType,
        if (fromDate?.isNotEmpty == true) 'from_date': fromDate,
        if (toDate?.isNotEmpty == true) 'to_date': toDate,
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getExchangeRates({int? baseCurrencyId, int? quoteCurrencyId, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingExchangeRates, filters: {
        'base_currency_id': ?baseCurrencyId, 'quote_currency_id': ?quoteCurrencyId,
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getConversions({int? fromCurrencyId, int? toCurrencyId, String? cursor, int perPage = 20}) =>
      _list(ApiConstants.billingConversions, filters: {
        'from_currency_id': ?fromCurrencyId, 'to_currency_id': ?toCurrencyId,
      }, cursor: cursor, perPage: perPage);

  @override
  Future<ApiResponse<Map<String, dynamic>>> createBillingAccount({required int networkId, required int currencyId}) =>
      _api.post<Map<String, dynamic>>(ApiConstants.billingAccounts, data: {
        'network_id': networkId, 'currency_id': currencyId,
      }, fromJson: _map);

  @override
  Future<ApiResponse<Map<String, dynamic>>> createSubscription({required int accountId, required int priceId}) =>
      _api.post<Map<String, dynamic>>(ApiConstants.billingSubscriptions, data: {
        'billing_account_id': accountId, 'price_id': priceId,
      }, fromJson: _map);

  @override
  Future<ApiResponse<Map<String, dynamic>>> cancelSubscription(int id, {required bool atPeriodEnd, required String reason}) =>
      _api.post<Map<String, dynamic>>(ApiConstants.billingSubscriptionCancel(id), data: {
        'cancel_at_period_end': atPeriodEnd, 'reason': reason,
      }, fromJson: _map);

  @override
  Future<ApiResponse<Map<String, dynamic>>> verifyPayment(int id, {required int treasuryAccountId, String? note}) =>
      _api.post<Map<String, dynamic>>(ApiConstants.billingVerifyPayment(id), data: {
        'treasury_account_id': treasuryAccountId, if (note?.trim().isNotEmpty == true) 'note': note!.trim(),
      }, fromJson: _map);

  @override
  Future<ApiResponse<Map<String, dynamic>>> rejectPayment(int id, {required String reason}) =>
      _api.post<Map<String, dynamic>>(ApiConstants.billingRejectPayment(id), data: {'reason': reason}, fromJson: _map);

  @override
  Future<ApiResponse<Map<String, dynamic>>> createTreasuryAccount(Map<String, dynamic> data) =>
      _api.post<Map<String, dynamic>>(ApiConstants.billingTreasuryAccounts, data: data, fromJson: _map);

  @override
  Future<ApiResponse<Map<String, dynamic>>> setTreasuryStatus(int id, String status) =>
      _api.patch<Map<String, dynamic>>('/platform/billing/treasury-accounts/$id/status', data: {'status': status}, fromJson: _map);
}
