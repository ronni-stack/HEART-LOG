import 'package:flutter/material.dart';
import 'package:heartlog/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Profile',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.cream, AppColors.peach],
                        ),
                        border: Border.all(
                          color: AppColors.sage,
                          width: 3,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mia',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                      Text(
                      'mia@heartlog.app',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(theme, 'Settings'),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Daily reminders & insights',
              ),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: 'Privacy',
                subtitle: 'Secure your journal entries',
              ),
              _buildMenuItem(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: 'Theme & display options',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(theme, 'Support'),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'FAQs and support',
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About HeartLog',
                subtitle: 'Version 1.0.0',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.mutedText,
          ),
        ],
      ),
    );
  }
}
