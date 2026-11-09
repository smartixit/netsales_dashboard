import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

@immutable
class DashboardPageHeaderData {
  const DashboardPageHeaderData({
    required this.title,
    this.description,
    this.icon,
    this.actions = const [],
  });
  final String title;
  final String? description;
  final IconData? icon;
  final List<Widget> actions;
}

class DashboardPageHeader extends StatelessWidget {
  const DashboardPageHeader({required this.data, super.key});
  final DashboardPageHeaderData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;
        final heading = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (data.icon != null) ...[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.72),
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.12),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(data.icon, color: colors.onPrimaryContainer),
              ),
              AppSpacing.hMd,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTypography.headlineMedium.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (data.description != null) ...[
                    AppSpacing.vXxs,
                    Text(
                      data.description!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
        if (data.actions.isEmpty) return heading;
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading,
              AppSpacing.vMd,
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: data.actions,
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: heading),
            AppSpacing.hMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: data.actions,
            ),
          ],
        );
      },
    );
  }
}
