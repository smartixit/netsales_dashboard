/// Pure domain contracts for the Platform Billing bounded context.
enum BillingSubscriptionStatus {
  incomplete, trialing, active, pastDue, paused, suspended, canceled, expired, unknown;

  static BillingSubscriptionStatus fromWire(String? value) => switch (value) {
    'INCOMPLETE' => BillingSubscriptionStatus.incomplete,
    'TRIALING' => BillingSubscriptionStatus.trialing,
    'ACTIVE' => BillingSubscriptionStatus.active,
    'PAST_DUE' => BillingSubscriptionStatus.pastDue,
    'PAUSED' => BillingSubscriptionStatus.paused,
    'SUSPENDED' => BillingSubscriptionStatus.suspended,
    'CANCELED' => BillingSubscriptionStatus.canceled,
    'EXPIRED' => BillingSubscriptionStatus.expired,
    _ => BillingSubscriptionStatus.unknown,
  };
}

enum BillingInvoiceStatus {
  draft, open, partiallyPaid, partiallyCredited, credited, paid, uncollectible, voided, unknown;

  static BillingInvoiceStatus fromWire(String? value) => switch (value) {
    'DRAFT' => BillingInvoiceStatus.draft,
    'OPEN' => BillingInvoiceStatus.open,
    'PARTIALLY_PAID' => BillingInvoiceStatus.partiallyPaid,
    'PARTIALLY_CREDITED' => BillingInvoiceStatus.partiallyCredited,
    'CREDITED' => BillingInvoiceStatus.credited,
    'PAID' => BillingInvoiceStatus.paid,
    'UNCOLLECTIBLE' => BillingInvoiceStatus.uncollectible,
    'VOID' => BillingInvoiceStatus.voided,
    _ => BillingInvoiceStatus.unknown,
  };
}

enum BillingPaymentStatus {
  pendingReview, verified, rejected, refunded, partiallyRefunded, unknown;

  static BillingPaymentStatus fromWire(String? value) => switch (value) {
    'PENDING_REVIEW' => BillingPaymentStatus.pendingReview,
    'VERIFIED' => BillingPaymentStatus.verified,
    'REJECTED' => BillingPaymentStatus.rejected,
    'REFUNDED' => BillingPaymentStatus.refunded,
    'PARTIALLY_REFUNDED' => BillingPaymentStatus.partiallyRefunded,
    _ => BillingPaymentStatus.unknown,
  };
}

enum BillingPlanVersionStatus {
  draft, published, archived, unknown;

  static BillingPlanVersionStatus fromWire(String? value) => switch (value) {
    'DRAFT' => BillingPlanVersionStatus.draft,
    'PUBLISHED' => BillingPlanVersionStatus.published,
    'ARCHIVED' => BillingPlanVersionStatus.archived,
    _ => BillingPlanVersionStatus.unknown,
  };
}

class BillingCurrencyEntity {
  const BillingCurrencyEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.decimalPlaces,
    this.numericCode,
    this.nativeName,
    this.symbol,
    this.isActive = false,
  });

  final int id;
  final String code;
  final String name;
  final int decimalPlaces;
  final String? numericCode;
  final String? nativeName;
  final String? symbol;
  final bool isActive;
}

class BillingPriceEntity {
  const BillingPriceEntity({
    required this.id,
    required this.currencyId,
    required this.billingInterval,
    required this.intervalCount,
    required this.unitAmountMinor,
    required this.setupFeeMinor,
    required this.isActive,
    this.currency,
  });

  final int id;
  final int currencyId;
  final String billingInterval;
  final int intervalCount;
  final int unitAmountMinor;
  final int setupFeeMinor;
  final bool isActive;
  final BillingCurrencyEntity? currency;
}

class BillingFeatureEntity {
  const BillingFeatureEntity({
    required this.id,
    required this.key,
    required this.name,
    required this.type,
    this.value,
    this.unit,
  });

  final int id;
  final String key;
  final String name;
  final String type;
  final String? value;
  final String? unit;
}

class BillingTrialPolicySummaryEntity {
  const BillingTrialPolicySummaryEntity({
    required this.isEnabled,
    required this.durationValue,
    required this.durationUnit,
    this.policyKey,
  });

  final bool isEnabled;
  final int durationValue;
  final String durationUnit;
  final String? policyKey;
}

class BillingPlanVersionEntity {
  const BillingPlanVersionEntity({
    required this.id,
    required this.versionNumber,
    required this.status,
    this.statusLabel,
    this.trialPolicy,
    this.dunningPolicyVersionId,
    this.prices = const [],
    this.features = const [],
  });

  final int id;
  final int versionNumber;
  final String status;
  final String? statusLabel;
  final BillingTrialPolicySummaryEntity? trialPolicy;
  final int? dunningPolicyVersionId;
  final List<BillingPriceEntity> prices;
  final List<BillingFeatureEntity> features;

