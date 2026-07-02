import 'dart:math' show max;
import 'package:flutter/material.dart';
import 'package:heartlog/services/audio_service.dart';
import 'package:heartlog/services/database_service.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';

class EntryDetailScreen extends StatefulWidget {
  final String initialContent;
  final String? audioPath;
  final int durationSeconds;
  final String mood;

  const EntryDetailScreen({
    super.key,
    required this.initialContent,
    this.audioPath,
    required this.durationSeconds,
    required this.mood,
  });

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late TextEditingController _contentController;
  final AudioService _audioService = AudioService();
  final DatabaseService _databaseService = DatabaseService();

  bool _isPlaying = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.initialContent);
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioService.pauseAudio();
      setState(() => _isPlaying = false);
    } else if (widget.audioPath != null) {
      await _audioService.playAudio(widget.audioPath!);
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _saveEntry() async {
    setState(() => _isSaving = true);

    final content = _contentController.text.trim();
    final title = content.isNotEmpty
        ? content.split('\n').first
        : 'Voice journal entry';

    final entry = JournalEntry(
      id: const Uuid().v4(),
      title: title.length > 60 ? '${title.substring(0, 60)}...' : title,
      content: content,
      audioPath: widget.audioPath,
      durationSeconds: widget.durationSeconds,
      mood: widget.mood,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _databaseService.insertEntry(entry);

    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved successfully')),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _deleteEntry() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.coralHeart),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Here is your entry',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkGreen.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: InputBorder.none,
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 20),
              if (widget.audioPath != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleAudio,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.sage,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Play audio',
                        style: theme.textTheme.labelLarge,
                      ),
                      const Spacer(),
                      Text(
                        _audioService.formatDuration(
                          max(widget.durationSeconds, 1),
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveEntry,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: Text(_isSaving ? 'Saving...' : 'Save Entry'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _deleteEntry,
                  icon: const Icon(Icons.delete_outline, color: AppColors.coralHeart),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.coralHeart),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
