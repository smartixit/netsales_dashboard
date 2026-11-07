import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomSkeletonShimmer extends StatelessWidget {
  const CustomSkeletonShimmer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    highlightColor: Theme.of(context).colorScheme.surface,
    child: child,
  );
}
