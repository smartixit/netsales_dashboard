import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';

/// Consistent responsive page inset for Platform Scope workspaces.
class PlatformWorkspaceFrame extends StatelessWidget {
  const PlatformWorkspaceFrame({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ??
            EdgeInsetsDirectional.fromSTEB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
        child: child,
      );
}
