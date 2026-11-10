import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/features/platform_billing/domain/entities/platform_billing_entities.dart';
import 'package:netsales_dashboard/features/platform_billing/presentation/controllers/platform_billing_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/core/presentation/enums/semantic_tone.dart';

enum _BillingSection { overview, plans, subscriptions, invoices, payments, treasury }

class PlatformBillingScreen extends GetView<PlatformBillingController> {
  const PlatformBillingScreen({super.key});

  @override
  Widget build(BuildContext context) => Obx(() {
    final selected = _BillingSection.values.firstWhere(
      (item) => item.name == (Get.parameters['section'] ?? 'overview'),
      orElse: () => _BillingSection.overview,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BillingHeader(onRefresh: controller.refresh),
          AppSpacing.vLg,
          _BillingNavigation(selected: selected),
          AppSpacing.vLg,
          _CurrencyFilter(controller: controller),
          AppSpacing.vLg,
          switch (selected) {
            _BillingSection.overview => _OverviewContent(controller: controller),
            _BillingSection.plans => _PlansContent(controller: controller),
            _BillingSection.subscriptions => _SubscriptionsContent(controller: controller),
            _BillingSection.invoices => _InvoicesContent(controller: controller),
            _BillingSection.payments => _PaymentsContent(controller: controller),
            _BillingSection.treasury => _TreasuryContent(controller: controller),
          },
        ],
      ),
    );
  });
}

class _BillingHeader extends StatelessWidget {
  const _BillingHeader({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('مركز الفوترة والاشتراكات', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('إدارة الخطط والعقود والتحصيلات والسجلات المالية متعددة العملات', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
        ]),
      ),
      CustomButton.outline(
        text: 'تحديث البيانات',
        prefix: const Icon(Icons.refresh_rounded, size: 18),
        size: AppButtonSize.small,
        onPressed: onRefresh,
      ),
    ],
  );
}

class _BillingNavigation extends StatelessWidget {
  const _BillingNavigation({required this.selected});
  final _BillingSection selected;

  @override
  Widget build(BuildContext context) {
    const labels = {
      _BillingSection.overview: 'نظرة عامة',
      _BillingSection.plans: 'الخطط والأسعار',
      _BillingSection.subscriptions: 'الاشتراكات',
      _BillingSection.invoices: 'الفواتير',
      _BillingSection.payments: 'المدفوعات',
      _BillingSection.treasury: 'الخزينة',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in _BillingSection.values)
          CustomButton(
            text: labels[item],
            size: AppButtonSize.small,
            variant: item == selected ? AppButtonVariant.primary : AppButtonVariant.outline,
            onPressed: () => Get.offNamed<void>('/dashboard/billing?section=${item.name}'),
          ),
      ],
    );
  }
}

