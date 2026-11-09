# تقرير توثيق حل مشاكل بناء الويندوز واستبدال مشغل الصوت
## Windows Desktop Build Stabilization & Audio Migration Report

**المشروع:** NetSales Platform Dashboard (`smartixit/netsales_dashboard`)  
**الفرع:** `feat/desktop-windowing-foundation`  
**التاريخ:** 2026-11-08  
**الحالة:** مكتمل ومتحقق منه بنجاح (`Exit Code: 0`)

---

## 1. ملخص المشاكل والأسباب الجذرية (Root Cause Analysis)

### المشكلة الأولى: فشل بناء `audioplayers` على ويندوز بسبب NuGet
- **العَرَض:**
  ```text
  Unable to load the service index for source https://api.nuget.org/v3/index.json.
  CMake Error at flutter/ephemeral/.plugin_symlinks/audioplayers_windows/windows/CMakeLists.txt:30 (message):
    Failed to install nuget package Microsoft.Windows.ImplementationLibrary.1.0.260126.7
  ```
- **السبب الجذري:** تعتمد إضافة `audioplayers_windows` أثناء مرحلة توليد CMake على تشغيل أمر `nuget install` لتحميل مكتبة C++/WinRT (`Microsoft.Windows.ImplementationLibrary`) ديناميكياً من الإنترنت عبر `api.nuget.org:443`. نظراً لكون خوادم NuGet محجوبة أو غير مستجيبة في الشبكة المحلية، يفشل البناء تماماً.

### المشكلة الثانية: فشل NuGet المتكرر في `local_auth_windows`
- **العَرَض:**
  ```text
  CMake Error at flutter/ephemeral/.plugin_symlinks/local_auth_windows/windows/CMakeLists.txt:29 (message):
    Failed to install nuget package Microsoft.Windows.ImplementationLibrary.1.0.220201.1
  ```
- **السبب الجذري:** بعد إزالة `audioplayers`، واجه CMake نفس المشكلة مع الإضافة الرسمية `local_auth_windows` التي تستدعي `nuget install` لحزمتي `Microsoft.Windows.ImplementationLibrary` و `Microsoft.Windows.CppWinRT`. على الرغم من وجود الحزم محلياً في كاش الجهاز `C:\Users\DELL\.nuget\packages`، إلا أن أداة `nuget.exe` الافتراضية كانت تحاول الاتصال بـ `api.nuget.org` أولاً وتفشل بعد مهلة الانتظار.

### المشكلة الثالثة: تعارض ماكرو `min/max` في مترجم C++ (حزمة `cnativeapi`)
- **العَرَض:**
  ```text
  C:\Program Files (x86)\Windows Kits\10\include\10.0.19041.0\um\GdiplusTypes.h(479): error C3861: 'min': identifier not found
  C:\Program Files (x86)\Windows Kits\10\include\10.0.19041.0\um\GdiplusTypes.h(481): error C3861: 'max': identifier not found
  Target build_hooks failed : error : Building native assets failed.
  ```
- **السبب الجذري:** خطأ مصنعي من مطوري حزمة `cnativeapi: 0.5.10` على `pub.dev`. قاموا بتعريف `#define NOMINMAX` لمنع تعارضات ويندوز، ثم قاموا بتضمين `<gdiplus.h>` الذي يعتمد على دوال `min`/`max`. تسبب ذلك في فشل تجميع أصول Dart Native Assets على نظام MSVC.

### المشكلة الرابعة: خطأ امتلاء القرص (Disk Full Error 112)
- **العَرَض:**
  ```text
  LINK : fatal error LNK1116: cannot grow ilk file 'NetSales.dir\Debug\NetSales.ilk'; error code 112
  ```
- **السبب الجذري:** كود الخطأ Win32 رقم `112` يعني `ERROR_DISK_FULL`. كان القرص `D:` يحتوي على 10 ميغابايت فقط من المساحة الحرة، مما منع الـ Linker من كتابة ملف الربط التزايدي `NetSales.ilk`. تم حلها بعد تفريغ المساحة بحذف مجلد build القديم.

### المشكلة الخامسة: محاولة التثبيت في مسار محمي `C:/Program Files/netsales`
- **العَرَض:**
  ```text
  CMake Error at cmake_install.cmake:120 (file):
    file cannot create directory: C:/Program Files/netsales. Maybe need administrative privileges.
  ```
- **السبب الجذري:** عدم تعيين بادئة التثبيت `CMAKE_INSTALL_PREFIX` بشكل قطعي، مما جعل CMake يختار افتراضياً مجلد النظام `C:/Program Files` الذي يتطلب صلاحيات المسؤول (UAC).

---

## 2. المعالجات والحلول الهندسية المطبقة (Applied Engineering Solutions)

### أولاً: استبدال `audioplayers` بحزمة `just_audio`
1. تم حذف `audioplayers: ^6.8.1` وملحقاتها.
2. تم إضافة:
   - `just_audio: ^0.10.6`
   - `just_audio_windows: ^0.2.3` (يعتمد على Media Foundation الأصلي لويندوز دون أي حزم NuGet).
