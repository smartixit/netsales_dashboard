import 'package:flutter/widgets.dart';
class AppLocalizations {
  const AppLocalizations(this.locale);
  final Locale locale;
  bool get isArabic => locale.languageCode == 'ar';
  static AppLocalizations of(BuildContext context) => AppLocalizations(Localizations.localeOf(context));
  String text(String key) {
    final language = isArabic ? _arabic : _english;
    return language[key] ?? _english[key] ?? key;
  }
  static const Map<String, String> _arabic = {
    'overview':'نظرة عامة','platform_management':'إدارة المنصة','users':'المستخدمون','roles':'الأدوار والصلاحيات','networks':'مزودو الشبكات','pos':'نقاط البيع','geography':'المحافظات والمديريات',
    'subscriptions':'الاشتراكات والتراخيص','subscription_plans':'خطط الاشتراك','provider_subscriptions':'اشتراكات المزودين','subscription_requests':'طلبات الاشتراك والترقية',
    'finance':'المالية والتقارير','sales':'تقارير المبيعات','network_wallets':'محافظ الشبكات','pos_wallets':'محافظ نقاط البيع','expenses':'المصروفات','bank_accounts':'الحسابات البنكية والتسويات','reports':'التقارير المالية',
    'support':'الدعم والتواصل','support_tickets':'تذاكر الدعم الفني','notifications':'الإشعارات والتنبيهات','send_notifications':'إدارة الإشعارات',
    'system':'النظام والأمان','audit_logs':'سجلات التدقيق','settings':'إعدادات النظام','sessions':'الجلسات والأجهزة','backups':'النسخ الاحتياطي','scheduled_tasks':'المهام المجدولة',
    'welcome_back':'مرحباً بعودتك','platform_summary':'إليك ملخص حالة المنصة وأبرز المستجدات.','today':'اليوم','refresh':'تحديث','quick_actions':'إجراءات سريعة',
    'platform_activity':'نشاط المنصة','needs_attention':'يحتاج إلى متابعة','recent_activity':'أحدث النشاطات','performance_overview':'مؤشرات الأداء','subscription_trend':'اتجاه الاشتراكات','provider_distribution':'توزيع المزودين','operational_activity':'النشاط التشغيلي',
    'active_network_providers':'مزودو الشبكات النشطون','active_pos':'نقاط البيع النشطة','active_subscriptions':'الاشتراكات النشطة','expiring_subscriptions':'اشتراكات قريبة من الانتهاء','open_support_tickets':'تذاكر الدعم المفتوحة',
    'search':'بحث','search_hint':'ابحث في الصفحات والإجراءات...','notifications_empty':'لا توجد إشعارات غير مقروءة.','mark_all_read':'تحديد الكل كمقروء','view_all':'عرض كل الإشعارات','mark_read':'تحديد كمقروء',
    'profile':'الملف الشخصي','account':'الحساب','security':'الأمان','security_settings':'إعدادات الأمان','devices':'الأجهزة والجلسات','logout':'تسجيل الخروج','language':'اللغة','light_mode':'الوضع الفاتح','dark_mode':'الوضع الداكن',
    'collapse_sidebar':'طي القائمة','expand_sidebar':'توسيع القائمة','open_navigation':'فتح القائمة','application':'تطبيق NetSales','platform_edition':'إدارة المنصة','secure_administration':'إدارة آمنة للمنصة',
    'no_overview_data':'بيانات الملخص غير متاحة حالياً','overview_api_unavailable':'واجهة تجميع بيانات لوحة التحكم غير مكتملة في الخادم. لن نعرض قيماً تقديرية أو بيانات تجريبية.',
    'no_activity':'لا توجد نشاطات متاحة للعرض.','module_not_delivered':'هذه الوحدة ضمن خريطة التنقل، وسيتم تسليم شاشتها ضمن مرحلتها الوظيفية.','module_not_authorized':'لا تملك الصلاحية اللازمة لعرض هذه الوحدة.',
    'network_error':'تعذر الاتصال بالخادم. تحقق من الاتصال ثم أعد المحاولة.','no_results':'لا توجد نتائج مطابقة.','filter':'تصفية','clear_filters':'مسح الفلاتر','date_range':'الفترة الزمنية',
    'previous_7_days':'آخر 7 أيام','previous_30_days':'آخر 30 يوماً','this_month':'هذا الشهر','custom_range':'فترة مخصصة','all':'الكل','command_palette':'البحث والتنقل السريع','shortcut':'اختصار','close':'إغلاق','open':'فتح',
    'status_online':'متصل','status_offline':'غير متصل','updated_now':'تم التحديث الآن','overview_api_note':'مسار dashboard/overview مسجل في routes/api.php لكن DashboardController غير موجود في مصدر API الحالي.',
  };
  static const Map<String, String> _english = {
    'overview':'Overview','platform_management':'Platform management','users':'Users','roles':'Roles & permissions','networks':'Network providers','pos':'Points of sale','geography':'Governorates & directorates',
    'subscriptions':'Subscriptions & licensing','subscription_plans':'Subscription plans','provider_subscriptions':'Provider subscriptions','subscription_requests':'Subscription requests',
    'finance':'Finance & reports','sales':'Sales reports','network_wallets':'Network wallets','pos_wallets':'POS wallets','expenses':'Expenses','bank_accounts':'Bank accounts & settlements','reports':'Financial reports',
    'support':'Support & communications','support_tickets':'Support tickets','notifications':'Notifications','send_notifications':'Notification management',
    'system':'System & security','audit_logs':'Audit logs','settings':'System settings','sessions':'Sessions & devices','backups':'Backups','scheduled_tasks':'Scheduled tasks',
    'welcome_back':'Welcome back','platform_summary':'Here is your platform overview and the latest updates.','today':'Today','refresh':'Refresh','quick_actions':'Quick actions',
    'platform_activity':'Platform activity','needs_attention':'Needs attention','recent_activity':'Recent activity','performance_overview':'Performance overview','subscription_trend':'Subscription trend','provider_distribution':'Provider distribution','operational_activity':'Operational activity',
    'active_network_providers':'Active network providers','active_pos':'Active points of sale','active_subscriptions':'Active subscriptions','expiring_subscriptions':'Subscriptions expiring soon','open_support_tickets':'Open support tickets',
    'search':'Search','search_hint':'Search pages and actions...','notifications_empty':'You have no unread notifications.','mark_all_read':'Mark all as read','view_all':'View all notifications','mark_read':'Mark as read',
    'profile':'Profile','account':'Account','security':'Security','security_settings':'Security settings','devices':'Devices & sessions','logout':'Sign out','language':'Language','light_mode':'Light mode','dark_mode':'Dark mode',
    'collapse_sidebar':'Collapse navigation','expand_sidebar':'Expand navigation','open_navigation':'Open navigation','application':'NetSales Dashboard','platform_edition':'Platform administration','secure_administration':'Secure platform administration',
    'no_overview_data':'Overview data is not available yet','overview_api_unavailable':'The server-side dashboard aggregation contract is incomplete. No estimated or sample values are displayed.',
    'no_activity':'There is no activity to display.','module_not_delivered':'This destination is in the navigation map and will be delivered with its functional module.','module_not_authorized':'You do not have permission to view this module.',
    'network_error':'Could not reach the server. Check your connection and retry.','no_results':'No matching results.','filter':'Filter','clear_filters':'Clear filters','date_range':'Date range',
    'previous_7_days':'Last 7 days','previous_30_days':'Last 30 days','this_month':'This month','custom_range':'Custom range','all':'All','command_palette':'Quick search and navigation','shortcut':'Shortcut','close':'Close','open':'Open',
    'status_online':'Online','status_offline':'Offline','updated_now':'Updated just now','overview_api_note':'dashboard/overview is registered in routes/api.php, but DashboardController is absent from the current API source.',
  };
}