class _CurrencyFilter extends StatelessWidget {
  const _CurrencyFilter({required this.controller});
  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Obx(() => Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('عرض العملة:', style: Theme.of(context).textTheme.labelLarge),
        CustomButton(
          text: 'كل العملات',
          size: AppButtonSize.small,
          variant: controller.selectedCurrencyId.value == null ? AppButtonVariant.secondary : AppButtonVariant.outline,
          onPressed: () => controller.applyCurrencyFilter(null),
        ),
        for (final currency in controller.currencies)
          CustomButton(
            text: currency.code,
            size: AppButtonSize.small,
            variant: controller.selectedCurrencyId.value == currency.id ? AppButtonVariant.secondary : AppButtonVariant.outline,
            onPressed: () => controller.applyCurrencyFilter(currency.id),
          ),
      ],
    )),
  );
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.controller});
  final PlatformBillingController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
    final data = controller.overview.value;
    if (controller.isOverviewLoading.value && data == null) {
      return const CustomSkeletonGrid(count: 6, crossAxisCount: 3, itemHeight: 124);
    }
    if (data == null) {
      return CustomErrorState.boxed(
        title: 'تعذر تحميل مؤشرات الفوترة',
        subtitle: 'تحقق من صلاحيتك واتصال API ثم أعد المحاولة.',
        retryLabel: 'إعادة المحاولة',
        onRetry: controller.loadOverview,
        type: ErrorStateType.server,
      );
    }
    final active = data.subscriptions.countFor('ACTIVE') + data.subscriptions.countFor('TRIALING');
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 12, runSpacing: 12, children: [
        _MetricCard(title: 'حسابات الفوترة', value: data.billingAccountsCount.toString(), icon: Icons.account_balance_outlined),
        _MetricCard(title: 'إجمالي الاشتراكات', value: data.subscriptions.total.toString(), icon: Icons.subscriptions_outlined),
        _MetricCard(title: 'النشطة والتجريبية', value: active.toString(), icon: Icons.verified_outlined),
        _MetricCard(title: 'الفواتير', value: data.invoices.total.toString(), icon: Icons.receipt_long_outlined),
      ]),
      AppSpacing.vXl,
      Text('المؤشرات المالية حسب العملة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      AppSpacing.vMd,
      if (data.financialsByCurrency.isEmpty)
        const _EmptyPanel(message: 'لا توجد حركة مالية مسجلة للفترة الحالية.')
      else
        for (final item in data.financialsByCurrency) ...[
          _CurrencyFinancialCard(item: item),
          AppSpacing.vSm,
        ],
      AppSpacing.vXl,
      Text('قائمة مراجعة المدفوعات', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      AppSpacing.vMd,
      if (data.paymentReviewQueue.isEmpty)
        const _EmptyPanel(message: 'لا توجد مدفوعات بانتظار المراجعة.')
      else
        for (final payment in data.paymentReviewQueue) _PaymentRow(payment: payment),
    ]);
  });
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 220,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: context.colors.outlineVariant.withValues(alpha: .45)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: context.colors.primary),
      const SizedBox(height: 14),
      Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
    ]),
  );
}

class _CurrencyFinancialCard extends StatelessWidget {
  const _CurrencyFinancialCard({required this.item});
  final BillingCurrencyFinancialSummaryEntity item;

  @override
  Widget build(BuildContext context) {
    final currency = item.currency;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.outlineVariant.withValues(alpha: .55)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${currency.name} (${currency.code})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        Wrap(spacing: 28, runSpacing: 16, children: [
          _FinancialValue(label: 'تحصيلات الشهر', value: '${currency.code} · ${item.verifiedCollections ?? '—'}', count: item.verifiedCollectionCount),
          _FinancialValue(label: 'ذمم الفواتير المفتوحة', value: '${currency.code} · ${item.openInvoiceOutstanding ?? '—'}', count: item.openInvoiceCount),
          _FinancialValue(label: 'المتأخرات', value: '${currency.code} · ${item.overdueInvoiceOutstanding ?? '—'}', count: item.overdueInvoiceCount),
          _FinancialValue(label: 'مدفوعات قيد المراجعة', value: '${currency.code} · ${item.pendingPaymentAmount ?? '—'}', count: item.pendingPaymentCount),
        ]),
      ]),
    );
  }

}

class _FinancialValue extends StatelessWidget {
  const _FinancialValue({required this.label, required this.value, required this.count});
  final String label;
  final String value;
  final int count;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 210,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
      const SizedBox(height: 5),
      Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
      Text('$count عملية', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.colors.onSurfaceVariant)),
    ]),
  );
}

class _PlansContent extends StatelessWidget {
  const _PlansContent({required this.controller});
  final PlatformBillingController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isPlansLoading.value && controller.plans.isEmpty) return const CustomSkeletonGrid(count: 4, crossAxisCount: 2, itemHeight: 150);
    if (controller.plans.isEmpty) return const _EmptyPanel(message: 'لا توجد خطط منشورة أو معرفة حتى الآن.');
    return Wrap(spacing: 12, runSpacing: 12, children: [
      for (final plan in controller.plans)
        Container(
          width: 320,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: context.colors.surfaceContainerLow, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.colors.outlineVariant.withValues(alpha: .5))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(plan.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(plan.key, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.colors.onSurfaceVariant)),
            const SizedBox(height: 12),
            CustomStatusBadge(label: plan.isActive ? 'نشطة' : 'متوقفة', tone: plan.isActive ? SemanticTone.success : SemanticTone.neutral),
            const SizedBox(height: 12),
            if (plan.currentVersion != null) ...[
              Text('الإصدار ${plan.currentVersion!.versionNumber} · ${plan.currentVersion!.statusLabel ?? plan.currentVersion!.status}'),
              const SizedBox(height: 8),
              for (final price in plan.currentVersion!.prices)
                Text('${price.currency?.code ?? ''} · ${price.unitAmountMinor} وحدة صغرى / ${price.billingInterval}'),
              if (plan.currentVersion!.trialPolicy case final trial?)
                Text(trial.isEnabled ? 'تجربة: ${trial.durationValue} ${trial.durationUnit}' : 'التجربة غير مفعلة'),
            ] else const Text('لا يوجد إصدار حالي'),
          ]),
        ),
    ]);
  });
}

