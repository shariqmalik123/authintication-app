import 'package:auth_screen/core/extensions/context_extensions.dart';
import 'package:auth_screen/core/extensions/responsive_extension.dart';
import 'package:auth_screen/core/extensions/widget_extensions.dart';
import 'package:auth_screen/core/theme/app_colors.dart';
import 'package:auth_screen/core/widgets/cards/custom_card.dart';
import 'package:auth_screen/core/widgets/scaffolds/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class ProfileTablet extends StatefulWidget {
  final String userId;

  const ProfileTablet({super.key, required this.userId});

  @override
  State<ProfileTablet> createState() => _ProfileTabletState();
}

class _ProfileTabletState extends State<ProfileTablet> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppColors.error,
                  ),
                  24.ht,
                  Text(
                    'Error loading profile',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  12.ht,
                  Text(
                    provider.errorMessage!,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightSubText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).paddingSymmetric(horizontal: 60.w),
            );
          }

          final profile = provider.userProfile;
          if (profile == null) {
            return const Center(child: Text('No profile data'));
          }

          return Container(
            constraints: BoxConstraints(maxWidth: 600.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  80.ht,

                  // header
                  Text(
                    'Profile',
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  12.ht,
                  Text(
                    'Your account information',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightSubText,
                    ),
                  ),
                  50.ht,

                  // profile card
                  CustomCard(
                    color: AppColors.white.withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          icon: Icons.person_outline,
                          label: 'Name',
                          value: profile.name,
                        ),
                        30.ht,
                        _buildInfoRow(
                          context,
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: profile.phone,
                        ),
                        30.ht,
                        _buildInfoRow(
                          context,
                          icon: Icons.cake_outlined,
                          label: 'Age',
                          value: '${profile.age} years',
                        ),
                        30.ht,
                        _buildInfoRow(
                          context,
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: profile.email,
                        ),
                      ],
                    ),
                  ).decorated(
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  40.ht,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        16.wt,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.lightSubText,
                ),
              ),
              6.ht,
              Text(
                value,
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
