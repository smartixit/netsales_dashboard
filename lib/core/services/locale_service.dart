import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/services/storage_service.dart';

class LocaleService extends GetxService {
  LocaleService._();
  static final LocaleService instance = LocaleService._();
  static LocaleService get to => Get.isRegistered<LocaleService>() ? Get.find<LocaleService>() : instance;
  final Rx<Locale> _locale = const Locale('ar').obs;
  Locale get locale => _locale.value;
  bool get isArabic => _locale.value.languageCode == 'ar';

  Future<LocaleService> init() async {
    final code = StorageService.instance.locale;
    _locale.value = Locale(code == 'en' ? 'en' : 'ar');
    return this;
  }

  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode == 'en' ? 'en' : 'ar';
    final next = Locale(code);
    if (_locale.value == next) return;
    _locale.value = next;
    await Get.updateLocale(next);
    await StorageService.instance.saveLocale(code);
  }

  Future<void> toggleLocale() => setLocale(Locale(isArabic ? 'en' : 'ar'));
}
