import 'package:flutter/material.dart';

class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({
    super.key, required this.title, this.subtitle, this.badgeText,
    this.badgeIcon, this.icon = Icons.inbox_outlined, this.animationPath,
    this.actionLabel, this.onAction,
  });
  final String title;
  final String? subtitle;
  final String? badgeText;
  final IconData? badgeIcon;
  final IconData icon;
  final String? animationPath;
  final String? actionLabel;
  final VoidCallback? onAction;

  const CustomEmptyState.compact({
    super.key, required this.title, this.subtitle,
    this.icon = Icons.inbox_outlined,
  }) : badgeText = null, badgeIcon = null, animationPath = null,
       actionLabel = null, onAction = null;

  const CustomEmptyState.boxed({
    super.key, required this.title, this.subtitle,
    this.icon = Icons.inbox_outlined, this.actionLabel, this.onAction,
  }) : badgeText = null, badgeIcon = null, animationPath = null;

  factory CustomEmptyState.search({
    Key? key, required String query, VoidCallback? onClearSearch,
  }) => CustomEmptyState(
    key: key, title: 'لم يتم العثور على أي نتائج',
    subtitle: query.isEmpty ? 'جرّب تغيير معايير البحث.' : 'لا توجد نتائج تطابق «$query».',
    badgeText: 'نتائج البحث', icon: Icons.search_off_rounded,
    actionLabel: 'مسح البحث', onAction: onClearSearch,
  );

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 42, color: Theme.of(context).colorScheme.onSurfaceVariant),
        if (badgeText != null) ...[
          const SizedBox(height: 8),
          if (badgeIcon != null) Icon(badgeIcon, size: 16),
          Text(badgeText!, style: Theme.of(context).textTheme.labelSmall),
        ],
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        ],
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ]),
    ),
  );
}