class _SubscriptionsContent extends StatelessWidget {
  const _SubscriptionsContent({required this.controller});
  final PlatformBillingController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isSubscriptionsLoading.value && controller.subscriptions.isEmpty) return const CustomSkeletonGrid(count: 5, crossAxisCount: 2, itemHeight: 120);
    if (controller.subscriptionsError.value != null && controller.subscriptions.isEmpty) return CustomErrorState.boxed(title: 'تعذر تحميل الاشتراكات', subtitle: controller.subscriptionsError.value!, retryLabel: 'إعادة المحاولة', onRetry: () => controller.loadSubscriptions(reset: true), type: ErrorStateType.server);
    if (controller.subscriptions.isEmpty) return const _EmptyPanel(message: 'لا توجد اشتراكات تطابق المرشحات الحالية.');
    return Column(children: [
      for (final item in controller.subscriptions) _SubscriptionRow(subscription: item),
      if (controller.canLoadMoreSubscriptions) Align(alignment: AlignmentDirectional.centerEnd, child: CustomButton.outline(text: 'تحميل المزيد', size: AppButtonSize.small, loading: controller.isSubscriptionsLoadingMore.value, onPressed: () => controller.loadSubscriptions())),
    ]);
  });
}

class _InvoicesContent extends StatelessWidget {
  const _InvoicesContent({required this.controller});
  final PlatformBillingController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isInvoicesLoading.value && controller.invoices.isEmpty) return const CustomSkeletonGrid(count: 5, crossAxisCount: 2, itemHeight: 110);
    if (controller.invoicesError.value != null && controller.invoices.isEmpty) return CustomErrorState.boxed(title: 'تعذر تحميل الفواتير', subtitle: controller.invoicesError.value!, retryLabel: 'إعادة المحاولة', onRetry: () => controller.loadInvoices(reset: true), type: ErrorStateType.server);
    if (controller.invoices.isEmpty) return const _EmptyPanel(message: 'لا توجد فواتير.');
    return Column(children: [
      for (final invoice in controller.invoices) _InvoiceRow(invoice: invoice),
      if (controller.canLoadMoreInvoices) Align(alignment: AlignmentDirectional.centerEnd, child: CustomButton.outline(text: 'تحميل المزيد', size: AppButtonSize.small, loading: controller.isInvoicesLoadingMore.value, onPressed: () => controller.loadInvoices())),
    ]);
  });
}

class _PaymentsContent extends StatelessWidget {
  const _PaymentsContent({required this.controller});
  final PlatformBillingController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isPaymentsLoading.value && controller.payments.isEmpty) return const CustomSkeletonGrid(count: 5, crossAxisCount: 2, itemHeight: 110);
    if (controller.paymentsError.value != null && controller.payments.isEmpty) return CustomErrorState.boxed(title: 'تعذر تحميل المدفوعات', subtitle: controller.paymentsError.value!, retryLabel: 'إعادة المحاولة', onRetry: () => controller.loadPayments(reset: true), type: ErrorStateType.server);
    if (controller.payments.isEmpty) return const _EmptyPanel(message: 'لا توجد مدفوعات.');
    return Column(children: [
      for (final payment in controller.payments) _PaymentRow(payment: payment),
      if (controller.canLoadMorePayments) Align(alignment: AlignmentDirectional.centerEnd, child: CustomButton.outline(text: 'تحميل المزيد', size: AppButtonSize.small, loading: controller.isPaymentsLoadingMore.value, onPressed: () => controller.loadPayments())),
    ]);
  });
}

