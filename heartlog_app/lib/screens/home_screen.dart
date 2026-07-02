import 'package:flutter/material.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'recording_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedMood = 2;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Great', 'emoji': '😄'},
    {'label': 'Good', 'emoji': '🙂'},
    {'label': 'Okay', 'emoji': '😐'},
    {'label': 'Not good', 'emoji': '😔'},
    {'label': 'Awful', 'emoji': '😫'},
  ];

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _startRecording() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecordingScreen(
          initialMood: _moods[_selectedMood]['label'] as String,
        ),
      ),
    );
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_greeting, Mia ☀️',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'How are you\nfeeling today?',
                        style: theme.textTheme.displayLarge?.copyWith(
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkGreen.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _buildIllustration(),
              const SizedBox(height: 28),
              Text(
                'How are you feeling?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_moods.length, (index) {
                  return _buildMoodItem(index);
                }),
              ),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: _startRecording,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.teal, AppColors.darkGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkGreen.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mic,
                          color: AppColors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap to speak',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecordingScreen(
                          initialMood: _moods[_selectedMood]['label'] as String,
                          skipRecording: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Write instead'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodItem(int index) {
    final isSelected = _selectedMood == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = index),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.sage : AppColors.white,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.darkGreen, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreen.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _moods[index]['emoji'] as String,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _moods[index]['label'] as String,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.darkGreen : AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppColors.cream, AppColors.peach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 24,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 0,
            child: Icon(
              Icons.spa,
              size: 120,
              color: AppColors.sage.withOpacity(0.4),
            ),
          ),
          Positioned(
            right: 20,
            top: 30,
            child: Icon(
              Icons.favorite,
              size: 40,
              color: AppColors.coralHeart.withOpacity(0.6),
            ),
          ),
          Positioned(
            right: 40,
            bottom: 20,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.sage,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
