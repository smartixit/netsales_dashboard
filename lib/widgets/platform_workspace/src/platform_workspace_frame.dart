import 'package:flutter/material.dart';

/// Shared workspace frame. The application shell already supplies page insets.
class PlatformWorkspaceFrame extends StatelessWidget {
  const PlatformWorkspaceFrame({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
}
