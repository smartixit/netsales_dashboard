import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_activity_timeline.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_card.dart';

class PlatformRecentActivitySection extends GetView<PlatformDashboardController>{
 const PlatformRecentActivitySection({super.key});
 @override
 Widget build(BuildContext context){
  final l=AppLocalizations.of(context);
  return Obx((){
   final items=controller.activityItems;
   return Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    CustomSectionHeader(title:l.text('recent_activity'),description:l.text('recent_activity')),
    AppSpacing.vMd,
    if(controller.isLoadingOverview.value&&controller.overview.value==null)
     const CustomSkeletonCard(height:220)
    else if(controller.hasOverviewError.value&&controller.overview.value==null)
     CustomEmptyState.compact(title:l.text('overview_load_failed'),subtitle:l.text('overview_api_unavailable'),icon:Icons.cloud_off_outlined)
    else if(items.isEmpty)
     CustomEmptyState.compact(title:l.text('no_activity'),subtitle:l.text('no_activity'),icon:Icons.history_toggle_off_rounded)
    else CustomActivityTimeline(items:items,emptyTitle:l.text('no_activity'),emptyMessage:l.text('no_activity')),
   ]);
  });
 }
}
