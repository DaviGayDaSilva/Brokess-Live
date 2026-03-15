import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_capturer/screen_capturer.dart';

class ScreenCaptureNotifier extends StateNotifier<ScreenCaptureState> {
  Timer? _captureTimer;
  
  ScreenCaptureNotifier() : super(ScreenCaptureState.idle());

  Future<void> startCapture({
    int intervalMs = 1000,
  }) async {
    state = ScreenCaptureState.capturing();
    
    // Capture continuously at the specified interval
    _captureTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) async {
      await _doCapture();
    });
    
    // Do initial capture
    await _doCapture();
  }

  Future<void> _doCapture() async {
    try {
      final data = await screenCapturer.capture(
        mode: CaptureMode.screen,
        imagePath: null,
        copyToClipboard: false,
        silent: true,
      );
      
      if (data != null && data.imageBytes != null) {
        state = ScreenCaptureState.captured(data.imageBytes!);
      }
    } catch (e) {
      state = ScreenCaptureState.error(e.toString());
    }
  }

  Future<void> captureOnce() async {
    state = ScreenCaptureState.capturing();
    await _doCapture();
  }

  void stopCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
    state = ScreenCaptureState.idle();
  }

  @override
  void dispose() {
    stopCapture();
    super.dispose();
  }
}

enum ScreenCaptureStatus {
  idle,
  capturing,
  captured,
  error,
}

class ScreenCaptureState {
  final ScreenCaptureStatus status;
  final Uint8List? imageBytes;
  final String? error;

  ScreenCaptureState({
    required this.status,
    this.imageBytes,
    this.error,
  });

  factory ScreenCaptureState.idle() => ScreenCaptureState(status: ScreenCaptureStatus.idle);
  factory ScreenCaptureState.capturing() => ScreenCaptureState(status: ScreenCaptureStatus.capturing);
  factory ScreenCaptureState.captured(Uint8List bytes) => ScreenCaptureState(status: ScreenCaptureStatus.captured, imageBytes: bytes);
  factory ScreenCaptureState.error(String error) => ScreenCaptureState(status: ScreenCaptureStatus.error, error: error);
}

final screenCaptureProvider = StateNotifierProvider<ScreenCaptureNotifier, ScreenCaptureState>((ref) {
  return ScreenCaptureNotifier();
});

// Helper for direct capture
final screenCapturer = ScreenCapturer.instance;
