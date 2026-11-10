import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';

class BillingCurrencyModel extends BillingCurrencyEntity {
  const BillingCurrencyModel({
    required super.id,
    required super.code,
    required super.name,
    required super.decimalPlaces,
    super.numericCode,
    super.nativeName,
    super.symbol,
    super.isActive,
  });

  factory BillingCurrencyModel.fromJson(Map<String, dynamic> json) => BillingCurrencyModel(
    id: _int(json['currency_id']),
    code: _string(json['code']),
    name: _string(json['name']),
    decimalPlaces: _int(json['decimal_places'], fallback: 2),
    numericCode: _nullableString(json['numeric_code']),
    nativeName: _nullableString(json['native_name']),
    symbol: _nullableString(json['symbol']),
    isActive: _bool(json['is_active']),
  );
}

class BillingProductModel extends BillingProductEntity {
  const BillingProductModel({
    required super.id,
    required super.key,
    required super.name,
    required super.isActive,
    super.description,
  });

  factory BillingProductModel.fromJson(Map<String, dynamic> json) => BillingProductModel(
    id: _int(json['product_id']),
    key: _string(json['product_key']),
    name: _string(json['name']),
    description: _nullableString(json['description']),
    isActive: _bool(json['is_active']),
  );
}

class BillingPriceModel extends BillingPriceEntity {
  const BillingPriceModel({
    required super.id,
    required super.currencyId,
    required super.billingInterval,
    required super.intervalCount,
    required super.unitAmountMinor,
    required super.setupFeeMinor,
    required super.isActive,
    super.trialPolicyVersionId,
    super.dunningPolicyVersionId,
    super.currency,
    super.unitAmount,
    super.setupFee,
  });

  factory BillingPriceModel.fromJson(Map<String, dynamic> json) => BillingPriceModel(
    id: _int(json['price_id']),
    currencyId: _int(_map(json['currency'])['currency_id']),
    billingInterval: _string(json['billing_interval'], fallback: 'UNKNOWN'),
    intervalCount: _int(json['interval_count'], fallback: 1),
    unitAmountMinor: _int(json['unit_amount_minor']),
    setupFeeMinor: _int(json['setup_fee_minor']),
    unitAmount: _nullableString(json['unit_amount']),
    setupFee: _nullableString(json['setup_fee']),
    isActive: _bool(json['is_active']),
    trialPolicyVersionId: _nullableInt(json['trial_policy_version_id']),
    dunningPolicyVersionId: _nullableInt(json['dunning_policy_version_id']),
    currency: json['currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['currency'])) : null,
  );
}

class BillingFeatureModel extends BillingFeatureEntity {
  const BillingFeatureModel({
    required super.id,
    required super.key,
    required super.name,
    required super.type,
    super.value,
    super.unit,
  });

  factory BillingFeatureModel.fromJson(Map<String, dynamic> json) => BillingFeatureModel(
    id: _int(json['plan_feature_id']),
    key: _string(json['feature_key']),
    name: _string(json['name']),
    type: _string(json['feature_type'], fallback: 'UNKNOWN'),
    value: _nullableString(json['value']),
    unit: _nullableString(json['unit']),
  );
}

class BillingTrialPolicySummaryModel extends BillingTrialPolicySummaryEntity {
  const BillingTrialPolicySummaryModel({
    required super.isEnabled,
    required super.durationValue,
    required super.durationUnit,
    super.policyKey,
  });

  factory BillingTrialPolicySummaryModel.fromJson(Map<String, dynamic> json) => BillingTrialPolicySummaryModel(
    isEnabled: _bool(json['is_enabled']),
    durationValue: _int(json['duration_value']),
    durationUnit: _string(json['duration_unit']),
    policyKey: _nullableString(json['policy_key']),
  );
}

class BillingPlanVersionModel extends BillingPlanVersionEntity {
  const BillingPlanVersionModel({
    required super.id,
    required super.versionNumber,
    required super.status,
    super.statusLabel,
    super.trialPolicy,
    super.trialPolicyVersionId,
    super.dunningPolicyVersionId,
    super.prices,
    super.features,
  });

