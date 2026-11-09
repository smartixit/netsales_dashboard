/// Synthetic, fixed, non-customer corpus for Arabic PDF typography tests.
///
/// Amounts, dates, phone numbers, and identifiers are preformatted literals.
/// The POC renders these strings exactly as supplied and performs no financial
/// arithmetic, localization, or numeric reformatting.
abstract final class ArabicPdfCorpus {
  static const String joiningAndDiacritics =
      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

  static const String lamAlefForms = 'لا لإ لأ لآ';

  static const String mixedHeading = 'تقرير المبيعات Sales Report — Q4 2026';

  static const String invoiceReference =
      'رقم الفاتورة (INV-2026/0017) — الحالة: مدفوعة';

  static const String phone = 'الهاتف: +967 777 123 456';

  static const String suppliedAmounts =
      'الإجمالي: ١٬٢٥٠٫٥٠ YER / USD 1,250.50';

  static const String westernDigits = '0123456789';

  static const String arabicIndicDigits = '٠١٢٣٤٥٦٧٨٩';

  static const String dateAndTime = 'التاريخ: 09/11/2026 — الوقت: 14:35';

  static const String uuid =
      'معرّف السجل: 550e8400-e29b-41d4-a716-446655440000';

  static const String bracketAndPunctuation =
      'المرجع (A-72/B): خصم 15% — ملاحظة: "مدفوع بالكامل".';

  static const String latinInsideArabic =
      'اسم العميل: ACME Trading Co. — Support: help@example.com';

  static const String isolateExample =
      'التقرير: \u2066INV-2026/0017\u2069 — تم الاعتماد';

  // Explicit LTR isolates for values embedded inside Arabic paragraphs.
  // Compare these with the plain auto-direction cases in the generated PDF.
  static const String isolatedPhone =
      'الهاتف: \u2066+967 777 123 456\u2069';

  static const String isolatedInvoiceReference =
      'رقم الفاتورة: \u2066(INV-2026/0017)\u2069 — الحالة: مدفوعة';

  static const String isolatedUuid =
      'معرّف السجل: \u2066550e8400-e29b-41d4-a716-446655440000\u2069';

  static const String isolatedAmount =
      'الإجمالي: \u2066YER 1,250.50\u2069 / \u2066١٬٢٥٠٫٥٠ YER\u2069';

  static const List<String> payvIsolatedBidiCases = <String>[
    isolatedPhone,
    isolatedInvoiceReference,
    isolatedUuid,
    isolatedAmount,
  ];

  static const List<String> cases = <String>[
    joiningAndDiacritics,
    lamAlefForms,
    mixedHeading,
    invoiceReference,
    phone,
    suppliedAmounts,
    westernDigits,
    arabicIndicDigits,
    dateAndTime,
    uuid,
    bracketAndPunctuation,
    latinInsideArabic,
    isolateExample,
  ];

  /// Samples that should map to printable glyphs in the two baseline renderers.
  /// Bidi isolates remain a dedicated Payv probe because pdf_text_shaper 1.1.1
  /// currently attempts font fallback for U+2066/U+2069 control characters.
  static const List<String> glyphMappedCases = <String>[
    joiningAndDiacritics,
    lamAlefForms,
    mixedHeading,
    invoiceReference,
    phone,
    suppliedAmounts,
    westernDigits,
    arabicIndicDigits,
    dateAndTime,
    uuid,
    bracketAndPunctuation,
    latinInsideArabic,
  ];

  static const List<(String, String, String)> tableRows =
      <(String, String, String)>[
    ('خدمة توريد وتشغيل الشبكة المحلية مع وصف عربي طويل نسبيًا لاختبار التفاف الخلايا.', 'NET-001/A', '1,250.50 YER'),
    ('صيانة دورية للأجهزة ونقاط الاتصال وإعادة تهيئة إعدادات الاتصال.', 'OPS-002/B', '850.00 YER'),
    ('تجهيز مستلزمات التشغيل وفق المواصفات المعتمدة دون اشتقاق أي قيمة.', 'SUP-003/C', '475.25 YER'),
    ('وصف مختلط باللغة العربية مع Product Reference رقم SKU-2026-0042.', 'SKU-0042', '99.95 USD'),
    ('بنود تحتوي على أقواس وشرطات ومائل ونسبة مئوية: (A-72/B) — 15%.', 'MIX-005', '150.00 YER'),
    ('وصف عربي متصل لاختبار الوصل بين الحروف مع التشكيل: مُعالجة وإدارة.', 'TXT-006', '72.00 YER'),
    ('تقرير يتضمن رقم هاتف +967 777 123 456 وتاريخ 09/11/2026.', 'ID-007', '25.00 USD'),
    ('مقارنة الأرقام العربية ١٢٣٤٥٦ مع الأرقام الغربية 123456.', 'NUM-008', '300.00 YER'),
    ('نص طويل يتضمن مرجعًا 550e8400-e29b-41d4-a716-446655440000.', 'UUID-009', '18.75 USD'),
    ('فقرة عربية طويلة لاختبار محاذاة السطر داخل العمود الأيمن من الجدول.', 'RTL-010', '400.00 YER'),
    ('Arabic and English mixed description for invoice line Item-011.', 'ITEM-011', '64.00 USD'),
    ('عبارة عربية مع لام ألف وأشكالها: لا لإ لأ لآ.', 'LIGA-012', '30.00 YER'),
    ('جملة تحتوي على علامات ترقيم عربية وإنجليزية: ؛ ، : ( ) / —.', 'PUNC-013', '81.00 USD'),
    ('رقم تسلسلي INV-2026/0014 وحالة السجل: قيد المراجعة.', 'INV-014', '1,000.00 YER'),
    ('سطر عربي طويل لاختبار حدود الخط وتغطية الرموز وعلامات التشكيل.', 'LONG-015', '220.00 YER'),
    ('المجموع المعروض هنا قيمة اختبارية ثابتة وليست ناتج عملية حسابية.', 'FIX-016', '2,500.00 YER'),
    ('وصف يحتوي على البريد test@example.com والرمز + وشرطة سفلية _.', 'MAIL-017', '12.00 USD'),
    ('تجربة اتجاه النص المختلط: NetSales — لوحة التحكم — Windows/Web.', 'BIDI-018', '510.00 YER'),
  ];

  static String get longParagraph {
    final block = <String>[
      joiningAndDiacritics,
      invoiceReference,
      suppliedAmounts,
      latinInsideArabic,
      bracketAndPunctuation,
      westernDigits,
    ].join(' — ');
    return List<String>.filled(42, block).join('\n\n');
  }

  static String get longTableCell {
    return List<String>.filled(
      3,
      'وصف بند عربي طويل يتضمن حروفًا متصلة وتشكيلًا وعلامات ترقيم مختلطة '
      'مع المرجع Service-2026/0042 والقيمة المعروضة 1,250.50 YER.',
    ).join(' ');
  }
}
