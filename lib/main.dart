import 'package:auth_screen/app/authintication_app.dart';
import 'package:auth_screen/app/injection_container.dart';
import 'package:auth_screen/core/config/responsive_config.dart';
import 'package:auth_screen/core/utils/system_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/logger/logger_service.dart';
import 'firebase_options.dart';

void main() async {
  //ensure flutter bindings are initialized before any other setup
  WidgetsFlutterBinding.ensureInitialized();

  //firebase initiallization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //logger service instance for logging app start
  LoggerService(className: 'main').info('App Starting...');

  //set sytem styles for status bar and navigation bar default initially
  SystemUtils.setDefaultSystemUI();

  //lock orientation to portrait mode
  await SystemUtils.lockOrientation();

  // Initialize dependency injection
  await initializeDependencies();

  //for development, you can use DevicePreview to test responsiveness on different devices. Uncomment the below code to enable it.
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => ResponsiveProvider(
  //       mobileSize: Size(360, 800),
  //       tabletSize: Size(800, 1280),
  //       isDebugPrint: true,
  //       child: const AppName(),
  //     ),
  //   ),
  // );

  runApp(
    ResponsiveProvider(
      mobileSize: Size(360, 800),
      tabletSize: Size(800, 1280),
      isDebugPrint: true,
      child: const AppName(),
    ),
  );
}
