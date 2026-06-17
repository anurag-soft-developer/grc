class MainTabRoutes {
  static const legacyMain = '/main';

  static const home = '/main/home';
  static const events = '/main/events';
  static const registrations = '/main/registrations';
  static const profile = '/main/profile';

  static const dashboard = '/main/dashboard';
  static const myEvents = '/main/my-events';

  static String defaultForMode(bool isAdminMode) {
    return isAdminMode ? dashboard : home;
  }

  static bool isMainTabRoute(String route) {
    return route == legacyMain ||
        route == home ||
        route == events ||
        route == registrations ||
        route == profile ||
        route == dashboard ||
        route == myEvents;
  }
}
