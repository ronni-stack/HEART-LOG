import 'package:flutter/material.dart';
import 'package:heartlog/screens/main_scaffold.dart';
import 'package:heartlog/screens/onboarding_screen.dart';
import 'package:heartlog/services/user_service.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'package:heartlog/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HeartLogApp());
}

class HeartLogApp extends StatelessWidget {
  const HeartLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeartLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashDecisionScreen(),
    );
  }
}

class SplashDecisionScreen extends StatefulWidget {
  const SplashDecisionScreen({super.key});

  @override
  State<SplashDecisionScreen> createState() => _SplashDecisionScreenState();
}

class _SplashDecisionScreenState extends State<SplashDecisionScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final completed = await UserService().hasCompletedOnboarding;
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => completed
            ? const MainScaffold()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.darkGreen),
      ),
    );
  }
}
