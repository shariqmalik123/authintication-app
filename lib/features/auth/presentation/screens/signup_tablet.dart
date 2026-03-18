import 'package:auth_screen/core/extensions/context_extensions.dart';
import 'package:auth_screen/core/extensions/responsive_extension.dart';
import 'package:auth_screen/core/router/route_names.dart';
import 'package:auth_screen/core/theme/app_colors.dart';
import 'package:auth_screen/core/theme/app_text_style.dart';
import 'package:auth_screen/core/widgets/buttons/custom_outlined_button.dart';
import 'package:auth_screen/core/widgets/inputs/custom_text_field.dart';
import 'package:auth_screen/core/widgets/more/app_logo_widget.dart';
import 'package:auth_screen/core/widgets/scaffolds/gradient_scaffold.dart';
import 'package:auth_screen/core/widgets/snackbars/custom_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../providers/auth_provider.dart';

class SignUpTablet extends StatefulWidget {
  const SignUpTablet({super.key});

  @override
  State<SignUpTablet> createState() => _SignUpTabletState();
}

class _SignUpTabletState extends State<SignUpTablet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      CustomSnackbar.show(
        context: context,
        message: 'Please fill all fields',
        type: SnackbarType.error,
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    authProvider
        .signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          phone: _phoneController.text,
          ageString: _ageController.text,
        )
        .then((_) {
          if (mounted && authProvider.user != null) {
            context.go(RouteNames.home, extra: authProvider.user!.uid);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogoWidget(height: 80, width: 80),
              40.ht,

              Text(
                'Create Account',
                style: context.textTheme.displaySmall?.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              16.ht,

              Text(
                'Create an account to continue.',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.lightSubText,
                ),
                textAlign: TextAlign.center,
              ),
              48.ht,

              CustomTextField(
                controller: _nameController,
                hint: 'Full name',
                prefixIcon: Icons.person_outlined,
                fieldType: TextFieldType.name,
                enableValidation: true,
              ),
              20.ht,

              CustomTextField(
                controller: _phoneController,
                hint: 'Phone number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                fieldType: TextFieldType.phone,
                enableValidation: true,
              ),
              20.ht,

              CustomTextField(
                controller: _ageController,
                hint: 'Age',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.calendar_month_outlined,
                fieldType: TextFieldType.number,
                enableValidation: true,
              ),
              20.ht,

              CustomTextField(
                controller: _emailController,
                hint: 'Email address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                fieldType: TextFieldType.email,
                enableValidation: true,
              ),
              20.ht,

              CustomTextField(
                controller: _passwordController,
                hint: 'Password',
                obscureText: true,
                prefixIcon: Icons.lock_outlined,
                fieldType: TextFieldType.password,
                enableValidation: true,
              ),
              32.ht,

              CustomOutlinedButton(
                height: 64.h,
                onPressed: authProvider.isLoading ? () {} : _handleSignUp,
                text: authProvider.isLoading
                    ? 'Please wait...'
                    : 'Create Account',
                textStyle: AppTextStyles.bodyMedium.copyWith(
                  height: 1,
                  fontSize: 16.sp,
                  color: AppColors.white,
                ),
                borderRadius: AppBorderRadius.md,
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primary,
              ),

              if (authProvider.errorMessage != null) ...[
                16.ht,
                Text(
                  authProvider.errorMessage!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              40.ht,

              Text(
                'By continuing you agree to our Terms.',
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.lightSubText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
