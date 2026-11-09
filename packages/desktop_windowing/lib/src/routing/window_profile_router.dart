/// Resolves route names to window profiles, including parameterized paths,
/// without depending on GetX, Navigator, or a particular routing package.
class WindowProfileRouter {
  const WindowProfileRouter(this.routeProfiles);

  final Map<String, String> routeProfiles;

  String? resolve(String? routeName) {
    if (routeName == null || routeName.isEmpty) return null;
    final normalized = routeName.split('?').first.replaceFirst(RegExp(r'/+$'), '');
    final exact = routeProfiles[normalized];
    if (exact != null) return exact;

    for (final entry in routeProfiles.entries) {
      if (_matches(entry.key, normalized)) return entry.value;
    }
    return null;
  }

  bool _matches(String pattern, String path) {
    if (!pattern.contains(':') && !pattern.contains('*')) return false;
    final patternSegments = pattern.split('/').where((segment) => segment.isNotEmpty).toList();
    final pathSegments = path.split('/').where((segment) => segment.isNotEmpty).toList();
    if (patternSegments.length != pathSegments.length) return false;

    for (var index = 0; index < patternSegments.length; index++) {
      final expected = patternSegments[index];
      final actual = pathSegments[index];
      if (expected == '*') continue;
      if (expected.startsWith(':')) {
        if (actual.isEmpty) return false;
        continue;
      }
      if (expected != actual) return false;
    }
    return true;
  }
}
