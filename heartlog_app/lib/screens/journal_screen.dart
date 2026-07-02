import 'package:flutter/material.dart';
import 'package:heartlog/services/database_service.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import 'entry_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<JournalEntry> _entries = [];
  List<JournalEntry> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _databaseService.getEntries();
    setState(() {
      _entries = entries;
      _filteredEntries = entries;
    });
  }

  void _filterEntries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEntries = _entries;
      } else {
        _filteredEntries = _entries
            .where((entry) =>
                entry.title.toLowerCase().contains(query.toLowerCase()) ||
                entry.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Great':
        return '😄';
      case 'Good':
        return '🙂';
      case 'Okay':
        return '😐';
      case 'Not good':
        return '😔';
      case 'Awful':
        return '😫';
      default:
        return '😐';
    }
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
              child: Text(
                'My Journal',
                style: theme.textTheme.displayMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: _filterEntries,
                decoration: InputDecoration(
                  hintText: 'Search your entries...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.mutedText),
                  suffixIcon: const Icon(Icons.tune, color: AppColors.mutedText),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredEntries.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredEntries.length,
                      itemBuilder: (context, index) {
                        return _buildEntryCard(_filteredEntries[index], theme);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.book_outlined,
            size: 64,
            color: AppColors.sage,
          ),
          const SizedBox(height: 16),
          Text(
            'No entries yet',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start journaling to see your entries here.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(JournalEntry entry, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EntryDetailScreen(
              initialContent: entry.content,
              audioPath: entry.audioPath,
              durationSeconds: entry.durationSeconds,
              mood: entry.mood,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGreen.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getMoodEmoji(entry.mood),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(entry.createdAt),
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.title,
                    style: theme.textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.content,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
