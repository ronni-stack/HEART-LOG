import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heartlog/services/audio_service.dart';
import 'package:heartlog/theme/app_colors.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'entry_detail_screen.dart';

class RecordingScreen extends StatefulWidget {
  final String initialMood;
  final bool skipRecording;

  const RecordingScreen({
    super.key,
    required this.initialMood,
    this.skipRecording = false,
  });

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  final SpeechToText _speech = SpeechToText();

  bool _isPaused = false;
  bool _speechAvailable = false;
  String _transcription = '';
  String? _audioPath;
  int _durationSeconds = 0;
  StreamSubscription<int>? _durationSubscription;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    if (!widget.skipRecording) {
      _initRecording();
    }
  }

  Future<void> _initRecording() async {
    _speechAvailable = await _speech.initialize();
    if (_speechAvailable) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _transcription = result.recognizedWords;
          });
        },
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 30),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
      );
    }

    _durationSubscription = _audioService.durationStream.listen((seconds) {
      setState(() => _durationSeconds = seconds);
    });

    final path = await _audioService.startRecording();
    if (path != null) {
      setState(() => _audioPath = path);
    }
  }

  Future<void> _pauseRecording() async {
    await _audioService.pauseRecording();
    if (_speechAvailable) await _speech.stop();
    setState(() => _isPaused = true);
  }

  Future<void> _resumeRecording() async {
    await _audioService.resumeRecording();
    if (_speechAvailable) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _transcription = result.recognizedWords;
          });
        },
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 30),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
      );
    }
    setState(() => _isPaused = false);
  }

  Future<void> _stopAndSave() async {
    final path = await _audioService.stopRecording();
    if (_speechAvailable) await _speech.stop();
    setState(() => _audioPath = path ?? _audioPath);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EntryDetailScreen(
          initialContent: _transcription,
          audioPath: _audioPath,
          durationSeconds: _durationSeconds,
          mood: widget.initialMood,
        ),
      ),
    );
  }

  Future<void> _cancelRecording() async {
    await _audioService.stopRecording();
    if (_speechAvailable) await _speech.stop();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _durationSubscription?.cancel();
    _audioService.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.skipRecording) {
      return EntryDetailScreen(
        initialContent: '',
        audioPath: null,
        durationSeconds: 0,
        mood: widget.initialMood,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.darkText),
          onPressed: _cancelRecording,
        ),
        title: Text(
          'Listening...',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 180 + (_pulseController.value * 30),
                  height: 180 + (_pulseController.value * 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.sage.withOpacity(0.2 - (_pulseController.value * 0.1)),
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.teal, AppColors.darkGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: AppColors.white,
                        size: 48,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              _audioService.formatDuration(_durationSeconds),
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 24),
            if (_transcription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _transcription,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.mutedText,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildControlButton(
                    icon: _isPaused ? Icons.play_arrow : Icons.pause,
                    label: _isPaused ? 'Resume' : 'Pause',
                    onTap: _isPaused ? _resumeRecording : _pauseRecording,
                  ),
                  _buildControlButton(
                    icon: Icons.stop,
                    label: 'Stop',
                    onTap: _stopAndSave,
                    color: AppColors.coralHeart,
                  ),
                  _buildControlButton(
                    icon: Icons.check,
                    label: 'Done',
                    onTap: _stopAndSave,
                    color: AppColors.darkGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.darkGreen,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