  factory BillingPlanVersionModel.fromJson(Map<String, dynamic> json) {
    final rawPrices = json['prices'];
    final rawFeatures = json['features'];
    final rawTrial = json['trial_policy'];
    return BillingPlanVersionModel(
      id: _int(json['plan_version_id']),
      versionNumber: _int(json['version_number']),
      status: _string(json['status'], fallback: 'UNKNOWN'),
      statusLabel: _nullableString(json['status_label']),
      trialPolicy: rawTrial is Map ? BillingTrialPolicySummaryModel.fromJson(_map(rawTrial)) : null,
      trialPolicyVersionId: _nullableInt(json['trial_policy_version_id']),
      dunningPolicyVersionId: _nullableInt(json['dunning_policy_version_id']),
      prices: _mapList(rawPrices).map(BillingPriceModel.fromJson).toList(growable: false),
      features: _mapList(rawFeatures).map(BillingFeatureModel.fromJson).toList(growable: false),
    );
  }
}

class BillingPlanModel extends BillingPlanEntity {
  const BillingPlanModel({
    required super.id,
    required super.key,
    required super.name,
    required super.isPublic,
    required super.isActive,
    super.description,
    super.productName,
    super.productId,
    super.currentVersion,
  });

  factory BillingPlanModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final version = json['current_version'];
    return BillingPlanModel(
      id: _int(json['plan_id']),
      key: _string(json['plan_key']),
      name: _string(json['name']),
      description: _nullableString(json['description']),
      isPublic: _bool(json['is_public']),
      isActive: _bool(json['is_active']),
      productName: product is Map ? _nullableString(_map(product)['name']) : null,
      productId: product is Map ? _nullableInt(_map(product)['product_id']) : null,
      currentVersion: version is Map ? BillingPlanVersionModel.fromJson(_map(version)) : null,
    );
  }
}

class BillingTrialPolicyVersionModel extends BillingTrialPolicyVersionEntity {
  const BillingTrialPolicyVersionModel({
    required super.id,
    required super.policyId,
    required super.versionNumber,
    required super.status,
    required super.isEnabled,
    required super.durationValue,
    required super.durationUnit,
    required super.startTrigger,
    required super.redemptionScope,
    required super.eligibilityMode,
    required super.requiresManualApproval,
    required super.endBehavior,
    required super.entitlementMode,
    super.policyKey,
    super.entitlementConfig,
    super.publishedAt,
  });

  factory BillingTrialPolicyVersionModel.fromJson(Map<String, dynamic> json) =>
      BillingTrialPolicyVersionModel(
        id: _int(json['trial_policy_version_id']),
        policyId: _int(json['trial_policy_id']),
        versionNumber: _int(json['version_number']),
        status: _string(json['status'], fallback: 'UNKNOWN'),
        isEnabled: _bool(json['is_enabled']),
        durationValue: _int(json['duration_value']),
        durationUnit: _string(json['duration_unit'], fallback: 'DAY'),
        startTrigger: _string(json['start_trigger'], fallback: 'PURCHASE'),
        redemptionScope: _string(json['redemption_scope'], fallback: 'NETWORK'),
        eligibilityMode: _string(json['eligibility_mode'], fallback: 'NEW_BILLING_ACCOUNT'),
        requiresManualApproval: _bool(json['requires_manual_approval']),
        endBehavior: _string(json['end_behavior'], fallback: 'CREATE_INVOICE'),
        entitlementMode: _string(json['entitlement_mode'], fallback: 'FULL_PLAN'),
        policyKey: _nullableString(json['policy_key']),
        entitlementConfig: json['entitlement_config'] is Map
            ? _map(json['entitlement_config'])
            : null,
        publishedAt: _date(json['published_at']),
      );
}

class BillingDunningPolicyVersionModel extends BillingDunningPolicyVersionEntity {
  const BillingDunningPolicyVersionModel({
    required super.id,
    required super.policyId,
    required super.versionNumber,
    required super.status,
    required super.gracePeriodDays,
    required super.autoSuspendAfterGrace,
    required super.reminderScheduleDays,
    required super.preRenewalAlertDays,
    super.policyKey,
    super.publishedAt,
  });