class _TreasuryContent extends StatelessWidget {
  const _TreasuryContent({required this.controller});
  final PlatformBillingController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isTreasuryLoading.value && controller.treasuryAccounts.isEmpty) return const CustomSkeletonGrid(count: 4, crossAxisCount: 2, itemHeight: 110);
    if (controller.treasuryAccounts.isEmpty) return const _EmptyPanel(message: 'لا توجد حسابات خزينة.');
    return Wrap(spacing: 12, runSpacing: 12, children: [
      for (final account in controller.treasuryAccounts)
        Container(width: 300, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: context.colors.surfaceContainerLow, borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(account.name, style: Theme.of(context).textTheme.titleMedium),
          Text(account.accountCode),
          Text('${account.currency?.code ?? ''} · ${account.accountType}'),
          CustomStatusBadge(label: account.status, tone: account.status == 'ACTIVE' ? SemanticTone.success : SemanticTone.neutral),
        ])),
    ]);
  });
}

class _SubscriptionRow extends StatelessWidget {
  const _SubscriptionRow({required this.subscription});
  final BillingSubscriptionEntity subscription;
  @override
  Widget build(BuildContext context) => _RowCard(
    title: subscription.planName ?? 'اشتراك #${subscription.id}',
    subtitle: '${subscription.networkName ?? 'شبكة غير محددة'} · ${subscription.currency?.code ?? ''}',
    status: subscription.statusLabel ?? subscription.status,
    statusTone: switch (subscription.typedStatus) {
      BillingSubscriptionStatus.active || BillingSubscriptionStatus.trialing => SemanticTone.success,
      BillingSubscriptionStatus.pastDue || BillingSubscriptionStatus.suspended => SemanticTone.warning,
      BillingSubscriptionStatus.canceled || BillingSubscriptionStatus.expired => SemanticTone.neutral,
      _ => SemanticTone.info,
    },
    trailing: subscription.currentPeriodEnd == null ? '—' : 'حتى ${subscription.currentPeriodEnd!.toLocal().toString().split(' ').first}',
  );
}

class _InvoiceRow extends StatelessWidget {
  const _InvoiceRow({required this.invoice});
  final BillingInvoiceEntity invoice;
  @override
  Widget build(BuildContext context) => _RowCard(
    title: invoice.number,
    subtitle: '${invoice.currency?.code ?? ''} · ${invoice.total ?? invoice.totalMinor.toString()}',
    status: invoice.statusLabel ?? invoice.status,
    statusTone: invoice.typedStatus == BillingInvoiceStatus.paid ? SemanticTone.success : invoice.typedStatus == BillingInvoiceStatus.voided ? SemanticTone.neutral : SemanticTone.warning,
    trailing: 'المتبقي: ${invoice.remaining ?? invoice.remainingMinor.toString()}',
  );
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment});
  final BillingPaymentEntity payment;
  @override
  Widget build(BuildContext context) => _RowCard(
    title: payment.reference,
    subtitle: '${payment.currency?.code ?? ''} · ${payment.amount ?? payment.amountMinor.toString()}',
    status: payment.statusLabel ?? payment.status,
    statusTone: payment.typedStatus == BillingPaymentStatus.verified ? SemanticTone.success : payment.typedStatus == BillingPaymentStatus.rejected ? SemanticTone.danger : SemanticTone.warning,
    trailing: payment.invoiceNumber ?? 'فاتورة #${payment.invoiceId}',
  );
}

class _RowCard extends StatelessWidget {
  const _RowCard({required this.title, required this.subtitle, required this.status, required this.statusTone, required this.trailing});
  final String title;
  final String subtitle;
  final String status;
  final SemanticTone statusTone;
  final String trailing;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.colors.outlineVariant.withValues(alpha: .5))),
    child: Wrap(spacing: 14, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
      SizedBox(width: 210, child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
      SizedBox(width: 230, child: Text(subtitle, style: Theme.of(context).textTheme.bodySmall)),
      CustomStatusBadge(label: status, tone: statusTone, isCompact: true),
      Text(trailing, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
    ]),
  );
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    alignment: Alignment.center,
    decoration: BoxDecoration(color: context.colors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
    child: Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
  );
}
