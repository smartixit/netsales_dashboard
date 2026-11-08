import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';

/// Glassmorphic emblem badge for NetSales platform branding during startup.
class SplashBrandBadge extends StatelessWidget {
  const SplashBrandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.24),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.28),
            blurRadius: 32,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Image.asset(
          'assets/images/brand_icon.png',
          width: 58,
          height: 58,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.hub_rounded,
            size: 48,
            color: colors.tertiaryFixed,
          ),
        ),
      ),
    )
        .animate()
        .scale(
          duration: 500.ms,
          curve: Curves.easeOutBack,
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.0, 1.0),
        )
        .fadeIn(duration: 400.ms)
        .shimmer(
          delay: 700.ms,
          duration: 1800.ms,
          color: Colors.white.withValues(alpha: 0.18),
        );
  }
}

