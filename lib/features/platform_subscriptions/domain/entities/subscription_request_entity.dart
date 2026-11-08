import 'package:netsales_dashboard/core/enums/request_status.dart';
import 'package:netsales_dashboard/core/enums/subscription_payment_type.dart';

class SubscriptionRequestEntity {
  const SubscriptionRequestEntity({
    required this.id,
    required this.networkId,
    required this.planId,
    required this.totalAmount,
    required this.paymentType,
    required this.status,
    this.uuid,
    this.networkName,
    this.networkPhone,
    this.planName,
    this.requestedByName,
    this.bankAccountName,
    this.transactionReference,
    this.receiptPath,
    this.rejectionReason,
    this.requestNote,
    this.statusLabel,
    this.paymentTypeLabel,
    this.reviewedByName,
    this.reviewDate,
    this.createdAt,
  });

  final int id;
  final int networkId;
  final int planId;
  final String? uuid;
  final String totalAmount;
  final String paymentType;
  final String? paymentTypeLabel;
  final String status;
  final String? statusLabel;
  final String? networkName;
  final String? networkPhone;
  final String? planName;
  final String? requestedByName;
  final String? bankAccountName;
  final String? transactionReference;
  final String? receiptPath;
  final String? rejectionReason;
  final String? requestNote;
  final String? reviewedByName;
  final DateTime? reviewDate;
  final DateTime? createdAt;

  RequestStatus get typedStatus => RequestStatus.fromWire(status);
  SubscriptionPaymentType get typedPaymentType =>
      SubscriptionPaymentType.fromWire(paymentType);
}
