import 'package:get/get.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/datasources/platform_subscriptions_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/datasources/platform_subscriptions_remote_data_source_impl.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/data/repositories/platform_subscriptions_repository_impl.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/repositories/platform_subscriptions_repository.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/approve_subscription_request_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/delete_subscription_plan_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/extend_provider_subscription_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_provider_subscriptions_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_plans_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_features_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_requests_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/get_subscription_request_receipt_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/reject_subscription_request_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/save_subscription_plan_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/domain/usecases/toggle_subscription_plan_status_use_case.dart';
import 'package:netsales_dashboard/features/platform_subscriptions/presentation/controllers/platform_subscriptions_controller.dart';

class PlatformSubscriptionsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlatformSubscriptionsRemoteDataSource>()) {
      Get.lazyPut<PlatformSubscriptionsRemoteDataSource>(PlatformSubscriptionsRemoteDataSourceImpl.new, fenix: true);
    }
    if (!Get.isRegistered<PlatformSubscriptionsRepository>()) {
      Get.lazyPut<PlatformSubscriptionsRepository>(() => PlatformSubscriptionsRepositoryImpl(Get.find<PlatformSubscriptionsRemoteDataSource>()), fenix: true);
    }
    if (!Get.isRegistered<GetSubscriptionPlansUseCase>()) {
      Get.lazyPut<GetSubscriptionPlansUseCase>(() => GetSubscriptionPlansUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<GetSubscriptionFeaturesUseCase>()) {
      Get.lazyPut<GetSubscriptionFeaturesUseCase>(() => GetSubscriptionFeaturesUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<GetProviderSubscriptionsUseCase>()) {
      Get.lazyPut<GetProviderSubscriptionsUseCase>(() => GetProviderSubscriptionsUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<GetSubscriptionRequestsUseCase>()) {
      Get.lazyPut<GetSubscriptionRequestsUseCase>(() => GetSubscriptionRequestsUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<GetSubscriptionRequestReceiptUseCase>()) {
      Get.lazyPut<GetSubscriptionRequestReceiptUseCase>(() => GetSubscriptionRequestReceiptUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<SaveSubscriptionPlanUseCase>()) {
      Get.lazyPut<SaveSubscriptionPlanUseCase>(() => SaveSubscriptionPlanUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<ToggleSubscriptionPlanStatusUseCase>()) {
      Get.lazyPut<ToggleSubscriptionPlanStatusUseCase>(() => ToggleSubscriptionPlanStatusUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<DeleteSubscriptionPlanUseCase>()) {
      Get.lazyPut<DeleteSubscriptionPlanUseCase>(() => DeleteSubscriptionPlanUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<ApproveSubscriptionRequestUseCase>()) {
      Get.lazyPut<ApproveSubscriptionRequestUseCase>(() => ApproveSubscriptionRequestUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<RejectSubscriptionRequestUseCase>()) {
      Get.lazyPut<RejectSubscriptionRequestUseCase>(() => RejectSubscriptionRequestUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<ExtendProviderSubscriptionUseCase>()) {
      Get.lazyPut<ExtendProviderSubscriptionUseCase>(() => ExtendProviderSubscriptionUseCase(Get.find<PlatformSubscriptionsRepository>()), fenix: true);
    }
    if (!Get.isRegistered<PlatformSubscriptionsController>()) {
      Get.lazyPut<PlatformSubscriptionsController>(() => PlatformSubscriptionsController(
        getPlans: Get.find<GetSubscriptionPlansUseCase>(),
        getFeatures: Get.find<GetSubscriptionFeaturesUseCase>(),
        getSubscriptions: Get.find<GetProviderSubscriptionsUseCase>(),
        getRequests: Get.find<GetSubscriptionRequestsUseCase>(),
        getRequestReceipt: Get.find<GetSubscriptionRequestReceiptUseCase>(),
        savePlan: Get.find<SaveSubscriptionPlanUseCase>(),
        togglePlan: Get.find<ToggleSubscriptionPlanStatusUseCase>(),
        deletePlan: Get.find<DeleteSubscriptionPlanUseCase>(),
        approveRequest: Get.find<ApproveSubscriptionRequestUseCase>(),
        rejectRequest: Get.find<RejectSubscriptionRequestUseCase>(),
        extendSubscription: Get.find<ExtendProviderSubscriptionUseCase>(),
      ), fenix: true);
    }
  }
}
