import 'package:auth_screen/core/config/responsive_config.dart';
import 'package:auth_screen/core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/theme_provider.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //only global providers will be added here
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, _) {
          return MaterialApp.router(
            title: 'Authintication App',
            debugShowCheckedModeBanner: false,

            // Themes
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,

            // Router
            routerConfig: AppRouter.appRouter,

            // Responsive wrapper
            builder: (context, child) {
              return ResponsiveProvider(
                isDebugPrint: true,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
