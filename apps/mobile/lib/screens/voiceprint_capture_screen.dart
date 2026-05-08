import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../cubits/voiceprint_cubit.dart';
import '../widgets/voice_waveform.dart';
import '../widgets/biometric_consent_dialog.dart';

class VoiceprintCaptureScreen extends StatelessWidget {
  const VoiceprintCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoiceprintCubit(),
      child: const _VoiceprintCaptureContent(),
    );
  }
}

class _VoiceprintCaptureContent extends StatefulWidget {
  const _VoiceprintCaptureContent();

  @override
  State<_VoiceprintCaptureContent> createState() => _VoiceprintCaptureContentState();
}

class _VoiceprintCaptureContentState extends State<_VoiceprintCaptureContent> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasPermission = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _consentGiven = false;
  Duration _recordingDuration = Duration.zero;
  String? _recordingPath;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.microphone.status;
    setState(() => _hasPermission = status.isGranted);
    if (!_hasPermission) await Permission.microphone.request();
  }

  Future<void> _showConsentDialog() async {
    final consent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BiometricConsentDialog(
        dataType: 'Voiceprint',
        purpose: 'Create AI-powered Blooms and Legacy Reels',
        retention: 'Stored encrypted in your Root profile',
        rights: [
          'Right to delete at any time',
          'Never shared with third parties',
          'Used only for your designated Blooms',
        ],
      ),
    );

    if (consent == true && mounted) {
      setState(() => _consentGiven = true);
    }
  }

  Future<void> _startRecording() async {
    if (!_hasPermission || !_consentGiven) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${dir.path}/voiceprint_$timestamp.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordingPath = path;
        _recordingDuration = Duration.zero;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordingDuration = Duration(seconds: timer.tick));
        if (_recordingDuration.inSeconds >= 120) _stopRecording();
      });
    } catch (e) {
      _showError('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _timer?.cancel();
      setState(() => _isRecording = false);
    } catch (e) {
      _showError('Failed to stop recording: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath == null) return;
    try {
      await _audioPlayer.setFilePath(_recordingPath!);
      await _audioPlayer.play();
      setState(() => _isPlaying = true);
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      _showError('Failed to play: $e');
    }
  }

  void _processVoiceprint() {
    if (_recordingPath != null) {
      context.read<VoiceprintCubit>().createVoiceprint(_recordingPath!);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: KinnectColors.error),
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceprintCubit, VoiceprintState>(
      listener: (context, state) {
        if (state is VoiceprintCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voiceprint created successfully!'), backgroundColor: KinnectColors.success),
          );
          Navigator.pop(context, state.voiceprintId);
        } else if (state is VoiceprintError) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: KinnectColors.background,
        appBar: AppBar(
          backgroundColor: KinnectColors.surface,
          title: Text('Voiceprint Capture', style: KinnectTextStyles.headlineSmall),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: KinnectColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(Icons.mic, size: 60, color: KinnectColors.accent),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording ? 'Recording...' : 'Ready to Record',
                  style: KinnectTextStyles.headlineMedium,
                ),
                const SizedBox(height: 32),
                
                if (!_consentGiven) _buildConsentPrompt(),
                if (_consentGiven) _buildRecordingInterface(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsentPrompt() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: _showConsentDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: KinnectColors.accent,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: const Text('Provide Biometric Consent'),
      ),
    );
  }

  Widget _buildRecordingInterface() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            '${_recordingDuration.inMinutes.toString().padLeft(2, '0')}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')} / 02:00',
            style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 32),
          ),
          const SizedBox(height: 32),
          VoiceWaveform(isRecording: _isRecording, duration: _recordingDuration),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isRecording ? KinnectColors.error : KinnectColors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 40),
            ),
          ),
          if (_recordingPath != null && !_isRecording) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _playRecording,
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, color: KinnectColors.accent, size: 32),
                ),
                const Text('Preview', style: TextStyle(color: KinnectColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<VoiceprintCubit, VoiceprintState>(
              builder: (context, state) {
                final isProcessing = state is VoiceprintProcessing;
                return ElevatedButton(
                  onPressed: isProcessing ? null : _processVoiceprint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KinnectColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  child: isProcessing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Process Voiceprint'),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
