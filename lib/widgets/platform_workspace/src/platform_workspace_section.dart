import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';

/// Reusable semantic section for directory summaries and operational groups.
class PlatformWorkspaceSection extends StatelessWidget {
  const PlatformWorkspaceSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.leading,
    this.action,
  });

  final String title;
  final String? description;
  final Widget? leading;
  final Widget? action;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSectionHeader(
            title: title,
            description: description,
            leading: leading,
            action: action,
          ),
          AppSpacing.vMd,
          child,
        ],
      );
}
