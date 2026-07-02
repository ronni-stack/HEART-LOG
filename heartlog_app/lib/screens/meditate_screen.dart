import 'package:flutter/material.dart';
import 'package:heartlog/models/meditation.dart';
import 'package:heartlog/theme/app_colors.dart';

class MeditateScreen extends StatefulWidget {
  const MeditateScreen({super.key});

  @override
  State<MeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<MeditateScreen> {
  String _selectedCategory = 'All';

  List<Meditation> get _filteredMeditations {
    if (_selectedCategory == 'All') return sampleMeditations;
    return sampleMeditations
        .where((m) => m.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good evening 🌙',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Take a deep breath,\nyou\'re safe here.',
                    style: theme.textTheme.displayMedium?.copyWith(
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: meditationCategories.length,
                itemBuilder: (context, index) {
                  final category = meditationCategories[index];
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.darkGreen
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.darkText,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filteredMeditations.length,
                itemBuilder: (context, index) {
                  return _buildMeditationCard(_filteredMeditations[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationCard(Meditation meditation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [meditation.startColor, meditation.endColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: meditation.endColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                meditation.icon,
                color: AppColors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meditation.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meditation.durationMinutes} min',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