  factory BillingDunningPolicyVersionModel.fromJson(Map<String, dynamic> json) =>
      BillingDunningPolicyVersionModel(
        id: _int(json['dunning_policy_version_id']),
        policyId: _int(json['dunning_policy_id']),
        versionNumber: _int(json['version_number']),
        status: _string(json['status'], fallback: 'UNKNOWN'),
        gracePeriodDays: _int(json['grace_period_days']),
        autoSuspendAfterGrace: _bool(json['auto_suspend_after_grace']),
        reminderScheduleDays: _intList(json['reminder_schedule_days']),
        preRenewalAlertDays: _intList(json['pre_renewal_alert_days']),
        policyKey: _nullableString(json['policy_key']),
        publishedAt: _date(json['published_at']),
      );
}

class BillingTrialPolicyModel extends BillingTrialPolicyEntity {
  const BillingTrialPolicyModel({
    required super.id,
    required super.key,
    required super.name,
    required super.isActive,
    super.description,
    super.currentVersion,
  });

  factory BillingTrialPolicyModel.fromJson(Map<String, dynamic> json) {
    final current = json['current_version'];
    return BillingTrialPolicyModel(
      id: _int(json['trial_policy_id']),
      key: _string(json['policy_key']),
      name: _string(json['name']),
      description: _nullableString(json['description']),
      isActive: _bool(json['is_active']),
      currentVersion: current is Map
          ? BillingTrialPolicyVersionModel.fromJson({
              ..._map(current),
              'trial_policy_id': _map(current)['trial_policy_id'] ?? json['trial_policy_id'],
              'policy_key': _map(current)['policy_key'] ?? json['policy_key'],
            })
          : null,
    );
  }
}

class BillingDunningPolicyModel extends BillingDunningPolicyEntity {
  const BillingDunningPolicyModel({
    required super.id,
    required super.key,
    required super.name,
    required super.isActive,
    super.description,
    super.currentVersion,
  });

  factory BillingDunningPolicyModel.fromJson(Map<String, dynamic> json) {
    final current = json['current_version'];
    return BillingDunningPolicyModel(
      id: _int(json['dunning_policy_id']),
      key: _string(json['policy_key']),
      name: _string(json['name']),
      description: _nullableString(json['description']),
      isActive: _bool(json['is_active']),
      currentVersion: current is Map
          ? BillingDunningPolicyVersionModel.fromJson({
              ..._map(current),
              'dunning_policy_id': _map(current)['dunning_policy_id'] ?? json['dunning_policy_id'],
              'policy_key': _map(current)['policy_key'] ?? json['policy_key'],
            })
          : null,
    );
  }
}

class BillingTrialRedemptionModel extends BillingTrialRedemptionEntity {
  const BillingTrialRedemptionModel({
    required super.id,
    required super.subscriptionId,
    required super.policyId,
    required super.policyVersionId,
    required super.status,
    required super.redemptionScope,
    required super.redemptionSubjectKey,
    super.policyKey,
    super.policyName,
    super.versionNumber,
    super.networkId,
    super.networkName,
    super.billingAccountId,
    super.accountNumber,
    super.reservedAt,
    super.startedAt,
    super.completedAt,
    super.trialEnd,
    super.metadata,
  });

  factory BillingTrialRedemptionModel.fromJson(Map<String, dynamic> json) {
    final policy = _map(json['policy']);
    final policyVersion = _map(json['policy_version']);
    final subscription = _map(json['subscription']);
    final account = _map(subscription['billing_account']);
    final network = _map(account['network']);
    final metadata = json['metadata'];
    return BillingTrialRedemptionModel(
      id: _int(json['trial_redemption_id']),
      subscriptionId: _int(json['billing_subscription_id']),
      policyId: _int(json['trial_policy_id']),
      policyVersionId: _int(json['trial_policy_version_id']),
      status: _string(json['status'], fallback: 'UNKNOWN'),
      redemptionScope: _string(json['redemption_scope'], fallback: 'NETWORK'),
      redemptionSubjectKey: _string(json['redemption_subject_key']),
      policyKey: _nullableString(policy['policy_key']),
      policyName: _nullableString(policy['name']),
      versionNumber: _nullableInt(policyVersion['version_number']),
      networkId: _nullableInt(json['network_id'] ?? account['network_id']),
      networkName: _nullableString(network['network_name']),
      billingAccountId: _nullableInt(json['billing_account_id'] ?? account['billing_account_id']),
      accountNumber: _nullableString(account['account_number']),
      reservedAt: _date(json['reserved_at']),
      startedAt: _date(json['started_at']),
      completedAt: _date(json['completed_at']),
      trialEnd: _date(subscription['trial_end']),
      metadata: metadata is Map ? _map(metadata) : null,
    );
  }
}

