import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';

/// لوحة الهوية المؤسسية لواجهة NetSales Platform Dashboard.
///
/// تبني حضور العلامة التجارية والتسلسل الهرمي للمزايا دون تكرار ثلاث
/// بطاقات متساوية بصرياً؛ الميزة الأمنية بارزة، وبقية الركائز أكثر هدوءاً.
class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactHeight =
            constraints.maxHeight < AppBreakpoints.desktopCompactHeightMax;
        final narrowPanel = constraints.maxWidth < 460;
        final horizontalPadding = narrowPanel
            ? AppSpacing.lg
            : AppSpacing.xxxl;
        final verticalPadding = compactHeight
            ? AppSpacing.lg
            : AppSpacing.xxl;
        final sectionGap = compactHeight
            ? AppSpacing.xl
            : AppSpacing.xxxl;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.entityEmerald(context),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Ambient lighting remains subtle and non-interactive.
              PositionedDirectional(
                top: -120,
                end: -100,
                child: _BrandAura(size: 380, alpha: 0.08),
              ),
              PositionedDirectional(
                bottom: -160,
                start: -100,
                child: _BrandAura(size: 420, alpha: 0.06),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      horizontalPadding,
                      verticalPadding,
                      horizontalPadding,
                      verticalPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BrandHeader(),
                          SizedBox(height: sectionGap),

                          // Small product descriptor establishes a clear
                          // hierarchy before the primary brand statement.
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6EE7B7),
                                  ),
                                ),
                                AppSpacing.hXs,
                                Text(
                                  'منصة تشغيل مؤسسية',
                                  style: AppTypography.badgeText.copyWith(
                                    color: Colors.white.withValues(alpha: 0.82),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          AppSpacing.vMd,

                          Text(
                            'إدارة متكاملة.\nوقرارات مالية دقيقة.',
                            style: AppTypography.displaySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.22,
                            ),
                          ),

                          AppSpacing.vMd,

                          Text(
                            'المساحة الموحدة لحوكمة شبكات التوزيع ونقاط البيع، ومتابعة العمليات والحسابات المالية بدقة وموثوقية.',
                            style: AppTypography.bodyLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.84),
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: sectionGap),

                          Row(
                            children: [
                              Text(
                                'ركائز المنصة',
                                style: AppTypography.titleSmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.82),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              AppSpacing.hMd,
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withValues(alpha: 0.16),
                                ),
                              ),
                            ],
                          ),

                          AppSpacing.vSm,

                          const _PillarHighlightCard(
                            icon: Icons.shield_outlined,
                            title: 'أمان الحسابات والبيانات',
                            subtitle:
                                'مصادقة موثوقة وحماية مستمرة لكل جلسة عمل',
                            prominent: true,
                          ),
                          AppSpacing.vSm,
                          const _PillarHighlightCard(
                            icon: Icons.account_balance_outlined,
                            title: 'حوكمة مالية متكاملة',
                            subtitle:
                                'قيود ومعاملات دقيقة من خادم النظام الموثوق',
                          ),
                          AppSpacing.vSm,
                          const _PillarHighlightCard(
                            icon: Icons.speed_rounded,
                            title: 'أداء فائق واستقرار دائم',
                            subtitle:
                                'بنية تشغيلية مصممة خصيصاً لبيئة Windows Desktop',
                          ),

                          SizedBox(height: sectionGap),

                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF34D399),
                                ),
                              ),
                              AppSpacing.hSm,
                              Expanded(
                                child: Text(
                                  'NETSALES PLATFORM • DESKTOP EDITION',
                                  style: AppTypography.badgeText.copyWith(
                                    color: Colors.white.withValues(alpha: 0.64),
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Semantics(
            label: 'NetSales',
            image: true,
            child: Image.asset(
              'assets/images/brand_icon.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.hub_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        AppSpacing.hMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NetSales',
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              AppSpacing.vXxs,
              Text(
                'منصة إدارة الحسابات والعمليات',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.76),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BrandAura extends StatelessWidget {
  const _BrandAura({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withValues(alpha: alpha),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7],
          ),
        ),
      ),
    );
  }
}

class _PillarHighlightCard extends StatelessWidget {
  const _PillarHighlightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.prominent = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final cardPadding = prominent
        ? const EdgeInsets.all(AppSpacing.md)
        : const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          );
    final iconSize = prominent ? 44.0 : 38.0;

    return Container(
      padding: cardPadding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: prominent ? 0.12 : 0.035,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: prominent ? 0.24 : 0.06,
          ),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: prominent ? 0.17 : 0.09,
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              icon,
              color: Colors.white.withValues(alpha: prominent ? 1 : 0.88),
              size: prominent ? 21 : 19,
            ),
          ),
          AppSpacing.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (prominent
                          ? AppTypography.titleMedium
                          : AppTypography.titleSmall)
                      .copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.vXxs,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.74),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
