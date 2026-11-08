import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/splash/presentation/controllers/splash_controller.dart';

/// Interactive micro-fluid progress bar and phased status readout.
class SplashProgressBar extends StatelessWidget {
  const SplashProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Micro-Fluid Progress Bar ──
        Container(
          width: 260,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            color: Colors.white.withValues(alpha: 0.10),
          ),
          child: Obx(() {
            final progressValue = controller.progress.value.clamp(0.0, 1.0);
            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                widthFactor: progressValue,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0D9488),
                        Color(0xFF10B981),
                        Color(0xFF34D399),
                        Color(0xFF6EE7B7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.65),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        AppSpacing.vMd,

        // ── Phased Status Readout ──
        SizedBox(
          height: 24,
          child: Center(
            child: Obx(() {
              final message = controller.statusMessage.value;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                layoutBuilder: (currentChild, previousChildren) {
                  return currentChild ?? const SizedBox.shrink();
                },
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  message,
                  key: ValueKey<String>(message),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: const Color(0xFFA7F3D0).withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                    letterSpacing: 0.2,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