class BillingAccountModel extends BillingAccountEntity {
  const BillingAccountModel({
    required super.id,
    required super.accountNumber,
    required super.networkId,
    required super.status,
    required super.paymentTermsDays,
    super.networkName,
    super.legalName,
    super.billingEmail,
    super.taxNumber,
    super.billingAddress,
    super.defaultCurrency,
  });

  factory BillingAccountModel.fromJson(Map<String, dynamic> json) => BillingAccountModel(
    id: _int(json['billing_account_id']),
    accountNumber: _string(json['account_number']),
    networkId: _int(json['network_id']),
    networkName: _nullableString(json['network_name']),
    legalName: _nullableString(json['legal_name']),
    billingEmail: _nullableString(json['billing_email']),
    taxNumber: _nullableString(json['tax_number']),
    billingAddress: _nullableString(json['billing_address']),
    status: _string(json['status'], fallback: 'UNKNOWN'),
    paymentTermsDays: _int(json['payment_terms_days']),
    defaultCurrency: json['default_currency'] is Map
        ? BillingCurrencyModel.fromJson(_map(json['default_currency']))
        : null,
  );
}

class BillingSubscriptionEventModel extends BillingSubscriptionEventEntity {
  const BillingSubscriptionEventModel({
    required super.id,
    required super.type,
    required super.occurredAt,
    super.fromStatus,
    super.toStatus,
    super.actorId,
    super.reason,
  });

  factory BillingSubscriptionEventModel.fromJson(Map<String, dynamic> json) {
    final payload = _map(json['payload']);
    return BillingSubscriptionEventModel(
      id: _int(json['event_id']),
      type: _string(json['event_type']),
      fromStatus: _nullableString(json['from_status']),
      toStatus: _nullableString(json['to_status']),
      actorId: _nullableInt(json['actor_id']),
      occurredAt: _date(json['occurred_at']),
      reason: _nullableString(payload['reason']),
    );
  }
}

class BillingSubscriptionModel extends BillingSubscriptionEntity {
  const BillingSubscriptionModel({
    required super.id,
    required super.accountId,
    required super.planId,
    required super.planVersionId,
    required super.priceId,
    required super.status,
    required super.quantity,
    required super.cancelAtPeriodEnd,
    super.statusLabel,
    super.currency,
    super.planName,
    super.planKey,
    super.currentPeriodStart,
    super.currentPeriodEnd,
    super.trialStart,
    super.trialEnd,
    super.gracePeriodEndsAt,
    super.createdAt,
    super.networkName,
    super.events,
  });

