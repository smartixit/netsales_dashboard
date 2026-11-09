import 'package:flutter/material.dart';

/// ============================================================================
/// نظام الألوان الموحد المركزي للمشروع بالكامل (Enterprise Unified Colors)
/// ============================================================================
/// يمثل المرجع الحصري والشامل لكافة ألوان التطبيق في مشروعي NetSales Dashboard و NetSales Dashboard API.
/// يدعم الوضعين الفاتح والداكن (Light & Dark) ديناميكياً بدون أي تكرار أو تشتت.
class AppColors {
  // ── 1. Primary Colors (هوية النظام الأساسية) ──
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;

  // ── 2. Secondary Colors (اللون الثانوي - تيل ناعم) ──
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;

  // ── 3. Tertiary Colors (اللون التكميلي - أخضر نعناعي للأرصدة والشبكات) ──
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color tertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;

  // ── 4. Error Colors (حالات الخطأ والرفض) ──
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color onErrorVariant;

  // ── 5. Success Colors (حالات النجاح والعمليات المعتمدة) ──
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color onSuccessVariant;

  // ── 6. Warning Colors (حالات التنبيه والانتظار) ──
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color onWarningVariant;

  // ── 7. Info Colors (المعلومات والملاحظات) ──
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color onInfoVariant;

  // ── 8. Surface & Surfaces Hierarchy (الخلفيات والبطاقات والأسطح) ──
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color surfaceTint;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;

  // ── 9. Background Colors ──
  final Color background;
  final Color onBackground;

  // ── 10. Inverse Colors ──
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;

  // ── 11. Outline & Borders ──
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;

  // ── 12. Disabled & States ──
  final Color disabled;
  final Color onDisabled;

  // ── 13. Dividers ──
  final Color divider;

