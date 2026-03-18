import 'package:auth_screen/core/router/route_names.dart';
import 'package:auth_screen/features/auth/presentation/screens/auth_screen.dart';
import 'package:auth_screen/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: RouteNames.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) {
          final userId = state.extra as String? ?? '';
          return HomeScreen(userId: userId);
        },
      ),
    ],
    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.login),
                child: Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
