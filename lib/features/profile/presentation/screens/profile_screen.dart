import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/injection_container.dart';
import '../../../../core/config/responsive_config.dart';
import '../provider/profile_provider.dart';
import 'profile_mobile.dart';
import 'profile_tablet.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: (_) => di<ProfileProvider>()..loadUserProfile(userId),
      child: ResponsiveConfig.isTablet
          ? ProfileTablet(userId: userId)
          : ProfileMobile(userId: userId),
    );
  }
}
