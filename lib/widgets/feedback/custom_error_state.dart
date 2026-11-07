import 'package:flutter/material.dart';

class CustomErrorState extends StatelessWidget {
  const CustomErrorState({
    super.key, required this.title, required this.subtitle,
    this.retryLabel = 'إعادة المحاولة', this.onRetry,
    this.icon = Icons.error_outline_rounded, this.animationPath,
    this.errorCode, this.technicalDetails,
  });
  final String title;
  final String subtitle;
  final String retryLabel;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? animationPath;
  final String? errorCode;
  final String? technicalDetails;

  const CustomErrorState.boxed({
    super.key, required this.title, required this.subtitle,
    this.icon = Icons.error_outline_rounded, this.onRetry,
  }) : retryLabel = 'إعادة المحاولة', animationPath = null,
       errorCode = null, technicalDetails = null;

  factory CustomErrorState.connection({Key? key, VoidCallback? onRetry}) =>
    CustomErrorState(
      key: key, title: 'تعذر الاتصال بالشبكة',
      subtitle: 'تحقق من اتصال الإنترنت ثم أعد المحاولة.',
      retryLabel: 'إعادة فحص الاتصال', onRetry: onRetry,
      icon: Icons.cloud_off_rounded, errorCode: 'OFFLINE',
    );

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 44, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(subtitle, textAlign: TextAlign.center),
        if (errorCode != null) ...[
          const SizedBox(height: 8), Text(errorCode!, style: Theme.of(context).textTheme.labelSmall),
        ],
        if (technicalDetails != null) ...[
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text('التفاصيل الفنية والدعم التقني'),
            children: [
              SelectableText(technicalDetails!),
              TextButton.icon(
                onPressed: () {}, icon: const Icon(Icons.copy_rounded),
                label: const Text('نسخ تفاصيل الخطأ'),
              ),
            ],
          ),
        ],
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: Text(retryLabel)),
        ],
      ]),
    ),
  );
}
