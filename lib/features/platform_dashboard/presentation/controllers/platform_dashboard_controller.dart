import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/services/locale_service.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';
import 'package:netsales_dashboard/features/auth/domain/usecases/logout_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_platform_dashboard_overview_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_notification_count_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/get_platform_notifications_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/usecases/mark_notification_read_use_case.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_activity_timeline.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_notification_center.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';
class PlatformDashboardController extends GetxController {
  PlatformDashboardController({required this.logoutUseCase,required this.getOverview,required this.getNotifications,required this.getNotificationCount,required this.markNotificationRead,required this.markAllNotificationsRead});
  final LogoutUseCase logoutUseCase;
  final GetPlatformDashboardOverviewUseCase getOverview;
  final GetPlatformNotificationsUseCase getNotifications;
  final GetNotificationCountUseCase getNotificationCount;
  final MarkNotificationReadUseCase markNotificationRead;
  final MarkAllNotificationsReadUseCase markAllNotificationsRead;
  final Rxn<PlatformDashboardOverviewEntity> overview=Rxn();
  final RxBool isLoadingOverview=false.obs,hasOverviewError=false.obs,isRefreshingOverview=false.obs;
  final RxString selectedPeriod='30d'.obs;
  final RxList<PlatformNotificationEntity> notifications=<PlatformNotificationEntity>[].obs;
  final RxList<CustomNotificationItem> notificationItems=<CustomNotificationItem>[].obs;
  final RxInt unreadCount=0.obs;
  final RxBool isLoadingNotifications=false.obs,hasNotificationError=false.obs;
  final RxString commandQuery=''.obs,activeRoute=AppRoutes.overview.obs;
  final TextEditingController commandController=TextEditingController();
  final RxnBool sidebarCollapsed=RxnBool();
  final RxSet<String> expandedGroups=<String>{'platform','subscriptions','finance','support','system'}.obs;
  bool get canViewAudit=>PermissionService.to.can('system_logs.view');
  bool get canViewNotifications=>PermissionService.to.can('notifications.view');
  bool get isOverviewStale=>overview.value?.generatedAt!=null&&DateTime.now().difference(overview.value!.generatedAt!).inMinutes>=5;
  @override
  void onInit(){super.onInit();final current=Get.currentRoute;if(current.startsWith(AppRoutes.dashboard))activeRoute.value=current;unawaited(refreshHeaderData());}
  void setActiveRoute(String route){activeRoute.value=route;for(final destination in PlatformNavigationRegistry.destinations){if(destination.route==route&&destination.groupKey!=null){expandedGroups.add(destination.groupKey!);break;}}}
  void _syncNotificationItems(){notificationItems.assignAll(notifications.map((item)=>CustomNotificationItem(id:item.id,title:item.title,message:item.message,createdAt:item.createdAt,typeLabel:item.typeLabel,isRead:item.isRead)));}
  Future<void> refreshHeaderData()async{await Future.wait([loadOverview(),if(canViewNotifications)loadNotifications()]);}
  Future<void> loadOverview({String? period})async{
    final requested=period??selectedPeriod.value;final existing=overview.value!=null;
    if(!existing)isLoadingOverview.value=true;isRefreshingOverview.value=existing;hasOverviewError.value=false;
    try{overview.value=await getOverview(period:requested);selectedPeriod.value=requested;}
    catch(error){hasOverviewError.value=true;if(!existing){CustomSnackbar.show(title:LocaleService.to.isArabic?'تعذر تحميل الملخص':'Overview unavailable',message:error.toString(),type:SnackType.error);}}
    finally{isLoadingOverview.value=false;isRefreshingOverview.value=false;}
  }
  Future<void> changePeriod(String period)async{if(period!=selectedPeriod.value&&!isRefreshingOverview.value)await loadOverview(period:period);}
  Future<void> loadNotifications()async{
    if(!canViewNotifications){notifications.clear();notificationItems.clear();unreadCount.value=0;return;}
    isLoadingNotifications.value=true;hasNotificationError.value=false;
    try{notifications.assignAll(await getNotifications(limit:6));unreadCount.value=await getNotificationCount();_syncNotificationItems();}
    catch(_){hasNotificationError.value=true;}finally{isLoadingNotifications.value=false;}
  }
  Future<void> markRead(int id)async{
    final ar=LocaleService.to.isArabic;
    try{await CustomAnimationOverlay.showLoading(message:ar?'جارٍ تحديث الإشعار...':'Updating notification...');await markNotificationRead(id);notifications.removeWhere((item)=>item.id==id);unreadCount.value=unreadCount.value>0?unreadCount.value-1:0;_syncNotificationItems();await CustomAnimationOverlay.showSuccess(message:ar?'تم تحديد الإشعار كمقروء':'Notification marked as read');}
    catch(error){await loadNotifications();CustomSnackbar.show(title:ar?'تعذر تحديث الإشعار':'Unable to update notification',message:error.toString(),type:SnackType.error);}
    finally{if(CustomAnimationOverlay.isShowing)await CustomAnimationOverlay.hide();}
  }
  Future<void> markAllRead()async{
    final ar=LocaleService.to.isArabic;
    try{await CustomAnimationOverlay.showLoading(message:ar?'جارٍ تحديث الإشعارات...':'Updating notifications...');await markAllNotificationsRead();notifications.clear();notificationItems.clear();unreadCount.value=0;await CustomAnimationOverlay.showSuccess(message:ar?'تم تحديد جميع الإشعارات كمقروءة':'All notifications marked as read');}
    catch(error){await loadNotifications();CustomSnackbar.show(title:ar?'تعذر تحديث الإشعارات':'Unable to update notifications',message:error.toString(),type:SnackType.error);}
    finally{if(CustomAnimationOverlay.isShowing)await CustomAnimationOverlay.hide();}
  }
  Future<void> logout()async{
    final ar=LocaleService.to.isArabic;final confirmed=await CustomDialog.showConfirmation(title:ar?'تسجيل الخروج':'Sign out',message:ar?'هل أنت متأكد من رغبتك في إنهاء الجلسة الحالية؟':'Are you sure you want to end this session?',confirmLabel:ar?'تسجيل الخروج':'Sign out',cancelLabel:ar?'إلغاء':'Cancel');
    if(confirmed!=true)return;
    try{await CustomAnimationOverlay.showLoading(message:ar?'جارٍ إنهاء الجلسة...':'Ending session...');await logoutUseCase.execute();await CustomAnimationOverlay.showSuccess(message:ar?'تم تسجيل الخروج بنجاح':'You have signed out successfully');await Get.offAllNamed<void>(AppRoutes.login);}
    catch(error){CustomSnackbar.show(title:ar?'تعذر تسجيل الخروج':'Unable to sign out',message:error.toString(),type:SnackType.error);}
    finally{if(CustomAnimationOverlay.isShowing)await CustomAnimationOverlay.hide();}
  }
  void setSidebarCollapsed(bool collapsed)=>sidebarCollapsed.value=collapsed;
  void toggleGroup(String id){if(expandedGroups.contains(id)){expandedGroups.remove(id);}else{expandedGroups.add(id);}}
  List<ActivityTimelineItem> get activityItems=>(overview.value?.recentActivity??const <PlatformActivityEntity>[]).map((item)=>ActivityTimelineItem(id:item.id.toString(),title:item.action,description:item.contextLabel??('${item.module} • ${item.entityType}${item.entityId==null?'':' #${item.entityId}'}'),timestamp:item.timestamp?.toLocal().toString().substring(0,16)??'—',actor:item.actorName,icon:Icons.history_rounded)).toList(growable:false);
  @override
  void onClose(){commandController.dispose();super.onClose();}
}