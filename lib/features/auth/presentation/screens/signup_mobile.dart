import 'package:auth_screen/core/extensions/context_extensions.dart';
import 'package:auth_screen/core/extensions/responsive_extension.dart';
import 'package:auth_screen/core/extensions/widget_extensions.dart';
import 'package:auth_screen/core/router/route_names.dart';
import 'package:auth_screen/core/theme/app_border_radius.dart';
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
import '../providers/auth_provider.dart';

class SignUpMobile extends StatefulWidget {
  const SignUpMobile({super.key});

  @override
  State<SignUpMobile> createState() => _SignUpMobileState();
}

class _SignUpMobileState extends State<SignUpMobile> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _numberController.text.isEmpty ||
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
          ageString: _numberController.text,
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
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                const AppLogoWidget(height: 60, width: 80),
                24.ht,
                Text(
                  'Create Account',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.ht,
                Text(
                  'Sign in to continue',
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                40.ht,
                CustomTextField(
                  controller: _nameController,
                  hint: 'Full name',
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.person_outlined,
                  fieldType: TextFieldType.name,
                  enableValidation: true,
                  borderRadius: 8,
                ),
                16.ht,
                CustomTextField(
                  controller: _phoneController,
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  fieldType: TextFieldType.phone,
                  enableValidation: true,
                  borderRadius: 8,
                ),
                16.ht,
                CustomTextField(
                  controller: _numberController,
                  hint: 'Age',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.calendar_month_outlined,
                  fieldType: TextFieldType.number,
                  enableValidation: true,
                  borderRadius: 8,
                ),
                16.ht,
                CustomTextField(
                  controller: _emailController,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  fieldType: TextFieldType.email,
                  enableValidation: true,
                  borderRadius: 8,
                ),
                16.ht,
                CustomTextField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  fieldType: TextFieldType.password,
                  enableValidation: true,
                  borderRadius: 8,
                ),
                24.ht,
                CustomOutlinedButton(
                  height: 40.h,
                  width: 200.w,
                  onPressed: authProvider.isLoading ? () {} : _handleSignUp,
                  text: authProvider.isLoading ? 'Please wait...' : 'Sign Up',
                  textStyle: AppTextStyles.bodyMedium.copyWith(
                    height: 1,
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
                16.ht,
                Text(
                  'By continuing you agree to our Terms.',
                  style: context.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 44),
          );
        },
      ),
    );
  }
}
