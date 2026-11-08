import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/login_brand_panel.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_theme_toggle_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/desktop_title_bar.dart';

/// الهيكل التفاعلي المشترك لواجهات الدخول في بيئة Windows Desktop
///
/// يوفر تقسيماً متجاوباً وفاخراً:
/// - لوحة الهوية المؤسسية (Brand Panel) للشاشات الكبيرة ومتوسطة الحجم.
/// - حاوية النموذج المركزية مع شريط العنوان المكتبي وزر تبديل السمة (Light/Dark).
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
                        const Expanded(flex: 5, child: LoginBrandPanel()),
                        Expanded(
                          flex: 6,
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

  Widget _buildForm(BuildContext context, {required bool compactBrand}) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.xxl,
        compactBrand ? AppSpacing.xl : AppSpacing.xxl,
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
              // ── Top Controls Bar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (compactBrand)
                    const _CompactBrandHeader()
                  else
                    const SizedBox.shrink(),
                  const CustomThemeToggleButton(),
                ],
              ),

              AppSpacing.vXl,

              // ── Header Icon Badge ──
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.5),
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

              // ── Title & Subtitle ──
              Text(
                title,
                style: AppTypography.headlineMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
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

              AppSpacing.vXl,

              // ── Form Child ──
              child,

              if (footer != null) ...[AppSpacing.vXxl, footer!],

              AppSpacing.vXxl,

              // ── Platform Copyright Footer ──
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NetSales',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w900,
                color: colors.onSurface,
              ),
            ),
            Text(
              'منصة إدارة العمليات',
              style: AppTypography.badgeText.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
