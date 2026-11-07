library desktop_windowing;

export 'src/config/window_animation_config.dart';
export 'src/config/window_constraints.dart';
export 'src/config/window_profile.dart';
export 'src/config/windowing_config.dart';
export 'src/geometry/window_geometry_resolver.dart';
export 'src/models/window_operation_result.dart';
export 'src/persistence/window_geometry_store.dart';
export 'src/routing/window_profile_router.dart';
export 'src/services/desktop_windowing_controller_stub.dart'
    if (dart.library.io) 'src/services/desktop_windowing_controller_native.dart';
