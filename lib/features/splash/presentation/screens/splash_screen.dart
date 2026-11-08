import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/splash/presentation/controllers/splash_controller.dart';
import 'package:netsales_dashboard/features/splash/presentation/widgets/splash_brand_badge.dart';
import 'package:netsales_dashboard/features/splash/presentation/widgets/splash_footer_watermark.dart';
import 'package:netsales_dashboard/features/splash/presentation/widgets/splash_progress_bar.dart';

/// Ultra-luxurious frameless startup surface for the NetSales Platform Dashboard.
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF031610),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.2,
          ),
          gradient: const RadialGradient(
            center: Alignment(0.0, -0.45),
            radius: 1.15,
            colors: [
              Color(0xFF0D5442),
              Color(0xFF063528),
              Color(0xFF031C15),
              Color(0xFF02120D),
            ],
            stops: [0.0, 0.40, 0.75, 1.0],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl - 1),
          child: Stack(
            children: [
              // ── Atmospheric Ambient Radial Glow Behind Brand Badge ──
              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 220,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.16),
                          blurRadius: 90,
                          spreadRadius: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Center Content: Brand, Title, Fluid Progress ──
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SplashBrandBadge(),
                      AppSpacing.vLg,
                      Text(
                        'NetSales',
                        style: AppTypography.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          letterSpacing: -0.6,
                        ),
                      ),
                      AppSpacing.vXs,
                      Text(
                        'المنصة السحابية الموحدة لإدارة الأعمال والعمليات',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFFA7F3D0).withValues(alpha: 0.82),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                      AppSpacing.vXl,
                      const SplashProgressBar(),
                    ],
                  ),
                ),
              ),

              // ── Window Footer Metadata ──
              const Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: SplashFooterWatermark(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
