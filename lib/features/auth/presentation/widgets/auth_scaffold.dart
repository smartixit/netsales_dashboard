import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_theme_toggle_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/desktop_title_bar.dart';

/// Shared visual frame for the Dashboard authentication journeys.
///
/// The form remains purpose-specific; this widget only provides the responsive
/// brand/form composition and the common visual hierarchy.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const DesktopTitleBar(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final showBrandPanel =
                      constraints.maxWidth >= AppBreakpoints.tabletMax;

                  if (showBrandPanel) {
                    return Row(
                      children: [
                        const Expanded(flex: 5, child: _AuthBrandPanel()),
                        Expanded(
                          flex: 7,
                          child: _buildForm(context, compactBrand: false),
                        ),
                      ],
                    );
                  }

                  return _buildForm(context, compactBrand: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context, {
    required bool compactBrand,
  }) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.xxl,
        compactBrand ? AppSpacing.xl : AppSpacing.xxxl,
        AppSpacing.xxl,
        AppSpacing.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxFormWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [CustomThemeToggleButton()],
              ),
              if (compactBrand) ...[
                const _CompactBrandHeader(),
                AppSpacing.vXxl,
              ],
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Icon(icon, size: 26, color: colors.primary),
                ),
              ),
              AppSpacing.vLg,
              Text(
                title,
                style: AppTypography.headlineSmall.copyWith(
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.start,
              ),
              AppSpacing.vXs,
              Text(
                subtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.6,
                ),
                textAlign: TextAlign.start,
              ),
              AppSpacing.vXxl,
              child,
              if (footer != null) ...[
                AppSpacing.vXxl,
                footer!,
              ],
              AppSpacing.vXxl,
              Text(
                '© 2026 NetSales Platform',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthBrandPanel extends StatelessWidget {
  const _AuthBrandPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.entityEmerald(context),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: -100,
            end: -110,
            child: _BrandOrb(size: 330),
          ),
          PositionedDirectional(
            bottom: -150,
            start: -120,
            child: _BrandOrb(size: 390),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xxxl),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BrandIdentity(onDark: true),
                    SizedBox(height: AppSpacing.section),
                    Text(
                      'إدارة أكثر وضوحاً.\nوقرارات أكثر ثقة.',
                      style: AppTypography.headlineLarge.copyWith(
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                    AppSpacing.vLg,
                    Text(
                      'مساحة موحدة لإدارة منصة NetSales ومتابعة عملياتها '
                      'العالمية من مكان واحد.',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.78),
                        height: 1.8,
                      ),
                    ),
                    AppSpacing.vXxl,
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: colors.tertiaryFixed,
                            size: 24,
                          ),
                          AppSpacing.hMd,
                          Expanded(
                            child: Text(
                              'وصول آمن وصلاحيات تُدار من الخادم',
                              style: AppTypography.titleSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.section),
                    Text(
                      'NETSALES  •  PLATFORM CONTROL',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.58),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandOrb extends StatelessWidget {
  const _BrandOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.055),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _CompactBrandHeader extends StatelessWidget {
  const _CompactBrandHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Image.asset(
            'assets/images/brand_icon.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(Icons.hub_rounded, color: colors.primary),
            ),
          ),
        ),
        AppSpacing.hMd,
        const Expanded(child: _BrandIdentity(onDark: false)),
      ],
    );
  }
}

class _BrandIdentity extends StatelessWidget {
  const _BrandIdentity({required this.onDark});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final foreground = onDark ? Colors.white : context.colors.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NetSales',
          style: AppTypography.titleLarge.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.vXxs,
        Text(
          'منصة إدارة الأعمال',
          style: AppTypography.labelMedium.copyWith(
            color: onDark
                ? Colors.white.withValues(alpha: 0.68)
                : context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
