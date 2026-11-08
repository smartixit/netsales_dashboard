import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';

class PlatformNetworkInformationSection extends StatelessWidget {
  const PlatformNetworkInformationSection({
    required this.network,
    required this.l10n,
    super.key,
  });

  final PlatformNetworkEntity network;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final fields = <(String, String, IconData)>[
      (
        l10n.text('network_owner'),
        network.ownerName ?? '—',
        Icons.person_outline_rounded,
      ),
      (
        l10n.text('network_phone'),
        network.phoneNumber ?? '—',
        Icons.phone_outlined,
      ),
      (l10n.text('email'), network.email ?? '—', Icons.email_outlined),
      (
        l10n.text('network_governorate'),
        network.governorateName ?? '—',
        Icons.map_outlined,
      ),
      (
        l10n.text('network_directorate'),
        network.directorateName ?? '—',
        Icons.location_city_outlined,
      ),
      (
        l10n.text('network_address'),
        network.address ?? '—',
        Icons.place_outlined,
      ),
      (
        l10n.text('created_at'),
        _date(network.createdAt),
        Icons.calendar_today_outlined,
      ),
      (l10n.text('updated_at'), _date(network.updatedAt), Icons.update_rounded),
    ];

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.text('network_information'),
            style: AppTypography.titleLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            l10n.text('network_information_description'),
            style: AppTypography.bodySmall.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 760 ? 2 : 1;
              final width =
                  (constraints.maxWidth - AppSpacing.md * (columns - 1)) /
                  columns;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.lg,
                children: [
                  for (final field in fields)
                    SizedBox(
                      width: width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: context.colors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Icon(
                              field.$3,
                              size: 18,
                              color: context.colors.primary,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field.$1,
                                  style: AppTypography.caption.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xxs),
                                Text(
                                  field.$2,
                                  style: AppTypography.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _date(DateTime? value) {
    if (value == null) return '—';
    final local = value.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}
