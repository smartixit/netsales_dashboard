import 'package:flutter/widgets.dart';

/// Serializable snapshot boundary. The host application chooses the storage
/// technology; the package does not depend on SharedPreferences or a database.
class WindowGeometrySnapshot {
  const WindowGeometrySnapshot({
    required this.bounds,
    required this.wasMaximized,
  });

  final Rect bounds;
  final bool wasMaximized;
}

abstract interface class WindowGeometryStore {
  Future<WindowGeometrySnapshot?> read();

  Future<void> write(WindowGeometrySnapshot snapshot);

  Future<void> clear();
}
