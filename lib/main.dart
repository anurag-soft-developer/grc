import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/binding/initial_binding.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/env_config.dart';
import 'package:grc/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Use clean path URLs on web instead of hash-based URLs.
    usePathUrlStrategy();
  }

  await EnvConfig.initialize();

  final queryClient = QueryClient();
  InitialBinding(queryClient: queryClient).dependencies();
  await Get.find<AuthStateController>().ensureHydrated();

  runApp(
    QueryClientProvider.value(
      queryClient,
      child: GetMaterialApp(
        title: EnvConfig.appName,
        theme: _darkTheme,
        darkTheme: _darkTheme,
        themeMode: ThemeMode.dark,
        initialBinding: InitialBinding(queryClient: queryClient),
        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.resolveInitialRoute(),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
      ),
    ),
  );
}

ThemeData get _darkTheme {
  const colorScheme = ColorScheme.dark(
    primary: Color(AppColors.primary),
    onPrimary: Color(AppColors.background),
    secondary: Color(AppColors.secondary),
    onSecondary: Color(AppColors.background),
    surface: Color(AppColors.surface),
    onSurface: Color(AppColors.text),
    onSurfaceVariant: Color(AppColors.textSecondary),
    outline: Color(AppColors.divider),
    error: Color(AppColors.error),
    onError: Color(AppColors.background),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(AppColors.background),
    canvasColor: const Color(AppColors.surface),
    splashColor: colorScheme.primary.withValues(alpha: 0.08),
    highlightColor: Colors.transparent,
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: const Color(AppColors.text),
      displayColor: const Color(AppColors.text),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Color(AppColors.surface),
      foregroundColor: Color(AppColors.text),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(AppColors.background),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(AppColors.divider)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(AppColors.divider)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(AppColors.primary), width: 2),
      ),
    ),
    dividerColor: const Color(AppColors.divider),
    dividerTheme: const DividerThemeData(
      color: Color(AppColors.divider),
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: const Color(AppColors.surface),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(AppColors.divider)),
      ),
    ),
  );
}
