import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// لوحة الهوية المؤسسية الفاخرة للواجهة الرئيسية (Login Brand Panel)
///
/// توفر تجربة بصرية عميقة وراقية تعكس حوكمة واستقرار منصة NetSales
/// مع أوربات محيطية ناعمة، وبطاقات مؤشرات تشغيلية مهدئة للمستخدم.
class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppGradients.entityEmerald(context)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Ambient Background Orbs ──
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

          // ── Foreground Content ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl,
                  vertical: AppSpacing.xxl,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Brand Header ──
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.2,
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/brand_icon.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.hub_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                            ),
                          ),
                          AppSpacing.hMd,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NetSales',
                                style: AppTypography.titleSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'منصة إدارة الحسابات والعمليات',
                                style: AppTypography.titleSmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: AppSpacing.section),

                      // ── Headline ──
                      Text(
                        'إدارة متكاملة.\nوقرارات مالية دقيقة.',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),

                      AppSpacing.vLg,

                      Text(
                        'المساحة الموحدة لحوكمة شبكات التوزيع ونقاط البيع، ومتابعة العمليات والحسابات المالية بدقة وسرعة فائقة.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          height: 1.7,
                        ),
                      ),

                      AppSpacing.vMd,

                      // ── Interactive Pillar Cards ──
                      _PillarHighlightCard(
                        icon: Icons.shield_outlined,
                        title: 'أمان الحسابات والبيانات',
                        subtitle: 'مصادقة ثنائية وتوثيق عتادي صارم لكل جلسة',
                        accentColor: colors.tertiaryFixed,
                      ),
                      AppSpacing.vMd,
                      _PillarHighlightCard(
                        icon: Icons.account_balance_outlined,
                        title: 'حوكمة مالية متكاملة',
                        subtitle:
                            'مزامنة قيود ومعاملات دقيقة من خادم النظام الموثوق',
                        accentColor: colors.secondaryFixed,
                      ),
                      AppSpacing.vMd,
                      _PillarHighlightCard(
                        icon: Icons.speed_rounded,
                        title: 'أداء فائق واستقرار دائم',
                        subtitle:
                            'بنية تشغيلية مصممة خصيصاً لبيئة Windows Desktop',
                        accentColor: Colors.white,
                      ),

                      SizedBox(height: AppSpacing.section),

                      // ── Platform Footer Tag ──
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF34D399),
                            ),
                          ),
                          AppSpacing.hSm,
                          Text(
                            'NETSALES PLATFORM • DESKTOP EDITION',
                            style: AppTypography.badgeText.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w600,
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
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          AppSpacing.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.vXxs,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
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