3. تم إعادة كتابة وتحديث خدمة الصوت [`lib/core/services/sound_service.dart`](file:///d:/Smartix/NetSales/netsales_dashboard/lib/core/services/sound_service.dart):
   - دعم كامل لأصوات المشروع الخاصة (`assets/sounds/netsales_notification.wav` و `netsales_success.wav`).
   - معالجة تلقائية للمسارات سواء بدأت بـ `assets/` أو بدونها.
   - كتم وإيقاف أي تشغيل سابق بسلاسة قبل بدء تشغيل مقطع جديد لمنع التداخل الصوتي.
   - حماية استدعاءات التشغيل عبر `try/catch` وتسجيل أي أخطاء في وضع التطوير فقط (`kDebugMode`).

### ثانياً: إعداد NuGet قابل للنقل بين الأجهزة وبيئات CI
1. يجب أن يحتوي ملفا `nuget.config` في جذر المشروع ومجلد `windows/` على مصدر NuGet الرسمي فقط، من دون أي مسار cache مرتبط بحساب أو جهاز بعينه:
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <configuration>
     <packageSources>
       <clear />
       <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
     </packageSources>
   </configuration>
   ```
2. لا يُسمح بتعطيل `nuget.org` أو تسجيل مسار مثل `C:\Users\<user>\.nuget\packages` داخل ملفات المشروع؛ فهذا المسار لا يوجد على أجهزة CI النظيفة ويمنع تنزيل الاعتماديات المطلوبة.
3. أي مصدر محلي أو إعداد خاص باتصال مطور واحد يجب أن يبقى ضمن إعدادات المستخدم المحلية، وألا يستبدل مصادر NuGet المشتركة أو يعطلها.

### ثالثاً: عزل وتضمين حزمة `cnativeapi` محلياً (Vendoring)
لضمان عدم عودة خطأ C++ حتى في حال تنفيذ `flutter pub cache clean` أو استنساخ المشروع على جهاز جديد:
1. تم نسخ الحزمة المصححة إلى داخل باقة النوافذ المعنية بها حصراً:
   [`packages/desktop_windowing/third_party/cnativeapi/`](file:///d:/Smartix/NetSales/netsales_dashboard/packages/desktop_windowing/third_party/cnativeapi)
2. تم تصحيح ملفات C++ بإضافة:
   ```cpp
   #include <algorithm>
   using std::min;
   using std::max;
   #include <gdiplus.h>
   ```
   في الملفات:
   - `clipboard_windows.cpp`
   - `drag_source_windows.cpp`
   - `image_windows.cpp`
   - `menu_winui3_windows.cpp`
   - `tray_template_windows_test.cpp`
3. تم تفعيل الحزمة المحلية الدائمة عبر `dependency_overrides` في:
   - [`pubspec.yaml`](file:///d:/Smartix/NetSales/netsales_dashboard/pubspec.yaml):
     ```yaml
     dependency_overrides:
       archive: ^4.5.2
       cnativeapi:
         path: packages/desktop_windowing/third_party/cnativeapi
     ```
   - [`packages/desktop_windowing/pubspec.yaml`](file:///d:/Smartix/NetSales/netsales_dashboard/packages/desktop_windowing/pubspec.yaml):
     ```yaml
     dependency_overrides:
       cnativeapi:
         path: third_party/cnativeapi
     ```

### رابعاً: تصحيح مسار التثبيت في CMake
في ملف [`windows/CMakeLists.txt`](file:///d:/Smartix/NetSales/netsales_dashboard/windows/CMakeLists.txt):
تم تعديل شرط التحقق من `CMAKE_INSTALL_PREFIX` لضمان توجيه التثبيت دائماً إلى مجلد الحزمة التنفيذية `runner/Debug` ومنع التوجيه نحو `C:/Program Files/netsales`:
```cmake
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT OR CMAKE_INSTALL_PREFIX STREQUAL "C:/Program Files/netsales")
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()
```

---

## 3. نتائج التحقق والاختبار (Verification Results)

1. **التحليل الاستاتيكي الشامل (Static Analysis):**
   ```text
   flutter analyze lib/
   No issues found! (ran in 120.2s)
   ```

2. **بناء تطبيق ويندوز الكامل (Windows Native Compilation):**
   ```text
   flutter build windows --debug
   √ Built build\windows\x64\runner\Debug\NetSales.exe (Exit Code: 0)
   ```

3. **سلامة حزمة الإخراج (Bundle Integrity):**
   تم التحقق من وجود كافة الملحقات والملفات في مسار الإخراج النهائي `build/windows/x64/runner/Debug/`:
   - `NetSales.exe` (الملف التنفيذي لنظام NetSales Dashboard).
   - `just_audio_windows_plugin.dll` (ملحق مشغل الصوت).
   - `flutter_windows.dll` و `local_auth_windows_plugin.dll` وبقية الملحقات.
   - `data/flutter_assets/assets/sounds/` بكافة الأصوات الخاصة بالمشروع (`netsales_notification.wav` و `netsales_success.wav`).

