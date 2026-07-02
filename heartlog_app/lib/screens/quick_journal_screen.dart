import 'package:flutter/material.dart';
import 'package:heartlog/models/journal_entry.dart';
import 'package:heartlog/services/database_service.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class QuickJournalScreen extends StatefulWidget {
  const QuickJournalScreen({super.key});

  @override
  State<QuickJournalScreen> createState() => _QuickJournalScreenState();
}

class _QuickJournalScreenState extends State<QuickJournalScreen> {
  final _contentController = TextEditingController();
  final _moods = [
    {'label': 'Great', 'emoji': '😄'},
    {'label': 'Good', 'emoji': '🙂'},
    {'label': 'Okay', 'emoji': '😐'},
    {'label': 'Not good', 'emoji': '😔'},
    {'label': 'Awful', 'emoji': '😫'},
  ];
  int _selectedMood = 2;
  bool _isSaving = false;

  Future<void> _saveEntry() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final mood = _moods[_selectedMood]['label'] as String;
    final entry = JournalEntry(
      id: const Uuid().v4(),
      title: content.length > 60 ? '${content.substring(0, 60)}...' : content,
      content: content,
      mood: mood,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await DatabaseService().insertEntry(entry);

    setState(() => _isSaving = false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        title: Text('Quick Journal', style: theme.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('How are you feeling?', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_moods.length, (index) {
                  final isSelected = _selectedMood == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = index),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.sage : AppColors.white,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: AppColors.darkGreen, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              _moods[index]['emoji'] as String,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _moods[index]['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.darkGreen : AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: InputBorder.none,
                    ),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveEntry,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                        )
                      : const Text('Save Entry'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