  BillingPlanVersionStatus get typedStatus => BillingPlanVersionStatus.fromWire(status);
}

class BillingPlanEntity {
  const BillingPlanEntity({
    required this.id,
    required this.key,
    required this.name,
    required this.isPublic,
    required this.isActive,
    this.description,
    this.productName,
    this.currentVersion,
  });

  final int id;
  final String key;
  final String name;
  final String? description;
  final bool isPublic;
  final bool isActive;
  final String? productName;
  final BillingPlanVersionEntity? currentVersion;
}

class BillingAccountEntity {
  const BillingAccountEntity({
    required this.id,
    required this.accountNumber,
    required this.networkId,
    required this.status,
    required this.paymentTermsDays,
    this.networkName,
    this.legalName,
    this.billingEmail,
    this.taxNumber,
    this.billingAddress,
    this.defaultCurrency,
  });

  final int id;
  final String accountNumber;
  final int networkId;
  final String status;
  final int paymentTermsDays;
  final String? networkName;
  final String? legalName;
  final String? billingEmail;
  final String? taxNumber;
  final String? billingAddress;
  final BillingCurrencyEntity? defaultCurrency;
}

class BillingSubscriptionEventEntity {
  const BillingSubscriptionEventEntity({
    required this.id,
    required this.type,
    required this.occurredAt,
    this.fromStatus,
    this.toStatus,
    this.actorId,
    this.reason,
  });

  final int id;
  final String type;
  final DateTime? occurredAt;
  final String? fromStatus;
  final String? toStatus;
  final int? actorId;
  final String? reason;
}

class BillingSubscriptionEntity {
  const BillingSubscriptionEntity({
    required this.id,
    required this.accountId,
    required this.planId,
    required this.planVersionId,
    required this.priceId,
    required this.status,
    required this.quantity,
    required this.cancelAtPeriodEnd,
    this.statusLabel,
    this.currency,
    this.planName,
    this.planKey,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.trialStart,
    this.trialEnd,
    this.gracePeriodEndsAt,
    this.createdAt,
    this.networkName,
    this.events = const [],
  });

  final int id;
  final int accountId;
  final int planId;
  final int planVersionId;
  final int priceId;
  final String status;
  final String? statusLabel;
  final int quantity;
  final bool cancelAtPeriodEnd;
  final BillingCurrencyEntity? currency;
  final String? planName;
  final String? planKey;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? trialStart;
  final DateTime? trialEnd;
  final DateTime? gracePeriodEndsAt;
  final DateTime? createdAt;
  final String? networkName;
  final List<BillingSubscriptionEventEntity> events;

  BillingSubscriptionStatus get typedStatus => BillingSubscriptionStatus.fromWire(status);
}

class BillingInvoiceEntity {
  const BillingInvoiceEntity({
    required this.id,
    required this.number,
    required this.accountId,
    required this.status,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.taxMinor,
    required this.totalMinor,
    required this.paidMinor,
    required this.creditedMinor,
    required this.remainingMinor,
    this.statusLabel,
    this.subscriptionId,
    this.invoiceType,
    this.currency,
    this.periodStart,
    this.periodEnd,
    this.issuedOn,
    this.dueOn,
    this.subtotal,
    this.discount,
    this.tax,
    this.total,
    this.paid,
    this.remaining,
    this.createdAt,
    this.finalizedAt,
    this.paidAt,
  });

  final int id;
  final String number;
  final int accountId;
  final String status;
  final String? statusLabel;
  final int? subscriptionId;
  final String? invoiceType;
  final BillingCurrencyEntity? currency;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? issuedOn;
  final DateTime? dueOn;
  final int subtotalMinor;
  final int discountMinor;
  final int taxMinor;
  final int totalMinor;
  final int paidMinor;
  final int creditedMinor;
  final int remainingMinor;
  final String? subtotal;
  final String? discount;
  final String? tax;
  final String? total;
  final String? paid;
  final String? remaining;
  final DateTime? createdAt;
  final DateTime? finalizedAt;
  final DateTime? paidAt;

  BillingInvoiceStatus get typedStatus => BillingInvoiceStatus.fromWire(status);
}

class BillingPaymentEntity {
  const BillingPaymentEntity({
    required this.id,
    required this.reference,
    required this.invoiceId,
    required this.accountId,
    required this.amountMinor,
    required this.status,
    this.statusLabel,
    this.invoiceNumber,
    this.currency,
    this.amount,
    this.paymentMethodName,
    this.paymentMethodKey,
    this.externalReference,
    this.receivedAt,
    this.verifiedAt,
    this.reviewNote,
    this.proofCount = 0,
  });

