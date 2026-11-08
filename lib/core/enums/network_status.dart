/// حالة مزود الشبكة كما تصل من API؛ لا تعتمد على طبقة Features خاصة بالمزوّد.
enum NetworkStatus {
  active('ACTIVE'),
  inactive('INACTIVE'),
  pending('PENDING'),
  rejected('REJECTED'),
  banned('BANNED'),
  unknown('UNKNOWN');

  const NetworkStatus(this.wireValue);
  final String wireValue;

  static NetworkStatus fromWire(String? raw) {
    if (raw == null) return NetworkStatus.unknown;
    for (final value in values) {
      if (value.wireValue == raw) return value;
    }
    return NetworkStatus.unknown;
  }

  bool get isKnown => this != NetworkStatus.unknown;
}
