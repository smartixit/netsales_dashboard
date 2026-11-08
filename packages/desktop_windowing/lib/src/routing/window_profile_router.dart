/// Resolves a route name to a configured window profile without depending on
/// GetX, Navigator, or a particular routing package.
class WindowProfileRouter {
  const WindowProfileRouter(this.routeProfiles);

  final Map<String, String> routeProfiles;

  String? resolve(String? routeName) {
    if (routeName == null || routeName.isEmpty) {
      return null;
    }

    return routeProfiles[routeName];
  }
}
