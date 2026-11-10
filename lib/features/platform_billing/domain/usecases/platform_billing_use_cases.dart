import 'package:netsales_dashboard/core/models/api_response.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/repositories/platform_billing_repository.dart';

class GetBillingOverviewUseCase {
  const GetBillingOverviewUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingOverviewEntity>> call({int? currencyId}) => _repository.getOverview(currencyId: currencyId);
}

class GetBillingCurrenciesUseCase {
  const GetBillingCurrenciesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingCurrencyEntity>>> call() => _repository.getCurrencies();
}

class GetBillingPlansUseCase {
  const GetBillingPlansUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingPlanEntity>>> call({String? search, String? status, String? cursor, int perPage = 20}) =>
      _repository.getPlans(search: search, status: status, cursor: cursor, perPage: perPage);
}

class GetBillingAccountsUseCase {
  const GetBillingAccountsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingAccountEntity>>> call({int? networkId, int? currencyId, String? status, String? cursor, int perPage = 20}) =>
      _repository.getAccounts(networkId: networkId, currencyId: currencyId, status: status, cursor: cursor, perPage: perPage);
}

class GetBillingSubscriptionsUseCase {
  const GetBillingSubscriptionsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingSubscriptionEntity>>> call({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _repository.getSubscriptions(networkId: networkId, accountId: accountId, currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage);
}

class GetBillingSubscriptionUseCase {
  const GetBillingSubscriptionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingSubscriptionEntity>> call(int id) => _repository.getSubscription(id);
}

class GetBillingInvoicesUseCase {
  const GetBillingInvoicesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingInvoiceEntity>>> call({int? networkId, int? accountId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _repository.getInvoices(networkId: networkId, accountId: accountId, currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage);
}

class GetBillingPaymentsUseCase {
  const GetBillingPaymentsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingPaymentEntity>>> call({int? networkId, int? accountId, int? invoiceId, int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _repository.getPayments(networkId: networkId, accountId: accountId, invoiceId: invoiceId, currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage);
}

class GetBillingTreasuryAccountsUseCase {
  const GetBillingTreasuryAccountsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingTreasuryAccountEntity>>> call({int? currencyId, String? status, String? search, String? cursor, int perPage = 20}) =>
      _repository.getTreasuryAccounts(currencyId: currencyId, status: status, search: search, cursor: cursor, perPage: perPage);
}

class GetBillingJournalEntriesUseCase {
  const GetBillingJournalEntriesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingJournalEntryEntity>>> call({int? currencyId, String? sourceType, String? fromDate, String? toDate, String? cursor, int perPage = 20}) =>
      _repository.getJournalEntries(currencyId: currencyId, sourceType: sourceType, fromDate: fromDate, toDate: toDate, cursor: cursor, perPage: perPage);
}

class GetBillingExchangeRatesUseCase {
  const GetBillingExchangeRatesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingExchangeRateEntity>>> call({int? baseCurrencyId, int? quoteCurrencyId, String? cursor, int perPage = 20}) =>
      _repository.getExchangeRates(baseCurrencyId: baseCurrencyId, quoteCurrencyId: quoteCurrencyId, cursor: cursor, perPage: perPage);
}

class GetBillingConversionsUseCase {
  const GetBillingConversionsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingConversionEntity>>> call({int? fromCurrencyId, int? toCurrencyId, String? cursor, int perPage = 20}) =>
      _repository.getConversions(fromCurrencyId: fromCurrencyId, toCurrencyId: toCurrencyId, cursor: cursor, perPage: perPage);
}

class CreateBillingAccountUseCase {
  const CreateBillingAccountUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingAccountEntity>> call({required int networkId, required int currencyId}) =>
      _repository.createBillingAccount(networkId: networkId, currencyId: currencyId);
}

class CreateBillingSubscriptionUseCase {
  const CreateBillingSubscriptionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingSubscriptionEntity>> call({required int accountId, required int priceId}) =>
      _repository.createSubscription(accountId: accountId, priceId: priceId);
}

class CancelBillingSubscriptionUseCase {
  const CancelBillingSubscriptionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingSubscriptionEntity>> call(int id, {required bool atPeriodEnd, required String reason}) =>
      _repository.cancelSubscription(id, atPeriodEnd: atPeriodEnd, reason: reason);
}

class VerifyBillingPaymentUseCase {
  const VerifyBillingPaymentUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingPaymentEntity>> call(int id, {required int treasuryAccountId, String? note}) =>
      _repository.verifyPayment(id, treasuryAccountId: treasuryAccountId, note: note);
}

class RejectBillingPaymentUseCase {
  const RejectBillingPaymentUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingPaymentEntity>> call(int id, {required String reason}) =>
      _repository.rejectPayment(id, reason: reason);
}
