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

class GetBillingProductsUseCase {
  const GetBillingProductsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingProductEntity>>> call({String? search, String? cursor, int perPage = 20}) =>
      _repository.getProducts(search: search, cursor: cursor, perPage: perPage);
}

class CreateBillingProductUseCase {
  const CreateBillingProductUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingProductEntity>> call(Map<String, dynamic> data) => _repository.createProduct(data);
}

class CreateBillingPlanUseCase {
  const CreateBillingPlanUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingPlanEntity>> call(Map<String, dynamic> data) => _repository.createPlan(data);
}

class CreateBillingDraftVersionUseCase {
  const CreateBillingDraftVersionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingPlanVersionEntity>> call(
    int planId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) => _repository.createDraftVersion(
    planId,
    trialPolicyVersionId: trialPolicyVersionId,
    dunningPolicyVersionId: dunningPolicyVersionId,
  );
}

class AddBillingPlanPriceUseCase {
  const AddBillingPlanPriceUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingPriceEntity>> call(int versionId, Map<String, dynamic> data) =>
      _repository.addPlanPrice(versionId, data);
}

class AddBillingPlanFeatureUseCase {
  const AddBillingPlanFeatureUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingFeatureEntity>> call(int versionId, Map<String, dynamic> data) =>
      _repository.addPlanFeature(versionId, data);
}

class PublishBillingPlanVersionUseCase {
  const PublishBillingPlanVersionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<BillingPlanEntity>> call(int versionId) => _repository.publishPlanVersion(versionId);
}

class GetBillingTrialPoliciesUseCase {
  const GetBillingTrialPoliciesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingTrialPolicyEntity>>> call({String? search, String? cursor, int perPage = 20}) =>
      _repository.getTrialPolicies(search: search, cursor: cursor, perPage: perPage);
}

class GetBillingTrialPolicyVersionsUseCase {
  const GetBillingTrialPolicyVersionsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingTrialPolicyVersionEntity>>> call(int policyId, {String? cursor, int perPage = 20}) =>
      _repository.getTrialPolicyVersions(policyId, cursor: cursor, perPage: perPage);
}

class GetBillingDunningPoliciesUseCase {
  const GetBillingDunningPoliciesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingDunningPolicyEntity>>> call({String? search, String? cursor, int perPage = 20}) =>
      _repository.getDunningPolicies(search: search, cursor: cursor, perPage: perPage);
}

class GetBillingDunningPolicyVersionsUseCase {
  const GetBillingDunningPolicyVersionsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingDunningPolicyVersionEntity>>> call(int policyId, {String? cursor, int perPage = 20}) =>
      _repository.getDunningPolicyVersions(policyId, cursor: cursor, perPage: perPage);
}

class GetBillingPendingTrialRedemptionsUseCase {
  const GetBillingPendingTrialRedemptionsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingTrialRedemptionEntity>>> call({String? cursor, int perPage = 20}) =>
      _repository.getPendingTrialRedemptions(cursor: cursor, perPage: perPage);
}

class CreateBillingTrialPolicyUseCase {
  const CreateBillingTrialPolicyUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(Map<String, dynamic> data) => _repository.createTrialPolicy(data);
}

class CreateBillingDunningPolicyUseCase {
  const CreateBillingDunningPolicyUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(Map<String, dynamic> data) => _repository.createDunningPolicy(data);
}

class CreateBillingTrialPolicyVersionUseCase {
  const CreateBillingTrialPolicyVersionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(int policyId, Map<String, dynamic> data) =>
      _repository.createTrialPolicyVersion(policyId, data);
}

class CreateBillingDunningPolicyVersionUseCase {
  const CreateBillingDunningPolicyVersionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(int policyId, Map<String, dynamic> data) =>
      _repository.createDunningPolicyVersion(policyId, data);
}

class PublishBillingTrialPolicyVersionUseCase {
  const PublishBillingTrialPolicyVersionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(int versionId) => _repository.publishTrialPolicyVersion(versionId);
}

class PublishBillingDunningPolicyVersionUseCase {
  const PublishBillingDunningPolicyVersionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(int versionId) => _repository.publishDunningPolicyVersion(versionId);
}

class AssignBillingPlanPoliciesUseCase {
  const AssignBillingPlanPoliciesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(
    int versionId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) => _repository.assignPlanVersionPolicies(
    versionId,
    trialPolicyVersionId: trialPolicyVersionId,
    dunningPolicyVersionId: dunningPolicyVersionId,
  );
}

class AssignBillingPricePoliciesUseCase {
  const AssignBillingPricePoliciesUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(
    int priceId, {
    int? trialPolicyVersionId,
    int? dunningPolicyVersionId,
  }) => _repository.assignPricePolicies(
    priceId,
    trialPolicyVersionId: trialPolicyVersionId,
    dunningPolicyVersionId: dunningPolicyVersionId,
  );
}

class ApproveBillingTrialRedemptionUseCase {
  const ApproveBillingTrialRedemptionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(int redemptionId) =>
      _repository.approveTrialRedemption(redemptionId);
}

class RejectBillingTrialRedemptionUseCase {
  const RejectBillingTrialRedemptionUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(int redemptionId, {required String reason}) =>
      _repository.rejectTrialRedemption(redemptionId, reason: reason);
}

class AdjustBillingSubscriptionTrialUseCase {
  const AdjustBillingSubscriptionTrialUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<Map<String, dynamic>>> call(
    int subscriptionId, {
    required String adjustmentType,
    int? days,
    required String reason,
  }) => _repository.adjustSubscriptionTrial(
    subscriptionId,
    adjustmentType: adjustmentType,
    days: days,
    reason: reason,
  );
}

class GetBillingPlanVersionsUseCase {
  const GetBillingPlanVersionsUseCase(this._repository);
  final PlatformBillingRepository _repository;
  Future<ApiResponse<List<BillingPlanVersionEntity>>> call(int planId, {String? status, String? cursor, int perPage = 20}) =>
      _repository.getPlanVersions(planId, status: status, cursor: cursor, perPage: perPage);
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
