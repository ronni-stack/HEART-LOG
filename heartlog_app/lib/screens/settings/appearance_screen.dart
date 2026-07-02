import 'package:flutter/material.dart';
import 'package:heartlog/theme/app_colors.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  bool _darkMode = false;
  double _fontScale = 1.0;
  String _selectedTheme = 'Calm';

  final List<Map<String, dynamic>> _themes = [
    {'name': 'Calm', 'primary': AppColors.sage, 'accent': AppColors.teal},
    {'name': 'Warm', 'primary': AppColors.peach, 'accent': AppColors.coralHeart},
    {'name': 'Forest', 'primary': AppColors.darkGreen, 'accent': AppColors.sage},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        title: Text('Appearance', style: theme.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildSwitchTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Use darker theme at night',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              const SizedBox(height: 8),
              Text('Theme Color', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Row(
                children: _themes.map((t) {
                  final isSelected = _selectedTheme == t['name'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTheme = t['name'] as String),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? t['primary'] as Color : AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            t['name'] as String,
                            style: TextStyle(
                              color: isSelected ? AppColors.white : AppColors.darkText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Font Size', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Slider(
                      value: _fontScale,
                      min: 0.8,
                      max: 1.3,
                      divisions: 5,
                      activeColor: AppColors.darkGreen,
                      onChanged: (v) => setState(() => _fontScale = v),
                    ),
                    Text(
                      'Preview size: ${(_fontScale * 100).toInt()}%',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
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
            child: Icon(icon, color: AppColors.darkGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkText)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.mutedText)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.darkGreen,
          ),
        ],
      ),
    );
  }
}
