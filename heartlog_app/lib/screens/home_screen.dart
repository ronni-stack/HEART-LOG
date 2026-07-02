import 'package:flutter/material.dart';
import 'package:heartlog/models/journal_entry.dart';
import 'package:heartlog/services/database_service.dart';
import 'package:heartlog/services/user_service.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'package:uuid/uuid.dart';
import 'recording_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedMood = 2;
  String _userName = 'Ronny';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await UserService().name;
    if (mounted) setState(() => _userName = name);
  }

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

  Future<void> _onMoodSelected(int index) async {
    setState(() => _selectedMood = index);
    final mood = _moods[index]['label'] as String;

    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _MoodReasonDialog(mood: mood),
    );

    if (reason == null || !mounted) return;

    final entry = JournalEntry(
      id: const Uuid().v4(),
      title: 'Feeling $mood',
      content: reason.trim().isEmpty
          ? 'I\'m feeling $mood today.'
          : 'I\'m feeling $mood because: $reason',
      mood: mood,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await DatabaseService().insertEntry(entry);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood logged: $mood')),
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
                        '$_greeting, $_userName ☀️',
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
      onTap: () => _onMoodSelected(index),
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

class _MoodReasonDialog extends StatefulWidget {
  final String mood;

  const _MoodReasonDialog({required this.mood});

  @override
  State<_MoodReasonDialog> createState() => _MoodReasonDialogState();
}

class _MoodReasonDialogState extends State<_MoodReasonDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Why do you feel ${widget.mood.toLowerCase()}?',
        style: theme.textTheme.headlineMedium,
      ),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Optional: write a few words...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
