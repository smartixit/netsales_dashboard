import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_themes.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

void main() {
  group('Desktop design-system logical-pixel tokens', () {
    test('typography remains at desktop logical-pixel sizes', () {
      expect(AppTypography.displayLarge.fontSize, 36);
      expect(AppTypography.displayMedium.fontSize, 28);
      expect(AppTypography.displaySmall.fontSize, 24);
      expect(AppTypography.headlineLarge.fontSize, 22);
      expect(AppTypography.titleMedium.fontSize, 14);
      expect(AppTypography.bodyMedium.fontSize, 13);
      expect(AppTypography.bodySmall.fontSize, 12);
      expect(AppTypography.buttonLarge.fontSize, 14);
      expect(AppTypography.inputText.fontSize, 13);
      expect(AppTypography.currencyHero.fontSize, 28);
    });

    test('line heights are unitless multipliers, not scaled dimensions', () {
      expect(AppTypography.bodyMedium.height, 1.45);
      expect(AppTypography.headlineLarge.height, 1.3);
      expect(AppTypography.caption.height, 1.35);
      expect(AppTypography.bodyMedium.letterSpacing, 0);
    });

    test('spacing tokens remain stable logical pixels', () {
      expect(AppSpacing.md, 12);
      expect(AppSpacing.lg, 16);
      expect(AppSpacing.screenPadding, 24);
      expect(AppSpacing.cardPadding, 16);
      expect(AppSpacing.buttonPaddingH, 16);
      expect(AppSpacing.buttonPaddingV, 8);
      expect(AppSpacing.buttonHeight, 40);
      expect(AppSpacing.appBarHeight, 64);
      expect(AppSpacing.kpiStripHeight, 72);
      expect(AppSpacing.hMd.width, 12);
      expect(AppSpacing.vMd.height, 12);
    });

    test('radius tokens remain stable logical pixels', () {
      expect(AppRadius.sm, 8);
      expect(AppRadius.card, 16);
      expect(AppRadius.dialog, 24);
      expect(AppRadius.full, 999);
      expect(AppRadius.card, AppRadius.lg);
    });

    test('themes build without ScreenUtil initialization', () {
      final light = AppThemes.light;
      final dark = AppThemes.dark;

      expect(
        light.elevatedButtonTheme.style!.minimumSize!.resolve({})!.height,
        AppSpacing.buttonHeight,
      );
      expect(
        dark.inputDecorationTheme.contentPadding,
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPadding,
          vertical: AppSpacing.inputPadding,
        ),
      );
      expect(light.textTheme.bodyMedium!.fontSize, 13);
      expect(dark.textTheme.bodyMedium!.fontSize, 13);
    });
  });
}
