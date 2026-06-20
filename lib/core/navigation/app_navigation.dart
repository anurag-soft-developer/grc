import 'package:get/get.dart';

/// Central navigation helper used instead of calling GetX directly.
class AppNavigation {
  AppNavigation._();

  static Future<T?> toNamed<T>(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
    bool preventDuplicates = true,
  }) {
    // Do not pass <T> to Get.toNamed — GetX routes are GetPageRoute<dynamic>
    // and a typed call throws on web: "GetPageRoute<dynamic> is not a subtype
    // of Route<T?>?".
    final result = Get.toNamed(
      route,
      arguments: arguments,
      parameters: parameters,
      preventDuplicates: preventDuplicates,
    );
    if (result == null) {
      return Future<T?>.value(null);
    }
    return result.then((value) => value as T?);
  }
}
