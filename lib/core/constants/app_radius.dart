import 'package:flutter/material.dart';

/// Radius tokens are stable logical pixels, not screen-relative measurements.
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 28;
  static const double full = 999;

  static const double button = 16;
  static const double input = 12;
  static const double card = 16;
  static const double dialog = 24;
  static const double bottomSheet = 24;
  static const double chip = 8;
  static const double avatar = 999;
  static const double snackbar = 12;
  static const double tooltip = 8;

  static BorderRadius get noneRadius => BorderRadius.circular(none);
  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);

  static BorderRadius get topLg =>
      BorderRadius.vertical(top: Radius.circular(lg));
  static BorderRadius get topXl =>
      BorderRadius.vertical(top: Radius.circular(xl));
  static BorderRadius get topXxl =>
      BorderRadius.vertical(top: Radius.circular(xxl));

  static BorderRadius get bottomLg =>
      BorderRadius.vertical(bottom: Radius.circular(lg));
  static BorderRadius get bottomXl =>
      BorderRadius.vertical(bottom: Radius.circular(xl));

  static BorderRadius get leftLg =>
      BorderRadius.horizontal(left: Radius.circular(lg));
  static BorderRadius get rightLg =>
      BorderRadius.horizontal(right: Radius.circular(lg));
}
