import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';
import '../services/feature_extractor.dart';
import 'result_screen.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final ApiService _api = ApiService();

  bool _isRecording  = false;
  bool _isProcessing = false;
  bool _isInitialised = false;
  String _statusText = 'Tap the microphone to start recording';
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder.openRecorder();
      setState(() => _isInitialised = true);
    } else {
      setState(() => _statusText = 'Microphone permission denied.');
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (!_isInitialised) {
      setState(() => _statusText = 'Recorder not ready. Check microphone permission.');
      return;
    }

    final dir  = await getTemporaryDirectory();
    final path = '${dir.path}/parkisense_recording.wav';

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
      sampleRate: 44100,
    );

    setState(() {
      _isRecording   = true;
      _recordingPath = path;
      _statusText    = 'Recording... Sustain the vowel "aaah" clearly';
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording  = false;
      _statusText   = 'Processing your voice sample...';
      _isProcessing = true;
    });
    await _processAndPredict();
  }

  Future<void> _processAndPredict() async {
    try {
      final file  = File(_recordingPath!);
      final bytes = await file.readAsBytes();

      final samples = <double>[];
      for (int i = 44; i < bytes.length - 1; i += 2) {
        final lo = bytes[i];
        final hi = bytes[i + 1];
        final raw = (hi << 8) | lo;
        final signed = raw >= 32768 ? raw - 65536 : raw;
        samples.add(signed / 32768.0);
      }

      if (samples.isEmpty) throw Exception('No audio data captured');

      final features = FeatureExtractor.extractFeatures(samples, 44100);
      final result   = await _api.predict(features);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(result: result, features: features),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusText   = 'Error: ${e.toString()}. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        title: const Text('Voice Recording',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F3864),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFF2E75B6), size: 28),
                  SizedBox(height: 10),
                  Text(
                    'Speak clearly into your microphone. Sustain the vowel sound "aaah" for 5–10 seconds in a quiet environment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF444444),
                        height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            GestureDetector(
              onTap: _isProcessing ? null : _toggleRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? const Color(0xFFC00000)
                      : _isProcessing
                          ? Colors.grey
                          : const Color(0xFF2E75B6),
                  boxShadow: [
                    BoxShadow(
                      color: (_isRecording
                              ? const Color(0xFFC00000)
                              : const Color(0xFF2E75B6))
                          .withOpacity(0.35),
                      blurRadius: 24,
                      spreadRadius: 4,
                    )
                  ],
                ),
                child: _isProcessing
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 52,
                      ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              _statusText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _isRecording
                    ? const Color(0xFFC00000)
                    : const Color(0xFF555555),
                fontWeight:
                    _isRecording ? FontWeight.bold : FontWeight.normal,
              ),
            ),

            const SizedBox(height: 48),

            if (_isRecording)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC00000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'RECORDING',
                    style: TextStyle(
                      color: Color(0xFFC00000),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}