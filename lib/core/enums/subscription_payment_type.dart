enum SubscriptionPaymentType {
  cash('CASH'),
  bank('BANK'),
  wallet('WALLET'),
  unknown('UNKNOWN');

  const SubscriptionPaymentType(this.wireValue);
  final String wireValue;

  static SubscriptionPaymentType fromWire(String? raw) {
    for (final value in values) {
      if (value.wireValue == raw) return value;
    }
    return unknown;
  }
}
