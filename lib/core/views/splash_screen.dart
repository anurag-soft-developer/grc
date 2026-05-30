import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(AppColors.primary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_run, size: 80, color: Colors.white),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class AuthWrapper extends HookWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final authRepo = Get.find<AuthRepository>();
    final client = useQueryClient();

    final bootstrap = useQuery(
      QueryKeys.authStatus,
      (ctx) async {
        final stored = await authRepo.getStoredUser();
        if (stored == null) return false;
        try {
          final status = await authRepo.getAuthStatus();
          if (status != null) {
            authState.setUser(status.user);
            return true;
          }
        } catch (_) {}
        authState.setUser(stored);
        return true;
      },
    );

    useEffect(() {
      if (bootstrap.isLoading) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final loggedIn = bootstrap.data == true || authState.isLoggedIn;
        Get.offAllNamed(
          loggedIn ? AppRoutes.mainRoute : AppConstants.routes.login,
        );
      });
      return null;
    }, [bootstrap.isLoading, bootstrap.data]);

    if (bootstrap.isError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not verify session'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => bootstrap.refetch(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return const SplashScreen();
  }
}