  factory BillingSubscriptionModel.fromJson(Map<String, dynamic> json, {List<Map<String, dynamic>> events = const []}) {
    final plan = json['plan'];
    final account = json['billing_account'];
    return BillingSubscriptionModel(
      id: _int(json['billing_subscription_id']),
      accountId: _int(json['billing_account_id']),
      planId: _int(json['plan_id']),
      planVersionId: _int(json['plan_version_id']),
      priceId: _int(json['price_id']),
      status: _string(json['status'], fallback: 'UNKNOWN'),
      statusLabel: _nullableString(json['status_label']),
      quantity: _int(json['quantity'], fallback: 1),
      cancelAtPeriodEnd: _bool(json['cancel_at_period_end']),
      currency: json['currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['currency'])) : null,
      planName: plan is Map ? _nullableString(_map(plan)['name']) : null,
      planKey: plan is Map ? _nullableString(_map(plan)['plan_key']) : null,
      networkName: account is Map ? _nullableString(_map(account)['network_name']) : null,
      currentPeriodStart: _date(json['current_period_start']),
      currentPeriodEnd: _date(json['current_period_end']),
      trialStart: _date(json['trial_start']),
      trialEnd: _date(json['trial_end']),
      gracePeriodEndsAt: _date(json['grace_period_ends_at']),
      createdAt: _date(json['created_at']),
      events: events.map(BillingSubscriptionEventModel.fromJson).toList(growable: false),
    );
  }
}

class BillingInvoiceModel extends BillingInvoiceEntity {
  const BillingInvoiceModel({
    required super.id,
    required super.number,
    required super.accountId,
    required super.status,
    required super.subtotalMinor,
    required super.discountMinor,
    required super.taxMinor,
    required super.totalMinor,
    required super.paidMinor,
    required super.creditedMinor,
    required super.remainingMinor,
    super.statusLabel,
    super.subscriptionId,
    super.invoiceType,
    super.currency,
    super.periodStart,
    super.periodEnd,
    super.issuedOn,
    super.dueOn,
    super.subtotal,
    super.discount,
    super.tax,
    super.total,
    super.paid,
    super.remaining,
    super.createdAt,
    super.finalizedAt,
    super.paidAt,
  });

  factory BillingInvoiceModel.fromJson(Map<String, dynamic> json) => BillingInvoiceModel(
    id: _int(json['invoice_id']),
    number: _string(json['invoice_number']),
    accountId: _int(json['billing_account_id']),
    subscriptionId: _nullableInt(json['billing_subscription_id']),
    invoiceType: _nullableString(json['invoice_type']),
    status: _string(json['status'], fallback: 'UNKNOWN'),
    statusLabel: _nullableString(json['status_label']),
    currency: json['currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['currency'])) : null,
    subtotalMinor: _int(json['subtotal_minor']),
    discountMinor: _int(json['discount_minor']),
    taxMinor: _int(json['tax_minor']),
    totalMinor: _int(json['total_minor']),
    paidMinor: _int(json['paid_minor']),
    creditedMinor: _int(json['credited_minor']),
    remainingMinor: _int(json['remaining_minor']),
    subtotal: _nullableString(json['subtotal']),
    discount: _nullableString(json['discount']),
    tax: _nullableString(json['tax']),
    total: _nullableString(json['total']),
    paid: _nullableString(json['paid']),
    remaining: _nullableString(json['remaining']),
    periodStart: _date(json['period_start']),
    periodEnd: _date(json['period_end']),
    issuedOn: _date(json['issued_on']),
    dueOn: _date(json['due_on']),
    createdAt: _date(json['created_at']),
    finalizedAt: _date(json['finalized_at']),
    paidAt: _date(json['paid_at']),
  );
}

class BillingPaymentModel extends BillingPaymentEntity {
  const BillingPaymentModel({
    required super.id,
    required super.reference,
    required super.invoiceId,
    required super.accountId,
    required super.amountMinor,
    required super.status,
    super.statusLabel,
    super.invoiceNumber,
    super.currency,
    super.amount,
    super.paymentMethodName,
    super.paymentMethodKey,
    super.externalReference,
    super.receivedAt,
    super.verifiedAt,
    super.reviewNote,
    super.proofCount,
  });

  factory BillingPaymentModel.fromJson(Map<String, dynamic> json) {
    final method = json['payment_method'];
    return BillingPaymentModel(
      id: _int(json['payment_id']),
      reference: _string(json['payment_reference']),
      invoiceId: _int(json['invoice_id']),
      accountId: _int(json['billing_account_id']),
      amountMinor: _int(json['amount_minor']),
      amount: _nullableString(json['amount']),
      status: _string(json['status'], fallback: 'UNKNOWN'),
      statusLabel: _nullableString(json['status_label']),
      invoiceNumber: _nullableString(json['invoice_number']),
      currency: json['currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['currency'])) : null,
      paymentMethodName: method is Map ? _nullableString(_map(method)['name']) : null,
      paymentMethodKey: method is Map ? _nullableString(_map(method)['method_key']) : null,
      externalReference: _nullableString(json['external_reference']),
      receivedAt: _date(json['received_at']),
      verifiedAt: _date(json['verified_at']),
      reviewNote: _nullableString(json['review_note']),
      proofCount: _mapList(json['proofs']).length,
    );
  }
}

class BillingTreasuryAccountModel extends BillingTreasuryAccountEntity {
  const BillingTreasuryAccountModel({
    required super.id,
    required super.accountCode,
    required super.name,
    required super.accountType,
    required super.status,
    super.currency,
    super.institutionName,
    super.accountReference,
    super.ledgerAccountCode,
  });

