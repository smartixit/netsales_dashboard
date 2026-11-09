import 'package:flutter/material.dart';

/// ============================================================================
/// نظام التيبوغرافي المركزي الموحد (Enterprise Desktop Design System Typography)
/// ============================================================================
/// مصمم ومخصص لمنصات سطح المكتب (Windows Desktop & Responsive Web).
/// يعتمد على مقاييس دقيقة بوحدات البكسل المنطقية (Logical Pixels) لتوفير
/// كثافة بصرية متوازنة (Enterprise Visual Density) تتوافق مع معايير Windows 11 وFluent Design.
/// خالٍ تماماً من التمدد العشوائي (ScreenUtil) لضمان ثبات ووضوح الخطوط والأرقام على كافة الشاشات.
class AppTypography {
  AppTypography._();

  /// اسم الخط الأساسي الموحد للنظام (IBM Plex Sans Arabic)
  static const String fontFamily = 'ibm';

  // ---------------------------------------------------------------------------
  // أوزان الخطوط القياسية (Font Weights)
  // ---------------------------------------------------------------------------
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ---------------------------------------------------------------------------
  // ثوابت الأحجام لسطح المكتب (Desktop Logical Font Sizes in px)
  // ---------------------------------------------------------------------------
  static const double sizeDisplayLarge = 36.0;
  static const double sizeDisplayMedium = 28.0;
  static const double sizeDisplaySmall = 24.0;

  static const double sizeHeadlineLarge = 22.0;
  static const double sizeHeadlineMedium = 18.0;
  static const double sizeHeadlineSmall = 16.0;

  static const double sizeTitleLarge = 15.0;
  static const double sizeTitleMedium = 14.0;
  static const double sizeTitleSmall = 13.0;

  static const double sizeBodyLarge = 14.0;
  static const double sizeBodyMedium = 13.0;
  static const double sizeBodySmall = 12.0;

  static const double sizeButtonLarge = 14.0;
  static const double sizeButtonMedium = 13.0;
  static const double sizeButtonSmall = 12.0;

  static const double sizeInputText = 13.0;
  static const double sizeInputHint = 13.0;
  static const double sizeInputLabel = 12.0;
  static const double sizeInputError = 11.0;

  static const double sizeCurrencyHero = 28.0;
  static const double sizeCurrencyMedium = 16.0;
  static const double sizeCurrencySymbol = 11.0;

  static const double sizeChip = 12.0;
  static const double sizeBadge = 11.0;
  static const double sizeCaption = 11.0;

  // ===========================================================================
  // 1. شاشات العرض الكبرى (Display - Hero & Big Stats)
  // ===========================================================================

