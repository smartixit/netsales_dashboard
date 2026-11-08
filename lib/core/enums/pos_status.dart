/// حالة نقطة البيع كما تصل من API، محفوظة كعقد مشترك دون جلب Feature كامل.
enum PosStatus {
  active('ACTIVE'), inactive('INACTIVE'), pending('PENDING'),
  rejected('REJECTED'), banned('BANNED'), unknown('UNKNOWN');

  const PosStatus(this.wireValue);
  final String wireValue;

  static PosStatus fromWire(String? raw) {
    if (raw == null) return PosStatus.unknown;
    for (final value in values) {
      if (value.wireValue == raw) return value;
    }
    return PosStatus.unknown;
  }

  bool get isKnown => this != PosStatus.unknown;
}