  factory BillingTreasuryAccountModel.fromJson(Map<String, dynamic> json) {
    final currency = json['currency'];
    return BillingTreasuryAccountModel(
      id: _int(json['treasury_account_id']),
      accountCode: _string(json['account_code']),
      name: _string(json['name']),
      accountType: _string(json['account_type']),
      status: _string(json['status'], fallback: 'UNKNOWN'),
      currency: currency is Map ? BillingCurrencyModel.fromJson(_map(currency)) : null,
      institutionName: _nullableString(json['institution_name']),
      accountReference: _nullableString(json['account_reference']),
      ledgerAccountCode: _nullableString(json['ledger_account_code']),
    );
  }
}

class BillingJournalEntryModel extends BillingJournalEntryEntity {
  const BillingJournalEntryModel({
    required super.id,
    required super.entryNumber,
    required super.sourceType,
    required super.sourceId,
    required super.status,
    required super.description,
    super.currency,
    super.entryDate,
    super.postedAt,
    super.lineCount,
  });

  factory BillingJournalEntryModel.fromJson(Map<String, dynamic> json) => BillingJournalEntryModel(
    id: _int(json['journal_entry_id']),
    entryNumber: _string(json['entry_number']),
    sourceType: _string(json['source_type']),
    sourceId: _int(json['source_id']),
    status: _string(json['status'], fallback: 'UNKNOWN'),
    description: _string(json['description']),
    currency: json['currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['currency'])) : null,
    entryDate: _date(json['entry_date']),
    postedAt: _date(json['posted_at']),
    lineCount: _mapList(json['lines']).length,
  );
}

class BillingExchangeRateModel extends BillingExchangeRateEntity {
  const BillingExchangeRateModel({
    required super.id,
    required super.rateNumerator,
    required super.rateDenominator,
    required super.rate,
    required super.source,
    super.baseCurrency,
    super.quoteCurrency,
    super.effectiveAt,
    super.expiresAt,
  });

