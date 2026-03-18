import 'package:auth_screen/core/extensions/context_extensions.dart';
import 'package:auth_screen/core/extensions/responsive_extension.dart';
import 'package:auth_screen/core/extensions/widget_extensions.dart';
import 'package:auth_screen/core/theme/app_colors.dart';
import 'package:auth_screen/core/widgets/cards/custom_card.dart';
import 'package:auth_screen/core/widgets/scaffolds/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class ProfileMobile extends StatefulWidget {
  final String userId;

  const ProfileMobile({super.key, required this.userId});

  @override
  State<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends State<ProfileMobile> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      profileProvider.loadUserProfile(widget.userId);
    });
  }

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
                    size: 64,
                    color: AppColors.error,
                  ),
                  16.ht,
                  Text(
                    'Error loading profile',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  8.ht,
                  Text(
                    provider.errorMessage!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightSubText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).paddingSymmetric(horizontal: 30.w),
            );
          }

          final profile = provider.userProfile;
          if (profile == null) {
            return const Center(child: Text('No profile data'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.ht,

                // header
                Text(
                  'Profile',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                8.ht,
                Text(
                  'Your account information',
                  style: context.textTheme.bodyMedium,
                ),
                40.ht,

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
                      20.ht,
                      _buildInfoRow(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: profile.phone,
                      ),
                      20.ht,
                      _buildInfoRow(
                        context,
                        icon: Icons.cake_outlined,
                        label: 'Age',
                        value: '${profile.age} years',
                      ),
                      20.ht,
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
                30.ht,
              ],
            ).paddingSymmetric(horizontal: 30.w),
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
        Icon(icon, color: AppColors.primary, size: 24),
        12.wt,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.textTheme.labelSmall),
              4.ht,
              Text(
                value,
                style: context.textTheme.bodyLarge?.copyWith(
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
