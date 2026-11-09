import 'package:flutter/material.dart';

/// Desktop-first spacing tokens expressed in Flutter logical pixels (dp).
///
/// These values are intentionally independent of the physical window size.
/// Use AppBreakpoints and layout constraints to adapt composition; never scale
/// the shared spacing scale linearly with the desktop window dimensions.
class AppSpacing {
  AppSpacing._();

  static const double zero = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double giant = 48;
  static const double section = 56;
  static const double sectionLg = 64;
  static const double sectionXl = 80;

  /// Default content inset. Wider windows should use AppBreakpoints.screenMargin.
  static const double screenPadding = 24;
  static const double cardPadding = 16;

  /// Compact desktop controls follow a 40 dp minimum height.
  static const double buttonHeight = 40;
  static const double buttonPaddingH = 16;
  static const double buttonPaddingV = 8;
  static const double inputPadding = 12;
  static const double listItemSpacing = 12;
  static const double gridSpacing = 16;
  static const double dialogPadding = 24;
  static const double bottomSheetPadding = 24;

  /// Desktop shell dimensions, all in stable logical pixels.
  static const double appBarHeight = 64;
  static const double bottomNavHeight = 56;
  static const double kpiStripHeight = 72;

  /// Compatibility token only; prefer the actual MediaQuery safe-area inset.
  static const double statusBarHeight = 24;

  static const SizedBox hXxs = SizedBox(width: xxs);
  static const SizedBox hXs = SizedBox(width: xs);
  static const SizedBox hSm = SizedBox(width: sm);
  static const SizedBox hMd = SizedBox(width: md);
  static const SizedBox hLg = SizedBox(width: lg);
  static const SizedBox hXl = SizedBox(width: xl);
  static const SizedBox hXxl = SizedBox(width: xxl);

  static const SizedBox vXxs = SizedBox(height: xxs);
  static const SizedBox vXs = SizedBox(height: xs);
  static const SizedBox vSm = SizedBox(height: sm);
  static const SizedBox vMd = SizedBox(height: md);
  static const SizedBox vLg = SizedBox(height: lg);
  static const SizedBox vXl = SizedBox(height: xl);
  static const SizedBox vXxl = SizedBox(height: xxl);
  static const SizedBox vHuge = SizedBox(height: huge);
  static const SizedBox vGiant = SizedBox(height: giant);
}
