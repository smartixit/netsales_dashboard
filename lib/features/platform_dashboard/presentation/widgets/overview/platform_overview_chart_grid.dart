import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/widgets/charts/charting.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';

class PlatformOverviewChartGrid extends StatelessWidget {
  const PlatformOverviewChartGrid({super.key,required this.overview});
  final PlatformDashboardOverviewEntity overview;
  @override
  Widget build(BuildContext context){
    final l=AppLocalizations.of(context);
    final p=PermissionService.to;
    final charts=overview.charts;
    final definitions=<Widget>[
      if(p.can('subscriptions.view')) _chart(context,l.text('subscription_trend'),ChartFamily.cartesian,ChartType.line,charts.subscriptionTrend.map((point)=>ChartDataPoint(x:point.period,y:point.value)).toList(growable:false),l.text('subscriptions')),
      if(p.can('networks.view')||p.can('pos.view')) _chart(context,l.text('provider_distribution'),ChartFamily.circular,ChartType.doughnut,charts.providerDistribution.where((point)=>point.value>0).map((point)=>ChartDataPoint(x:point.statusLabel,y:point.value)).toList(growable:false),l.text('providers')),
      if(p.can('support.view')||p.can('system_logs.view')) _chart(context,l.text('operational_activity'),ChartFamily.comparison,ChartType.column,charts.operationalActivity.map((point)=>ChartDataPoint(x:point.date,y:point.value)).toList(growable:false),l.text('activity')),
    ];
    if(definitions.isEmpty)return CustomStatusBanner(title:l.text('module_not_authorized'),tone:CustomStatusBannerTone.info,compact:true);
    return LayoutBuilder(builder:(context,c){
      final columns=c.maxWidth>=1200?3:c.maxWidth>=900?2:1;
      final width=(c.maxWidth-AppSpacing.md*(columns-1))/columns;
      return Wrap(spacing:AppSpacing.md,runSpacing:AppSpacing.md,children:[for(final item in definitions)SizedBox(width:width,child:item)]);
    });
  }
  Widget _chart(BuildContext context,String title,ChartFamily family,ChartType type,List<ChartDataPoint> points,String seriesName){
    final series=ChartSeries(id:title,name:seriesName,data:points);
    final state=points.isEmpty?ChartState.empty:ChartState.data;
    return ChartCard(title:title,description:AppLocalizations.of(context).text('server_aggregated_data'),height:230,state:state,chart:ChartRenderer(definition:ChartDefinition(family:family,type:type,series:[series],state:state)),series:[series]);
  }
}
