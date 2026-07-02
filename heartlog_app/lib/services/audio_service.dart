import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _uuid = const Uuid();

  String? _currentRecordingPath;
  Timer? _recordingTimer;
  int _elapsedSeconds = 0;

  final StreamController<int> _durationController = StreamController<int>.broadcast();
  Stream<int> get durationStream => _durationController.stream;

  Future<bool> requestPermission() async {
    return await _audioRecorder.hasPermission();
  }

  Future<String?> startRecording() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return null;

    final dir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${dir.path}/recordings');
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    _currentRecordingPath = '${recordingsDir.path}/${_uuid.v4()}.m4a';
    _elapsedSeconds = 0;

    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _currentRecordingPath!,
    );

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      _durationController.add(_elapsedSeconds);
    });

    return _currentRecordingPath;
  }

  Future<String?> stopRecording() async {
    _recordingTimer?.cancel();
    final path = await _audioRecorder.stop();
    return path ?? _currentRecordingPath;
  }

  Future<void> pauseRecording() async {
    _recordingTimer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> resumeRecording() async {
    await _audioRecorder.resume();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      _durationController.add(_elapsedSeconds);
    });
  }

  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  Future<void> playAudio(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    _recordingTimer?.cancel();
    await _audioRecorder.dispose();
    await _audioPlayer.dispose();
    await _durationController.close();
  }

  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
