import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_billing/data/datasources/platform_billing_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_billing/data/models/platform_billing_models.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/repositories/platform_billing_repository.dart';

class PlatformBillingRepositoryImpl implements PlatformBillingRepository {
  const PlatformBillingRepositoryImpl(this._remote);
  final PlatformBillingRemoteDataSource _remote;

  ApiResponse<T> _mapResponse<S, T>(
    ApiResponse<S> source,
    T? Function(S? value) mapper,
  ) => ApiResponse<T>(
    success: source.success,
    message: source.message,
    data: mapper(source.data),
    errors: source.errors,
    nextCursor: source.nextCursor,
    prevCursor: source.prevCursor,
    meta: source.meta,
    isIdempotentHit: source.isIdempotentHit,
    idempotencyKey: source.idempotencyKey,
  );

  ApiResponse<List<T>> _mapList<T>(
    ApiResponse<List<Map<String, dynamic>>> source,
    T Function(Map<String, dynamic>) mapper,
  ) => _mapResponse(source, (items) => items?.map(mapper).toList(growable: false));

  Map<String, dynamic> _unwrap(Map<String, dynamic>? data, [String? key]) {
    if (data == null) return const {};
    final value = key == null ? data : data[key];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return data;
  }

  @override
  Future<ApiResponse<BillingOverviewEntity>> getOverview({int? currencyId}) async =>
      _mapResponse(await _remote.getOverview(currencyId: currencyId),
          (data) => data == null ? null : BillingOverviewModel.fromJson(data));

  @override
  Future<ApiResponse<List<BillingCurrencyEntity>>> getCurrencies() async =>
      _mapList(await _remote.getCurrencies(), BillingCurrencyModel.fromJson);

  @override
  Future<ApiResponse<List<BillingPlanEntity>>> getPlans({String? search, String? status, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getPlans(search: search, status: status, cursor: cursor, perPage: perPage), BillingPlanModel.fromJson);

  @override
  Future<ApiResponse<List<BillingAccountEntity>>> getAccounts({int? networkId, int? currencyId, String? status, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getAccounts(networkId: networkId, currencyId: currencyId, status: status, cursor: cursor, perPage: perPage), BillingAccountModel.fromJson);

  @override
  Future<ApiResponse<List<BillingSubscriptionEntity>>> getSubscriptions({int? networkId, int? accountId, int? currencyId, String? status, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getSubscriptions(networkId: networkId, accountId: accountId, currencyId: currencyId, status: status, cursor: cursor, perPage: perPage), BillingSubscriptionModel.fromJson);

  @override
  Future<ApiResponse<BillingSubscriptionEntity>> getSubscription(int id) async =>
      _mapResponse(await _remote.getSubscription(id), (data) {
        if (data == null) return null;
        final subscription = _unwrap(data, 'subscription');
        final events = data['events'] is List
            ? (data['events'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList(growable: false)
            : const <Map<String, dynamic>>[];
        return BillingSubscriptionModel.fromJson(subscription, events: events);
      });

  @override
  Future<ApiResponse<List<BillingInvoiceEntity>>> getInvoices({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getInvoices(networkId: networkId, accountId: accountId, currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage), BillingInvoiceModel.fromJson);

  @override
  Future<ApiResponse<List<BillingPaymentEntity>>> getPayments({int? networkId, int? accountId, int? invoiceId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getPayments(networkId: networkId, accountId: accountId, invoiceId: invoiceId, currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage), BillingPaymentModel.fromJson);

  @override
  Future<ApiResponse<List<BillingTreasuryAccountEntity>>> getTreasuryAccounts({int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getTreasuryAccounts(currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage), BillingTreasuryAccountModel.fromJson);

  @override
  Future<ApiResponse<List<BillingJournalEntryEntity>>> getJournalEntries({int? currencyId, String? sourceType, String? fromDate, String? toDate, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getJournalEntries(currencyId: currencyId, sourceType: sourceType, fromDate: fromDate, toDate: toDate, cursor: cursor, perPage: perPage), BillingJournalEntryModel.fromJson);

  @override
  Future<ApiResponse<List<BillingExchangeRateEntity>>> getExchangeRates({int? baseCurrencyId, int? quoteCurrencyId, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getExchangeRates(baseCurrencyId: baseCurrencyId, quoteCurrencyId: quoteCurrencyId, cursor: cursor, perPage: perPage), BillingExchangeRateModel.fromJson);

  @override
  Future<ApiResponse<List<BillingConversionEntity>>> getConversions({int? fromCurrencyId, int? toCurrencyId, String? cursor, int perPage = 20}) async =>
      _mapList(await _remote.getConversions(fromCurrencyId: fromCurrencyId, toCurrencyId: toCurrencyId, cursor: cursor, perPage: perPage), BillingConversionModel.fromJson);

  @override
  Future<ApiResponse<BillingAccountEntity>> createBillingAccount({required int networkId, required int currencyId}) async =>
      _mapResponse(await _remote.createBillingAccount(networkId: networkId, currencyId: currencyId),
          (data) => data == null ? null : BillingAccountModel.fromJson(_unwrap(data, 'billing_account')));

  @override
  Future<ApiResponse<BillingSubscriptionEntity>> createSubscription({required int accountId, required int priceId}) async =>
      _mapResponse(await _remote.createSubscription(accountId: accountId, priceId: priceId),
          (data) => data == null ? null : BillingSubscriptionModel.fromJson(_unwrap(data, 'subscription')));

  @override
  Future<ApiResponse<BillingSubscriptionEntity>> cancelSubscription(int id, {required bool atPeriodEnd, required String reason}) async =>
      _mapResponse(await _remote.cancelSubscription(id, atPeriodEnd: atPeriodEnd, reason: reason),
          (data) => data == null ? null : BillingSubscriptionModel.fromJson(_unwrap(data, 'subscription')));

  @override
  Future<ApiResponse<BillingPaymentEntity>> verifyPayment(int id, {required int treasuryAccountId, String? note}) async =>
      _mapResponse(await _remote.verifyPayment(id, treasuryAccountId: treasuryAccountId, note: note),
          (data) => data == null ? null : BillingPaymentModel.fromJson(_unwrap(data, 'payment')));

  @override
  Future<ApiResponse<BillingPaymentEntity>> rejectPayment(int id, {required String reason}) async =>
      _mapResponse(await _remote.rejectPayment(id, reason: reason),
          (data) => data == null ? null : BillingPaymentModel.fromJson(_unwrap(data, 'payment')));

  @override
  Future<ApiResponse<BillingTreasuryAccountEntity>> createTreasuryAccount(Map<String, dynamic> data) async =>
      _mapResponse(await _remote.createTreasuryAccount(data),
          (value) => value == null ? null : BillingTreasuryAccountModel.fromJson(_unwrap(value, 'treasury_account')));

  @override
  Future<ApiResponse<BillingTreasuryAccountEntity>> setTreasuryStatus(int id, String status) async =>
      _mapResponse(await _remote.setTreasuryStatus(id, status),
          (data) => data == null ? null : BillingTreasuryAccountModel.fromJson(_unwrap(data, 'treasury_account')));
}
