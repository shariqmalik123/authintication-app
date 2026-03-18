import 'package:auth_screen/core/config/responsive_config.dart';
import 'package:auth_screen/features/auth/presentation/screens/signup_mobile.dart';
import 'package:auth_screen/features/auth/presentation/screens/signup_tablet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/injection_container.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => di<AuthProvider>(),
      child: ResponsiveConfig.isTablet ? SignUpTablet() : SignUpMobile(),
    );
  }
}
