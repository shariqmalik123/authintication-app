import 'package:auth_screen/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A Scaffold wrapper that applies a gradient background
class GradientScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Gradient? gradient;
  final bool extendBodyBehindAppBar;

  const GradientScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.gradient,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient:
            gradient ??
            (isDark ? AppColors.darkBackground : AppColors.lightBackground),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
