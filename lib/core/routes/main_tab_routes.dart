class MainTabRoutes {
  static const home = '/home';
  static const events = '/events';
  static const registrations = '/registrations';
  static const profile = '/profile';

  static const dashboard = '/dashboard';
  static const myEvents = '/my-events';

  static String defaultForMode(bool isAdminMode) {
    return isAdminMode ? dashboard : home;
  }

  static bool isMainTabRoute(String route) {
    return route == home ||
        route == events ||
        route == registrations ||
        route == profile ||
        route == dashboard ||
        route == myEvents;
  }
}
