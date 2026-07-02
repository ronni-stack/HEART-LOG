import 'package:flutter/material.dart';
import 'package:heartlog/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _dailyReminder = true;
  bool _moodInsights = true;
  bool _weeklySummary = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        title: Text('Notifications', style: theme.textTheme.headlineMedium),
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
                icon: Icons.notifications_active,
                title: 'Daily Reminder',
                subtitle: 'Remind me to journal every day',
                value: _dailyReminder,
                onChanged: (v) => setState(() => _dailyReminder = v),
              ),
              if (_dailyReminder)
                _buildTimePicker(theme),
              _buildSwitchTile(
                icon: Icons.insights,
                title: 'Mood Insights',
                subtitle: 'Tips based on your mood patterns',
                value: _moodInsights,
                onChanged: (v) => setState(() => _moodInsights = v),
              ),
              _buildSwitchTile(
                icon: Icons.summarize,
                title: 'Weekly Summary',
                subtitle: 'Recap of your week every Sunday',
                value: _weeklySummary,
                onChanged: (v) => setState(() => _weeklySummary = v),
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

  Widget _buildTimePicker(ThemeData theme) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: _reminderTime,
        );
        if (time != null) setState(() => _reminderTime = time);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.mutedText),
            const SizedBox(width: 12),
            Text(
              'Reminder time: ${_reminderTime.format(context)}',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