  final int id;
  final String reference;
  final int invoiceId;
  final int accountId;
  final int amountMinor;
  final String status;
  final String? statusLabel;
  final String? invoiceNumber;
  final BillingCurrencyEntity? currency;
  final String? amount;
  final String? paymentMethodName;
  final String? paymentMethodKey;
  final String? externalReference;
  final DateTime? receivedAt;
  final DateTime? verifiedAt;
  final String? reviewNote;
  final int proofCount;

  BillingPaymentStatus get typedStatus => BillingPaymentStatus.fromWire(status);
}

class BillingTreasuryAccountEntity {
  const BillingTreasuryAccountEntity({
    required this.id,
    required this.accountCode,
    required this.name,
    required this.accountType,
    required this.status,
    this.currency,
    this.institutionName,
    this.accountReference,
    this.ledgerAccountCode,
  });

  final int id;
  final String accountCode;
  final String name;
  final String accountType;
  final String status;
  final BillingCurrencyEntity? currency;
  final String? institutionName;
  final String? accountReference;
  final String? ledgerAccountCode;
}

class BillingJournalEntryEntity {
  const BillingJournalEntryEntity({
    required this.id,
    required this.entryNumber,
    required this.sourceType,
    required this.sourceId,
    required this.status,
    required this.description,
    this.currency,
    this.entryDate,
    this.postedAt,
    this.lineCount = 0,
  });

  final int id;
  final String entryNumber;
  final String sourceType;
  final int sourceId;
  final String status;
  final String description;
  final BillingCurrencyEntity? currency;
  final DateTime? entryDate;
  final DateTime? postedAt;
  final int lineCount;
}

class BillingExchangeRateEntity {
  const BillingExchangeRateEntity({
    required this.id,
    required this.rateNumerator,
    required this.rateDenominator,
    required this.rate,
    required this.source,
    this.baseCurrency,
    this.quoteCurrency,
    this.effectiveAt,
    this.expiresAt,
  });

  final int id;
  final int rateNumerator;
  final int rateDenominator;
  final String rate;
  final String source;
  final BillingCurrencyEntity? baseCurrency;
  final BillingCurrencyEntity? quoteCurrency;
  final DateTime? effectiveAt;
  final DateTime? expiresAt;
}

class BillingConversionEntity {
  const BillingConversionEntity({
    required this.id,
    required this.sourceAmountMinor,
    required this.convertedAmountMinor,
    required this.feeAmountMinor,
    required this.roundingMode,
    required this.sourceType,
    required this.sourceId,
    this.fromCurrency,
    this.toCurrency,
    this.sourceAmount,
    this.convertedAmount,
    this.convertedAt,
  });

  final int id;
  final int sourceAmountMinor;
  final int convertedAmountMinor;
  final int feeAmountMinor;
  final String roundingMode;
  final String sourceType;
  final int sourceId;
  final BillingCurrencyEntity? fromCurrency;
  final BillingCurrencyEntity? toCurrency;
  final String? sourceAmount;
  final String? convertedAmount;
  final DateTime? convertedAt;
}

class BillingCurrencyFinancialSummaryEntity {
  const BillingCurrencyFinancialSummaryEntity({
    required this.currency,
    required this.pendingPaymentCount,
    required this.pendingPaymentAmountMinor,
    required this.openInvoiceCount,
    required this.openInvoiceOutstandingMinor,
    required this.overdueInvoiceCount,
    required this.overdueInvoiceOutstandingMinor,
    required this.verifiedCollectionCount,
    required this.verifiedCollectionsMinor,
  });

  final BillingCurrencyEntity currency;
  final int pendingPaymentCount;
  final int pendingPaymentAmountMinor;
  final int openInvoiceCount;
  final int openInvoiceOutstandingMinor;
  final int overdueInvoiceCount;
  final int overdueInvoiceOutstandingMinor;
  final int verifiedCollectionCount;
  final int verifiedCollectionsMinor;
}

class BillingStatusCountsEntity {
  const BillingStatusCountsEntity({
    required this.total,
    required this.values,
  });

  final int total;
  final Map<String, int> values;

  int countFor(String wireStatus) => values[wireStatus] ?? 0;
}

class BillingOverviewEntity {
  const BillingOverviewEntity({
    required this.periodFrom,
    required this.periodTo,
    required this.asOf,
    required this.timezone,
    required this.billingAccountsCount,
    required this.subscriptions,
    required this.invoices,
    required this.financialsByCurrency,
    required this.paymentReviewQueue,
  });

  final DateTime? periodFrom;
  final DateTime? periodTo;
  final DateTime? asOf;
  final String timezone;
  final int billingAccountsCount;
  final BillingStatusCountsEntity subscriptions;
  final BillingStatusCountsEntity invoices;
  final List<BillingCurrencyFinancialSummaryEntity> financialsByCurrency;
  final List<BillingPaymentEntity> paymentReviewQueue;
}
