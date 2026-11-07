import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/bindings/initial_binding.dart';
import 'package:netsales_dashboard/core/constants/app_constants.dart';
import 'package:netsales_dashboard/core/config/desktop_windowing_config.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/exceptions/app_exception.dart';
import 'package:netsales_dashboard/core/routing/app_pages.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/app_crypto_service.dart';
import 'package:netsales_dashboard/core/services/device_service.dart';
import 'package:netsales_dashboard/core/services/internet_connection_service.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/services/public_settings_service.dart';
import 'package:netsales_dashboard/core/services/push_notification_service.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/services/workspace_service.dart';
import 'package:netsales_dashboard/core/services/integration_gate_service.dart';
import 'package:netsales_dashboard/core/services/sms_retriever_service.dart';
import 'package:netsales_dashboard/core/services/storage_service.dart';
import 'package:netsales_dashboard/core/services/theme_service.dart';
import 'package:netsales_dashboard/core/themes/app_motion.dart';
import 'package:netsales_dashboard/core/utils/system_ui_style_resolver.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_themes.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_not_found.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_animation_overlay.dart';
import 'package:netsales_dashboard/widgets/interactions/custome_theme_switcher.dart';
import 'package:netsales_dashboard/widgets/toasts/custom_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // معالجة أخطاء فلاتر وتجنب انهيار التطبيق
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log(
      '❌ FlutterError: ${details.exceptionAsString()}',
      stackTrace: details.stack,
    );
  };

  // شبكة أمان عامة لكافة الاستثناءات غير الملتقطة على مستوى النظام الأساسي
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    log('❌ Uncaught Platform Error: $error', stackTrace: stack);

    // إخفاء أي مؤشر تحميل معلق
    try {
      CustomAnimationOverlay.hide();
    } catch (_) {}

    final sanitizedMessage = AppException.sanitizeMessage(error);

    // التأكد من توفر سياق الواجهة قبل محاولة إظهار سناك بار
    if (Get.context != null) {
      if (error is PermissionDeniedException) {
        CustomSnackbar.show(
          title: 'صلاحية غير متوفرة',
          message: sanitizedMessage,
          type: SnackType.warning,
        );
      } else if (error is UnauthenticatedException) {
        CustomSnackbar.show(
          title: 'تسجيل الدخول مطلوب',
          message: sanitizedMessage,
          type: SnackType.warning,
        );
      } else {
        CustomSnackbar.show(
          title: 'تنبيه',
          message: sanitizedMessage,
          type: SnackType.error,
        );
      }
    }
    return true; // تم التعامل مع الخطأ بنجاح دون انهيار التطبيق
  };

  // تخصيص شاشة الخطأ في الواجهات عند حدوث استثناء في بناء العناصر (Clean Design System)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Builder(
      builder: (context) {
        final colors = context.colors;
        return Material(
          color: colors.surface,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 56.r,
                    color: colors.warning,
                  ),
                  AppSpacing.vMd,
                  Text(
                    'حدث خطأ غير متوقع عند عرض هذه الشاشة',
                    style: AppTypography.titleMedium.copyWith(
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  };

  // 1. تهيئة التخزين الأساسي السريع (Fast Local Storage)
  await StorageService.instance.init();
  Get.put<StorageService>(StorageService.instance, permanent: true);

  // 2. تهيئة خدمات المظهر والهوية والصلاحيات الفورية
  await ThemeService.instance.init();
  Get.put<ThemeService>(ThemeService.instance, permanent: true);

  Get.put<PermissionService>(PermissionService.instance, permanent: true);
  await SessionService.instance.init();
  Get.put<SessionService>(SessionService.instance, permanent: true);
  await WorkspaceService.instance.init();
  Get.put<WorkspaceService>(WorkspaceService.instance, permanent: true);
  Get.put<IntegrationGateService>(
    IntegrationGateService.instance,
    permanent: true,
  );

  // 3. تسجيل الخدمات العامة الدائمة في حاوية GetX لضمان استقرار التبعيات
  Get.put<DeviceService>(DeviceService.instance, permanent: true);
  Get.put<AppCryptoService>(AppCryptoService.instance, permanent: true);
  Get.put<InternetConnectionService>(
    InternetConnectionService.instance,
    permanent: true,
  );
  Get.put<PushNotificationService>(
    PushNotificationService.instance,
    permanent: true,
  );
  Get.put<PublicSettingsService>(
    PublicSettingsService.instance,
    permanent: true,
  );

  // 4. تهيئة استرجاع بصمة التطبيق لنظام أندرويد في الخلفية دون تعطيل
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    unawaited(SmsRetrieverService.instance.initSignature());
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  // Edge-to-Edge (Android 15+ standard) — Guaranteed modern system bars
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Configure the desktop window before the first visible Flutter frame.
  final windowing = DesktopWindowingController(config: desktopWindowingConfig);
  try {
    await windowing.initialize();
  } catch (error, stackTrace) {
    log('Desktop window initialization failed: $error', stackTrace: stackTrace);
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(windowing.show());
  });

  // 5. إطلاق الواجهة الرئيسية فوراً (Instant Native Splash Dismissal & Fast First Frame)
  // ملاحظة: الخدمات الثقيلة (Firebase/FCM, Libsodium, DeviceInfo, Ping) تُهيأ
  // بالتوازي وبشكل غير حاجب داخل SplashController أثناء دوران شاشة الإقلاع الأنيقة.
  runApp(MyApp(windowing: windowing));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.windowing});

  final DesktopWindowingController windowing;

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.to;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Obx(() {
          return GetMaterialApp(
            title: AppConstants.appNameEn,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: themeService.themeMode,
            initialBinding: InitialBinding(),
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            routingCallback: (routing) {
              if (routing != null) {
                unawaited(windowing.applyRoute(routing.current));
              }
            },
            unknownRoute: GetPage(
              name: AppRoutes.notFound,
              page: () => const CustomNotFound(),
            ),
            defaultTransition: Transition.fadeIn,
            transitionDuration: AppMotion.page,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            textDirection: TextDirection.rtl,
            builder: (ctx, appChild) {
              final mediaQuery = MediaQuery.of(ctx);
              // تحديد نطاق أمان لحجم الخط بين 85% كحد أدنى و115% كحد أقصى
              // لحماية تناسق الواجهات من التشوه مع الحفاظ على إمكانية الوصول
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiStyleResolver.resolve(ctx),
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: mediaQuery.textScaler.clamp(
                      minScaleFactor: 0.85,
                      maxScaleFactor: 1.15,
                    ),
                  ),
                  child: CustomThemeSwitcher(
                    child: appChild ?? const SizedBox.shrink(),
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}
