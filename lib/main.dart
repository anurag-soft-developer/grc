import 'package:flutter/material.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/core/binding/initial_binding.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/env_config.dart';
import 'package:grc/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.initialize();

  final queryClient = QueryClient();

  runApp(
    QueryClientProvider.value(
      queryClient,
      child: GetMaterialApp(
        title: EnvConfig.appName,
        theme: _lightTheme,
        initialBinding: InitialBinding(queryClient: queryClient),
        getPages: AppRoutes.routes,
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
      ),
    ),
  );
}

ThemeData get _lightTheme {
  const colorScheme = ColorScheme.light(
    primary: Color(AppColors.primary),
    onPrimary: Colors.white,
    secondary: Color(AppColors.secondary),
    onSecondary: Colors.white,
    surface: Color(AppColors.surface),
    onSurface: Color(AppColors.text),
    error: Color(AppColors.error),
    onError: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(AppColors.background),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Color(AppColors.primary),
      foregroundColor: Colors.white,
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
      fillColor: const Color(AppColors.surface),
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
