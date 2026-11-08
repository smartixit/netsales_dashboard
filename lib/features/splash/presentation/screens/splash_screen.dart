import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_motion.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/splash/presentation/controllers/splash_controller.dart';

/// Lightweight startup surface; all startup decisions remain in SplashController.
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.entityEmerald(context),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xxl),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: AppMotion.duration(context, AppMotion.normal),
              curve: AppMotion.decelerate,
              builder: (context, opacity, child) => Opacity(
                opacity: opacity,
                child: child,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/brand_icon.png',
                    width: 76,
                    height: 76,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.hub_rounded,
                      size: 72,
                      color: colors.tertiaryFixed,
                    ),
                  ),
                  AppSpacing.vLg,
                  Text(
                    'NetSales',
                    style: AppTypography.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.vXs,
                  Text(
                    'منصة إدارة الأعمال',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ),
                  AppSpacing.vXxl,
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: colors.tertiaryFixed,
                    ),
                  ),
                  AppSpacing.vMd,
                  Text(
                    'جارٍ تهيئة المنصة والتحقق من الجلسة',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.68),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