  // ── 14. Gradients (التدرجات اللونية الموحدة) ──
  final List<Color> primaryGradient;
  final LinearGradient successGradient;
  final LinearGradient errorGradient;
  final LinearGradient warningGradient;
  final LinearGradient infoGradient;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.onErrorVariant,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.onSuccessVariant,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.onWarningVariant,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.onInfoVariant,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.surfaceTint,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.background,
    required this.onBackground,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.disabled,
    required this.onDisabled,
    required this.divider,
    required this.primaryGradient,
    required this.successGradient,
    required this.errorGradient,
    required this.warningGradient,
    required this.infoGradient,
  });

  /// ── الوصول الموحد التلقائي حسب الثيم النشط في الشاشة ──
  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkColors : lightColors;
  }

  // ===========================================================================
  // لوحة ألوان الوضع الفاتح (Light Palette)
  // ===========================================================================
  static const lightColors = AppColors(
    primary: Color(0xFF0D7A5F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD8EFE5),
    onPrimaryContainer: Color(0xFF064B38),
    primaryFixed: Color(0xFFD8EFE5),
    primaryFixedDim: Color(0xFFB6E3D0),
    onPrimaryFixed: Color(0xFF064B38),
    onPrimaryFixedVariant: Color(0xFF0B654A),

    secondary: Color(0xFF28748B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCEEF2),
    onSecondaryContainer: Color(0xFF164653),
    secondaryFixed: Color(0xFFDCEEF2),
    secondaryFixedDim: Color(0xFFB8DDE5),
    onSecondaryFixed: Color(0xFF164653),
    onSecondaryFixedVariant: Color(0xFF1E6075),

    tertiary: Color(0xFF6876A8),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE8EAF6),
    onTertiaryContainer: Color(0xFF303B69),
    tertiaryFixed: Color(0xFFE8EAF6),
    tertiaryFixedDim: Color(0xFFD1D5ED),
    onTertiaryFixed: Color(0xFF303B69),
    onTertiaryFixedVariant: Color(0xFF4A5688),

    error: Color(0xFFB93832),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFCE4E1),
    onErrorContainer: Color(0xFF611C18),
    onErrorVariant: Color(0xFFFFDAD6),

    success: Color(0xFF17764F),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFDDF1E6),
    onSuccessContainer: Color(0xFF145238),
    onSuccessVariant: Color(0xFFC8E6C9),

    warning: Color(0xFF9A6819),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFF7EBCF),
    onWarningContainer: Color(0xFF69470F),
    onWarningVariant: Color(0xFFFFE0B2),

    info: Color(0xFF326FA8),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFE0ECF7),
    onInfoContainer: Color(0xFF244D75),
    onInfoVariant: Color(0xFFBBDEFB),

    surface: Color(0xFFF7FAF8),
    onSurface: Color(0xFF18251E),
    surfaceVariant: Color(0xFFE7EEE9),
    onSurfaceVariant: Color(0xFF53655A),
    surfaceTint: Color(0xFF0D7A5F),
    surfaceDim: Color(0xFFE2EAE5),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F6F3),
    surfaceContainer: Color(0xFFECF2EE),
    surfaceContainerHigh: Color(0xFFE6EEE9),
    surfaceContainerHighest: Color(0xFFDDE7E0),

    background: Color(0xFFF3F6F4),
    onBackground: Color(0xFF18251E),

    inverseSurface: Color(0xFF2D312F),
    onInverseSurface: Color(0xFFEFF1EF),
    inversePrimary: Color(0xFF8CD6C2),

    outline: Color(0xFF718078),
    outlineVariant: Color(0xFFD5E0D9),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    disabled: Color(0xFFBFC9C4),
    onDisabled: Color(0xFF6F7975),

    divider: Color(0xFFE0E8E3),

    primaryGradient: [Color(0xFF0D7A5F), Color(0xFF28748B), Color(0xFF6876A8)],
    successGradient: LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF059669)],
    ),
    errorGradient: LinearGradient(
      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    ),
    warningGradient: LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    ),
    infoGradient: LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    ),
  );

  // ===========================================================================
  // لوحة ألوان الوضع الداكن (Dark Palette)
  // ===========================================================================
  static const darkColors = AppColors(
    primary: Color(0xFF35B98A),
    onPrimary: Color(0xFF062B20),
    primaryContainer: Color(0xFF174D3B),
    onPrimaryContainer: Color(0xFFC4F2DE),
    primaryFixed: Color(0xFFD8EFE5),
    primaryFixedDim: Color(0xFFB6E3D0),
    onPrimaryFixed: Color(0xFF064B38),
    onPrimaryFixedVariant: Color(0xFF0B654A),

    secondary: Color(0xFF6AB1C7),
    onSecondary: Color(0xFF082D37),
    secondaryContainer: Color(0xFF244B58),
    onSecondaryContainer: Color(0xFFDDF4FA),
    secondaryFixed: Color(0xFFDCEEF2),
    secondaryFixedDim: Color(0xFFB8DDE5),
    onSecondaryFixed: Color(0xFF164653),
    onSecondaryFixedVariant: Color(0xFF1E6075),

    tertiary: Color(0xFFAAA8DC),
    onTertiary: Color(0xFF28274D),
    tertiaryContainer: Color(0xFF45436F),
    onTertiaryContainer: Color(0xFFE8EAF6),
    tertiaryFixed: Color(0xFFE8EAF6),
    tertiaryFixedDim: Color(0xFFD1D5ED),
    onTertiaryFixed: Color(0xFF303B69),
    onTertiaryFixedVariant: Color(0xFF4A5688),

    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    onErrorVariant: Color(0xFFFFDAD6),

    success: Color(0xFF81C784),
    onSuccess: Color(0xFF1B5E20),
    successContainer: Color(0xFF2E7D32),
    onSuccessContainer: Color(0xFFC8E6C9),
    onSuccessVariant: Color(0xFFC8E6C9),

    warning: Color(0xFFFFB74D),
    onWarning: Color(0xFF6D4C00),
    warningContainer: Color(0xFFF57C00),
    onWarningContainer: Color(0xFFFFE0B2),
    onWarningVariant: Color(0xFFFFE0B2),

    info: Color(0xFF90CAF9),
    onInfo: Color(0xFF0D47A1),
    infoContainer: Color(0xFF1976D2),
    onInfoContainer: Color(0xFFBBDEFB),
    onInfoVariant: Color(0xFFBBDEFB),

    surface: Color(0xFF111C17),
    onSurface: Color(0xFFE8F1EB),
    surfaceVariant: Color(0xFF26372F),
    onSurfaceVariant: Color(0xFFA7B8AE),
    surfaceTint: Color(0xFF47C79A),
    surfaceDim: Color(0xFF09110D),
    surfaceBright: Color(0xFF2D4036),
    surfaceContainerLowest: Color(0xFF0D1712),
    surfaceContainerLow: Color(0xFF111D18),
    surfaceContainer: Color(0xFF16231C),
    surfaceContainerHigh: Color(0xFF1B2A22),
    surfaceContainerHighest: Color(0xFF23362B),

    background: Color(0xFF0B1411),
    onBackground: Color(0xFFE8F1EB),

    inverseSurface: Color(0xFFE0E3E1),
    onInverseSurface: Color(0xFF191C1B),
    inversePrimary: Color(0xFF0D7A5F),

    outline: Color(0xFF7D9385),
    outlineVariant: Color(0xFF34483B),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    disabled: Color(0xFF3F4945),
    onDisabled: Color(0xFF89938E),

    divider: Color(0xFF263A30),

    primaryGradient: [Color(0xFF35BE8F), Color(0xFF69C6B5), Color(0xFF85B4D1)],
    successGradient: LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF059669)],
    ),
    errorGradient: LinearGradient(
      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    ),
    warningGradient: LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    ),
    infoGradient: LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    ),
  );
}

/// ============================================================================
/// امتداد فائق السهولة على BuildContext للوصول السريع والموحد للألوان
/// ============================================================================
extension AppColorsExtension on BuildContext {
  /// الوصول المباشر لكافة ألوان النظام:
  /// context.colors.primary
  /// context.colors.success
  /// context.colors.surface
  AppColors get colors => AppColors.of(this);

  /// للتوافقية العكسية مع أي استدعاءات سابقة:
  AppColors get appColors => AppColors.of(this);
}
