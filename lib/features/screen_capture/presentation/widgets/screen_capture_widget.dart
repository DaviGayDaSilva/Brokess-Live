import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_capturer/screen_capturer.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/screen_capture_provider.dart';

class ScreenCaptureWidget extends ConsumerStatefulWidget {
  final String sourceId;
  
  const ScreenCaptureWidget({super.key, required this.sourceId});

  @override
  ConsumerState<ScreenCaptureWidget> createState() => _ScreenCaptureWidgetState();
}

class _ScreenCaptureWidgetState extends ConsumerState<ScreenCaptureWidget> {
  Timer? _captureTimer;
  Uint8List? _currentFrame;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _startCapture();
  }

  @override
  void dispose() {
    _stopCapture();
    super.dispose();
  }

  Future<void> _startCapture() async {
    setState(() => _isCapturing = true);
    
    // Capture at 1 FPS
    _captureTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      await _captureFrame();
    });
    
    await _captureFrame();
  }

  Future<void> _captureFrame() async {
    try {
      final data = await ScreenCapturer.instance.capture(
        mode: CaptureMode.screen,
        imagePath: null,
        copyToClipboard: false,
        silent: true,
      );
      
      if (data != null && data.imageBytes != null && mounted) {
        setState(() {
          _currentFrame = data.imageBytes;
          _isCapturing = false;
        });
      }
    } catch (e) {
      debugPrint('Screen capture error: $e');
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  void _stopCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _currentFrame != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                _currentFrame!,
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isCapturing) ...[
                    const CircularProgressIndicator(color: AppTheme.primaryColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Capturando tela...',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.screen_share,
                      size: 48,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Transmissão de Tela',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _startCapture,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Iniciar Captura'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

// Helper function to use screen capturer
final screenCapturer = ScreenCapturer.instance;
