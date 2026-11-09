import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/login_brand_panel.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_theme_toggle_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/desktop_title_bar.dart';

/// الهيكل التفاعلي المشترك لواجهات الدخول في بيئة Windows Desktop.
///
/// يحافظ على فصل مساحة الهوية عن نموذج الدخول، مع:
/// - لوحة علامة تجارية ذات تسلسل بصري مستقل للشاشات المكتبية.
/// - نموذج محدود العرض ومتمركز رأسياً عندما تسمح مساحة النافذة.
/// - تمرير آمن وكثافة رأسية أقل للنوافذ المكتبية القصيرة.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.footer,
    this.progress,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final Widget? footer;
  final Widget? progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: LayoutBuilder(
        builder: (context, viewportConstraints) {
          return SizedBox(
            width: viewportConstraints.maxWidth,
            height: viewportConstraints.maxHeight,
            child: Column(
              children: [
                const DesktopTitleBar(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final showBrandPanel =
                          constraints.maxWidth >= AppBreakpoints.tabletMax;

                      if (!showBrandPanel) {
                        return _buildForm(context, compactBrand: true);
                      }

                      return Row(
                        children: [
                          const Expanded(flex: 5, child: LoginBrandPanel()),
                          Expanded(
                            flex: 6,
                            child: _buildForm(context, compactBrand: false),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, {required bool compactBrand}) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compactHeight =
            constraints.maxHeight < AppBreakpoints.desktopCompactHeightMax;
        final horizontalPadding = constraints.maxWidth < 520
            ? AppSpacing.md
            : AppSpacing.xxxl;
        final verticalPadding = compactHeight
            ? AppSpacing.md
            : AppSpacing.xxl;
        final availableContentHeight =
            (constraints.maxHeight - (verticalPadding * 2))
                .clamp(0.0, double.infinity)
                .toDouble();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: availableContentHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxFormWidth,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Top Controls ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (compactBrand)
                          const Expanded(child: _CompactBrandHeader())
                        else
                          const Spacer(),
                        AppSpacing.hSm,
                        const CustomThemeToggleButton(),
                      ],
                    ),

                    SizedBox(
                      height: compactHeight ? AppSpacing.md : AppSpacing.xl,
                    ),

                    // ── Authentication Identity ──
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        padding: EdgeInsets.all(
                          compactHeight ? AppSpacing.sm : AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Icon(icon, size: 24, color: colors.primary),
                      ),
                    ),

                    AppSpacing.vLg,

                    Text(
                      title,
                      style: AppTypography.headlineLarge.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    AppSpacing.vXs,
                    Text(
                      subtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.start,
                    ),

                    if (progress != null) ...[
                      SizedBox(
                        height: compactHeight ? AppSpacing.md : AppSpacing.lg,
                      ),
                      progress!,
                    ],

                    SizedBox(
                      height: compactHeight
                          ? AppSpacing.lg
                          : AppSpacing.xxl,
                    ),

                    child,

                    if (footer != null) ...[
                      AppSpacing.vXxl,
                      footer!,
                    ],

                    AppSpacing.vXxl,

                    Text(
                      '© 2026 منصة NetSales • كافة الحقوق محفوظة',
                      style: AppTypography.badgeText.copyWith(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompactBrandHeader extends StatelessWidget {
  const _CompactBrandHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            'assets/images/brand_icon.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.hub_rounded, color: colors.primary, size: 20),
          ),
        ),
        AppSpacing.hSm,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'NetSales',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'منصة إدارة العمليات',
                style: AppTypography.badgeText.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
