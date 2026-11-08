import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/enums/network_status.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';

class PlatformNetworkStatusBadge extends StatelessWidget {
  const PlatformNetworkStatusBadge({
    required this.status,
    this.statusLabel,
    this.compact = true,
    super.key,
  });

  final String status;
  final String? statusLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) => CustomStatusBadge.fromPresentation(
    EnumPresentationRegistry.resolveNetworkStatus(
      NetworkStatus.fromWire(status),
      serverLabel: statusLabel,
    ),
    isCompact: compact,
    showDot: true,
  );
}