  /// displayLarge (36px, Bold) - الإحصائيات الكبرى والترويسات البارزة
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeDisplayLarge,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// displayMedium (28px, Bold) - العناوين العريضة للأقسام الرئيسية
  static TextStyle get displayMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeDisplayMedium,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// displaySmall (24px, Bold) - ترويسات بطاقات الـ Hero في لوحة التحكم
  static TextStyle get displaySmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeDisplaySmall,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.25,
  );

  // ===========================================================================
  // 2. عناوين الشاشات والأقسام (Headline - Screen & Section Titles)
  // ===========================================================================

  /// headlineLarge (22px, Bold) - عنوان الصفحة الرئيسي (Top Page Header)
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeHeadlineLarge,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.3,
  );

  /// headlineMedium (18px, SemiBold) - عناوين الصناديق الحوارية وبطاقات العمليات
  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeHeadlineMedium,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.3,
  );

  /// headlineSmall (16px, SemiBold) - عناوين الأقسام الفرعية داخل النماذج والصفحات
  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeHeadlineSmall,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.35,
  );

  // ===========================================================================
  // 3. عناوين البطاقات والقوائم (Title - Cards, Lists, AppBar, Tables)
  // ===========================================================================

  /// titleLarge (15px, Bold) - ترويسات الجداول واللوحات الجانبية
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeTitleLarge,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.35,
  );

  /// titleMedium (14px, SemiBold) - عناصر القائمة الجانبية (Sidebar) وعناوين البطاقات
  static TextStyle get titleMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeTitleMedium,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.35,
  );

  /// titleSmall (13px, SemiBold) - ترويسات الحقول والمجموعات المدمجة
  static TextStyle get titleSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeTitleSmall,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.4,
  );

  // ===========================================================================
  // 4. نصوص المحتوى والفقرات (Body - Paragraphs, Table Cells, Content)
  // ===========================================================================

  /// bodyLarge (14px, Regular) - النصوص التوضيحية والفقرات الموسعة
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeBodyLarge,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.5,
  );

  /// bodyMedium (13px, Regular) - النص القياسي لبيئة ويندوز (خلايا الجداول والبيانات)
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeBodyMedium,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.45,
  );

  /// bodySmall (12px, Regular) - النصوص الفرعية والملاحظات المساعدة
  static TextStyle get bodySmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeBodySmall,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.4,
  );

  // ===========================================================================
  // 5. خطوط الأزرار المركزية (Button Tokens - Enterprise Hierarchy)
  // ===========================================================================

  /// زر بحجم كبير (14px, Bold) - أزرار العمليات الرئيسية وشاشات الدخول
  static TextStyle get buttonLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeButtonLarge,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// زر بحجم قياسي (13px, Bold) - أزرار النماذج والصناديق الحوارية المعتادة
  static TextStyle get buttonMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeButtonMedium,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// زر بحجم مدمج (12px, SemiBold) - أزرار الجداول المدمجة والأدوات السريعة
  static TextStyle get buttonSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeButtonSmall,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// خط الزر التقليدي (للتوافقية العكسية)
  static TextStyle get buttonText => buttonLarge;

  /// Material 3 Label Aliases
  static TextStyle get labelLarge => buttonLarge;
  static TextStyle get labelMedium => buttonMedium;
  static TextStyle get labelSmall => buttonSmall;

  /// Input Helper & Error Aliases
  static TextStyle get errorText => inputError;
  static TextStyle get helperText => caption;

  // ===========================================================================
  // 6. حقول الإدخال والنماذج (Input & Form Tokens)
  // ===========================================================================

  /// النص المدخل داخل الحقل (13px, Medium)
  static TextStyle get inputText => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeInputText,
    fontWeight: medium,
    letterSpacing: 0.0,
    height: 1.3,
  );

  /// نص التلميح داخل الحقل (13px, Regular)
  static TextStyle get inputHint => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeInputHint,
    fontWeight: regular,
    letterSpacing: 0.0,
    height: 1.3,
  );

  /// عنوان الحقل العلوي (12px, SemiBold)
  static TextStyle get inputLabel => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeInputLabel,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.3,
  );

  /// رسالة خطأ التحقق (11px, Medium)
  static TextStyle get inputError => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeInputError,
    fontWeight: medium,
    letterSpacing: 0.0,
    height: 1.25,
  );

  // ===========================================================================
  // 7. المعاملات المالية والمبالغ (Financial & Currency Tokens)
  // ===========================================================================

  /// رصيد المحفظة وإحصائيات الـ KPI الرئيسية (28px, ExtraBold)
  static TextStyle get currencyHero => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeCurrencyHero,
    fontWeight: extraBold,
    letterSpacing: 0.0,
    height: 1.15,
  );

  /// مبالغ بنود الفواتير والجداول (16px, Bold)
  static TextStyle get currencyMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeCurrencyMedium,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// رمز العملة المصغر بجانب الرقم (11px, SemiBold)
  static TextStyle get currencySymbol => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeCurrencySymbol,
    fontWeight: semiBold,
    letterSpacing: 0.0,
    height: 1.2,
  );

  // ===========================================================================
  // 8. الوسوم والبادجات والملاحظات (Chips, Badges, & Metadata)
  // ===========================================================================

  /// نصوص الشرائح والفلترة (12px, Medium)
  static TextStyle get chipText => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeChip,
    fontWeight: medium,
    letterSpacing: 0.0,
    height: 1.2,
  );

  /// شارات الحالة والوسوم الدلالية (11px, Bold)
  static TextStyle get badgeText => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeBadge,
    fontWeight: bold,
    letterSpacing: 0.0,
    height: 1.15,
  );

  /// نصوص التواريخ والتوقيتات التوضيحية (11px, Medium)
  static TextStyle get caption => const TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeCaption,
    fontWeight: medium,
    letterSpacing: 0.0,
    height: 1.35,
  );

  // ===========================================================================
  // 9. مولّد ثيم فلاتر الرسمي (Material 3 TextTheme Generator)
  // ===========================================================================

  /// يُحقن مباشرة داخل `ThemeData(textTheme: AppTypography.textTheme)`
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: buttonLarge,
    labelMedium: buttonMedium,
    labelSmall: buttonSmall,
  );
}
