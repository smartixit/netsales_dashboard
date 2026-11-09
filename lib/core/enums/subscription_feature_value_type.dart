enum SubscriptionFeatureValueType {
  text('TEXT'),
  integer('INTEGER'),
  boolean('BOOLEAN'),
  decimal('DECIMAL'),
  json('JSON'),
  dateTime('DATETIME'),
  unknown('UNKNOWN');

  const SubscriptionFeatureValueType(this.wireValue);
  final String wireValue;

  static SubscriptionFeatureValueType fromWire(String? raw) {
    for (final value in values) {
      if (value.wireValue == raw) return value;
    }
    return unknown;
  }
}
