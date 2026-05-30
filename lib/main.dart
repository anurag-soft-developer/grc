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
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(AppColors.primary),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(AppColors.background),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(AppColors.primary),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(AppColors.primary),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(AppColors.surface),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    cardTheme: CardThemeData(
      color: const Color(AppColors.surface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
