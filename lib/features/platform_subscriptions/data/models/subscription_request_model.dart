import 'package:netsales_dashboard/features/platform_subscriptions/domain/entities/subscription_request_entity.dart';

class SubscriptionRequestModel extends SubscriptionRequestEntity {
  const SubscriptionRequestModel({
    required super.id, required super.networkId, required super.planId,
    required super.totalAmount, required super.paymentType, required super.status,
    super.uuid, super.networkName, super.networkPhone, super.planName,
    super.requestedByName, super.bankAccountName, super.transactionReference,
    super.receiptPath, super.rejectionReason, super.requestNote, super.statusLabel,
    super.paymentTypeLabel, super.reviewedByName, super.reviewDate, super.createdAt,
  });

  factory SubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    final network = json['network'];
    final plan = json['plan'];
    final requester = json['requested_by_user'];
    final reviewer = json['reviewed_by_user'];
    final account = json['bank_account'];
    return SubscriptionRequestModel(
      id: _int(json['request_id']),
      networkId: _int(json['network_id']),
      planId: _int(json['plan_id']),
      uuid: json['request_uuid']?.toString(),
      totalAmount: json['request_total_amount']?.toString() ?? '0',
      paymentType: json['request_payment_type']?.toString() ?? 'UNKNOWN',
      paymentTypeLabel: json['request_payment_type_label']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusLabel: json['status_label']?.toString(),
      networkName: network is Map ? network['network_name']?.toString() : null,
      networkPhone: network is Map ? network['network_phone_number']?.toString() : null,
      planName: plan is Map ? plan['plan_name']?.toString() : null,
      requestedByName: requester is Map ? requester['user_full_name']?.toString() : null,
      bankAccountName: account is Map ? account['account_name']?.toString() : null,
      transactionReference: json['transaction_reference']?.toString(),
      receiptPath: json['transaction_receipt']?.toString(),
      rejectionReason: json['rejection_reason']?.toString(),
      requestNote: json['request_note']?.toString(),
      reviewedByName: reviewer is Map ? reviewer['user_full_name']?.toString() : null,
      reviewDate: _date(json['review_date']),
      createdAt: _date(json['created_at']),
    );
  }
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
