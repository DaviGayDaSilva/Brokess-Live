import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/entities/stream_settings.dart';

class StreamNotifier extends StateNotifier<StreamState> {
  final Box _box;
  Timer? _durationTimer;
  DateTime? _startTime;

  StreamNotifier(this._box) : super(const StreamState()) {
    _loadSettings();
  }

  StreamSettings _settings = const StreamSettings();

  StreamSettings get settings => _settings;

  void _loadSettings() {
    final settingsJson = _box.get('stream_settings');
    if (settingsJson != null) {
      _settings = StreamSettings.fromJson(Map<String, dynamic>.from(settingsJson));
    }
  }

  void updateSettings(StreamSettings settings) {
    _settings = settings;
    _box.put('stream_settings', settings.toJson());
    state = state.copyWith();
  }

  Future<void> startStream() async {
    if (_settings.rtmpUrl.isEmpty || _settings.streamKey.isEmpty) {
      state = state.copyWith(
        status: StreamStatus.error,
        errorMessage: 'Configure o URL RTMP e a chave de stream',
      );
      return;
    }

    state = state.copyWith(
      status: StreamStatus.connecting,
      duration: Duration.zero,
      droppedFrames: 0,
      bitrate: 0,
    );

    await Future.delayed(const Duration(seconds: 2));

    _startTime = DateTime.now();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        state = state.copyWith(
          status: StreamStatus.live,
          duration: DateTime.now().difference(_startTime!),
          bitrate: _settings.videoBitrate.toDouble(),
        );
      }
    });
  }

  void pauseStream() {
    _durationTimer?.cancel();
    state = state.copyWith(status: StreamStatus.paused);
  }

  void resumeStream() {
    _startTime = DateTime.now().subtract(state.duration);
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        state = state.copyWith(
          status: StreamStatus.live,
          duration: DateTime.now().difference(_startTime!),
        );
      }
    });
  }

  Future<void> stopStream() async {
    _durationTimer?.cancel();
    _startTime = null;
    
    state = state.copyWith(
      status: StreamStatus.idle,
      duration: Duration.zero,
      droppedFrames: 0,
      bitrate: 0,
    );
  }

  void startRecording() {
    state = state.copyWith(isRecording: true);
  }

  void stopRecording() {
    state = state.copyWith(isRecording: false);
  }

  void updateStats({
    int? droppedFrames,
    double? bitrate,
  }) {
    state = state.copyWith(
      droppedFrames: droppedFrames ?? state.droppedFrames,
      bitrate: bitrate ?? state.bitrate,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: StreamStatus.error,
      errorMessage: message,
    );
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }
}

final streamProvider = StateNotifierProvider<StreamNotifier, StreamState>((ref) {
  final box = Hive.box('stream_box');
  return StreamNotifier(box);
});

final streamSettingsProvider = Provider<StreamSettings>((ref) {
  final notifier = ref.watch(streamProvider.notifier);
  ref.watch(streamProvider);
  return notifier.settings;
});
