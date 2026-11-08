import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';

class PlatformUserInformationSection extends StatelessWidget {
  const PlatformUserInformationSection({
    super.key,
    required this.detail,
    required this.l10n,
  });
  final PlatformUserDetailEntity detail;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CustomSectionHeader(
        title: l10n.text('account_information'),
        description: l10n.text('account_information_description'),
      ),
      SizedBox(height: AppSpacing.md),
      Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 720
                ? 3
                : constraints.maxWidth >= 460
                ? 2
                : 1;
            final entries = [
              _Info(
                l10n.text('role_identifier'),
                detail.roleId.toString(),
                Icons.badge_outlined,
              ),
              _Info(
                l10n.text('two_factor_authentication'),
                detail.twoFactorEnabled
                    ? l10n.text('enabled')
                    : l10n.text('disabled'),
                Icons.verified_user_outlined,
              ),
              _Info(
                l10n.text('password_change_required'),
                detail.mustChangePassword ? l10n.text('yes') : l10n.text('no'),
                Icons.password_rounded,
              ),
              _Info(
                l10n.text('login_attempts'),
                detail.loginAttempts.toString(),
                Icons.lock_clock_outlined,
              ),
              _Info(
                l10n.text('created_at'),
                _date(detail.createdAt),
                Icons.calendar_today_outlined,
              ),
              _Info(
                l10n.text('updated_at'),
                _date(detail.updatedAt),
                Icons.update_rounded,
              ),
              _Info(
                l10n.text('last_login'),
                _date(detail.user.lastLoginAt),
                Icons.login_rounded,
              ),
            ];
            return Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: entries
                  .map(
                    (entry) => SizedBox(
                      width:
                          (constraints.maxWidth -
                              (AppSpacing.lg * (columns - 1))) /
                          columns,
                      child: _InfoTile(entry: entry),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    ],
  );

  String _date(DateTime? value) {
    if (value == null) return l10n.text('not_available');
    final date = value.toLocal();
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}

class _Info {
  const _Info(this.label, this.value, this.icon);
  final String label;
  final String value;
  final IconData icon;
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.entry});
  final _Info entry;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(entry.icon, size: 19, color: context.colors.primary),
      SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.label,
              style: AppTypography.caption.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            Text(
              entry.value,
              style: AppTypography.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}
