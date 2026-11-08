import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/enums/device_type.dart';
import 'package:netsales_dashboard/core/enums/user_device_status.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_users/domain/entities/platform_user_detail_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';

class PlatformUserSecuritySection extends StatelessWidget {
  const PlatformUserSecuritySection({
    super.key,
    required this.detail,
    required this.sessions,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    required this.l10n,
  });
  final PlatformUserDetailEntity detail;
  final List<PlatformUserSessionEntity> sessions;
  final bool isLoading;
  final String error;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CustomSectionHeader(
        title: l10n.text('security_overview'),
        description: l10n.text('security_overview_description'),
      ),
      SizedBox(height: AppSpacing.md),
      _Surface(
        title: l10n.text('registered_devices'),
        count: detail.devices.length,
        child: detail.devices.isEmpty
            ? _Empty(text: l10n.text('no_registered_devices'))
            : Column(
                children: detail.devices.map((device) {
                  final status =
                      EnumPresentationRegistry.resolveUserDeviceStatus(
                        UserDeviceStatus.fromWire(device.status),
                        serverLabel: device.statusLabel,
                      );
                  final type = EnumPresentationRegistry.resolveDeviceType(
                    DeviceType.fromWire(device.type),
                    serverLabel: device.typeLabel,
                  );
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      type.icon,
                      color: context.colors.onSurfaceVariant,
                    ),
                    title: Text(device.name, style: AppTypography.titleSmall),
                    subtitle: Text(
                      '${type.label} · ${device.lastUsedAt?.toLocal().toString() ?? l10n.text('not_available')}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomStatusBadge.fromPresentation(
                          status,
                          isCompact: true,
                        ),
                        if (device.isPrimary)
                          Text(
                            l10n.text('primary_device'),
                            style: AppTypography.caption.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
      SizedBox(height: AppSpacing.md),
      _Surface(
        title: l10n.text('active_sessions'),
        count: sessions.length,
        child: isLoading
            ? const LinearProgressIndicator()
            : error.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  CustomButton.secondary(
                    text: l10n.text('retry'),
                    onPressed: onRetry,
                  ),
                ],
              )
            : sessions.isEmpty
            ? _Empty(text: l10n.text('no_active_sessions'))
            : Column(
                children: sessions
                    .map(
                      (session) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.devices_other_rounded),
                        title: Text(
                          session.userAgent?.trim().isNotEmpty == true
                              ? session.userAgent!
                              : l10n.text('unknown_device'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium,
                        ),
                        subtitle: Text(
                          '${session.ipAddress ?? l10n.text('not_available')} · ${session.lastActivityAt?.toLocal().toString() ?? l10n.text('not_available')}',
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
      if (detail.securityBans.isNotEmpty) ...[
        SizedBox(height: AppSpacing.md),
        _Surface(
          title: l10n.text('security_bans'),
          count: detail.securityBans.length,
          child: Column(
            children: detail.securityBans
                .map(
                  (ban) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.gpp_bad_outlined,
                      color: context.colors.error,
                    ),
                    title: Text(
                      ban.typeLabel ?? ban.type,
                      style: AppTypography.titleSmall,
                    ),
                    subtitle: Text(
                      ban.reason?.isNotEmpty == true
                          ? ban.reason!
                          : l10n.text('no_ban_reason'),
                    ),
                    trailing: Text(
                      ban.endsAt?.toLocal().toString() ??
                          l10n.text('permanent'),
                      style: AppTypography.caption,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ],
  );
}

class _Surface extends StatelessWidget {
  const _Surface({
    required this.title,
    required this.count,
    required this.child,
  });
  final String title;
  final int count;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(
        color: context.colors.outlineVariant.withValues(alpha: 0.55),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: AppTypography.titleMedium)),
            Text(
              count.toString(),
              style: AppTypography.labelMedium.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        child,
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Text(
      text,
      style: AppTypography.bodySmall.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
    ),
  );
}
