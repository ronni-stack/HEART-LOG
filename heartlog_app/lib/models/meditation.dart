import 'package:flutter/material.dart';
import 'package:heartlog/theme/app_colors.dart';

class Meditation {
  final String id;
  final String title;
  final String subtitle;
  final int durationMinutes;
  final String category;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final String? assetPath;

  Meditation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.durationMinutes,
    required this.category,
    required this.icon,
    required this.startColor,
    required this.endColor,
    this.assetPath,
  });
}

final List<Meditation> sampleMeditations = [
  Meditation(
    id: '1',
    title: 'Calm Breathing',
    subtitle: '5 min',
    durationMinutes: 5,
    category: 'All',
    icon: Icons.self_improvement,
    startColor: AppColors.teal,
    endColor: AppColors.darkGreen,
  ),
  Meditation(
    id: '2',
    title: 'Evening Serenity',
    subtitle: '10 min',
    durationMinutes: 10,
    category: 'Sleep',
    icon: Icons.nights_stay,
    startColor: const Color(0xFF7BA3A1),
    endColor: const Color(0xFF4E6B63),
  ),
  Meditation(
    id: '3',
    title: 'Deep Sleep',
    subtitle: '20 min',
    durationMinutes: 20,
    category: 'Sleep',
    icon: Icons.bedtime,
    startColor: const Color(0xFF4E6B63),
    endColor: const Color(0xFF3A524C),
  ),
  Meditation(
    id: '4',
    title: 'Morning Light',
    subtitle: '8 min',
    durationMinutes: 8,
    category: 'Focus',
    icon: Icons.wb_sunny,
    startColor: const Color(0xFFF4A58C),
    endColor: const Color(0xFFFFD6B8),
  ),
  Meditation(
    id: '5',
    title: 'Anxiety Relief',
    subtitle: '12 min',
    durationMinutes: 12,
    category: 'Anxiety',
    icon: Icons.spa,
    startColor: AppColors.sage,
    endColor: AppColors.teal,
  ),
];

final List<String> meditationCategories = [
  'All',
  'Sleep',
  'Anxiety',
  'Focus',
];
