import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/enums/user_status.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformUserIdentityPanel extends StatelessWidget {
  const PlatformUserIdentityPanel({super.key, required this.detail, required this.l10n});
  final PlatformUserDetailEntity detail;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final user = detail.user;
    final status = EnumPresentationRegistry.resolveUserStatus(UserStatus.fromWire(user.status), serverLabel: user.statusLabel);
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        final identity = Row(children: [
          CustomCachedImage.avatar(
            url: user.profileImage,
            radius: 34,
            fallbackText: user.fullName.trim().isEmpty ? '?' : user.fullName.trim().substring(0, 1),
            fallbackTextStyle: AppTypography.titleLarge,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullName, style: AppTypography.titleLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: AppSpacing.xs),
              Text(user.roleName ?? l10n.text('role_not_assigned'), style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant)),
              SizedBox(height: AppSpacing.sm),
              CustomStatusBadge.fromPresentation(status, showDot: true),
            ],
          )),
        ]);
        final contact = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ContactLine(icon: Icons.phone_iphone_rounded, label: l10n.text('user_phone'), value: user.phoneNumber),
          if ((user.email ?? '').isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            _ContactLine(icon: Icons.email_outlined, label: l10n.text('email'), value: user.email!),
          ],
        ]);
        return compact
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [identity, SizedBox(height: AppSpacing.lg), contact])
            : Row(children: [Expanded(flex: 3, child: identity), SizedBox(width: AppSpacing.xl), Expanded(flex: 2, child: contact)]);
      }),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 18, color: context.colors.onSurfaceVariant),
    SizedBox(width: AppSpacing.sm),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.caption.copyWith(color: context.colors.onSurfaceVariant)),
      Text(value, style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
    ])),
  ]);
}