  factory BillingExchangeRateModel.fromJson(Map<String, dynamic> json) => BillingExchangeRateModel(
    id: _int(json['exchange_rate_id']),
    rateNumerator: _int(json['rate_numerator']),
    rateDenominator: _int(json['rate_denominator']),
    rate: _string(json['rate']),
    source: _string(json['source']),
    baseCurrency: json['base_currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['base_currency'])) : null,
    quoteCurrency: json['quote_currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['quote_currency'])) : null,
    effectiveAt: _date(json['effective_at']),
    expiresAt: _date(json['expires_at']),
  );
}

class BillingConversionModel extends BillingConversionEntity {
  const BillingConversionModel({
    required super.id,
    required super.sourceAmountMinor,
    required super.convertedAmountMinor,
    required super.feeAmountMinor,
    required super.roundingMode,
    required super.sourceType,
    required super.sourceId,
    super.fromCurrency,
    super.toCurrency,
    super.sourceAmount,
    super.convertedAmount,
    super.convertedAt,
  });

  factory BillingConversionModel.fromJson(Map<String, dynamic> json) => BillingConversionModel(
    id: _int(json['conversion_id']),
    sourceAmountMinor: _int(json['source_amount_minor']),
    convertedAmountMinor: _int(json['converted_amount_minor']),
    feeAmountMinor: _int(json['fee_amount_minor']),
    roundingMode: _string(json['rounding_mode']),
    sourceType: _string(json['source_type']),
    sourceId: _int(json['source_id']),
    fromCurrency: json['from_currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['from_currency'])) : null,
    toCurrency: json['to_currency'] is Map ? BillingCurrencyModel.fromJson(_map(json['to_currency'])) : null,
    sourceAmount: _nullableString(json['source_amount']),
    convertedAmount: _nullableString(json['converted_amount']),
    convertedAt: _date(json['converted_at']),
  );
}

class BillingCurrencyFinancialSummaryModel extends BillingCurrencyFinancialSummaryEntity {
  const BillingCurrencyFinancialSummaryModel({
    required super.currency,
    required super.pendingPaymentCount,
    required super.pendingPaymentAmountMinor,
    super.pendingPaymentAmount,
    required super.openInvoiceCount,
    required super.openInvoiceOutstandingMinor,
    super.openInvoiceOutstanding,
    required super.overdueInvoiceCount,
    required super.overdueInvoiceOutstandingMinor,
    super.overdueInvoiceOutstanding,
    required super.verifiedCollectionCount,
    required super.verifiedCollectionsMinor,
    super.verifiedCollections,
  });

  factory BillingCurrencyFinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    final currencyJson = _map(json['currency']);
    final pending = _map(json['pending_payments']);
    final open = _map(json['open_invoices']);
    final overdue = _map(json['overdue_invoices']);
    final collected = _map(json['verified_collections_this_month']);
    return BillingCurrencyFinancialSummaryModel(
      currency: BillingCurrencyModel.fromJson(currencyJson),
      pendingPaymentCount: _int(pending['count']),
      pendingPaymentAmountMinor: _int(pending['amount_minor']),
      pendingPaymentAmount: _nullableString(pending['amount']),
      openInvoiceCount: _int(open['count']),
      openInvoiceOutstandingMinor: _int(open['outstanding_minor']),
      openInvoiceOutstanding: _nullableString(open['outstanding']),
      overdueInvoiceCount: _int(overdue['count']),
      overdueInvoiceOutstandingMinor: _int(overdue['outstanding_minor']),
      overdueInvoiceOutstanding: _nullableString(overdue['outstanding']),
      verifiedCollectionCount: _int(collected['count']),
      verifiedCollectionsMinor: _int(collected['amount_minor']),
      verifiedCollections: _nullableString(collected['amount']),
    );
  }
}

class BillingOverviewModel extends BillingOverviewEntity {
  const BillingOverviewModel({
    required super.periodFrom,
    required super.periodTo,
    required super.asOf,
    required super.timezone,
    required super.billingAccountsCount,
    required super.subscriptions,
    required super.invoices,
    required super.financialsByCurrency,
    required super.paymentReviewQueue,
  });

  factory BillingOverviewModel.fromJson(Map<String, dynamic> json) {
    final period = _map(json['period']);
    final counts = _map(json['counts']);
    final subscriptions = _map(counts['subscriptions']);
    final invoices = _map(counts['invoices']);
    return BillingOverviewModel(
      periodFrom: _date(period['from']),
      periodTo: _date(period['to']),
      asOf: _date(period['as_of']),
      timezone: _string(period['timezone'], fallback: 'Asia/Aden'),
      billingAccountsCount: _int(counts['billing_accounts']),
      subscriptions: BillingStatusCountsEntity(
        total: _int(subscriptions['total']),
        values: {for (final entry in subscriptions.entries) if (entry.key != 'total') entry.key: _int(entry.value)},
      ),
      invoices: BillingStatusCountsEntity(
        total: _int(invoices['total']),
        values: {for (final entry in invoices.entries) if (entry.key != 'total') entry.key: _int(entry.value)},
      ),
      financialsByCurrency: _mapList(json['financials_by_currency'])
          .map(BillingCurrencyFinancialSummaryModel.fromJson).toList(growable: false),
      paymentReviewQueue: _mapList(json['payment_review_queue'])
          .map(BillingPaymentModel.fromJson).toList(growable: false),
    );
  }
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList(growable: false);
}

int _int(Object? value, {int fallback = 0}) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? fallback;

int? _nullableInt(Object? value) => value == null ? null : _int(value);

List<int> _intList(Object? value) =>
    value is List ? value.map((item) => _int(item)).toList(growable: false) : const [];

bool _bool(Object? value) => value == true || value == 1 || value == '1';

String _string(Object? value, {String fallback = ''}) => value?.toString() ?? fallback;

String? _nullableString(Object? value) => value == null ? null : value.toString();

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
