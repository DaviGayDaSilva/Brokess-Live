import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';

enum AudioSourceStatus {
  idle,
  recording,
  stopped,
  error,
}

class AudioState {
  final AudioSourceStatus status;
  final bool isMuted;
  final double volume;
  final double microphoneLevel;
  final String? errorMessage;

  const AudioState({
    this.status = AudioSourceStatus.idle,
    this.isMuted = false,
    this.volume = 1.0,
    this.microphoneLevel = 0.0,
    this.errorMessage,
  });

  AudioState copyWith({
    AudioSourceStatus? status,
    bool? isMuted,
    double? volume,
    double? microphoneLevel,
    String? errorMessage,
  }) {
    return AudioState(
      status: status ?? this.status,
      isMuted: isMuted ?? this.isMuted,
      volume: volume ?? this.volume,
      microphoneLevel: microphoneLevel ?? this.microphoneLevel,
      errorMessage: errorMessage,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  AudioSession? _audioSession;

  AudioNotifier() : super(const AudioState()) {
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _audioSession = await AudioSession.instance;
        await _audioSession!.configure(const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.allowBluetooth |
                  AVAudioSessionCategoryOptions.defaultToSpeaker,
          avAudioSessionMode: AVAudioSessionMode.videoChat,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.speech,
            flags: AndroidAudioFlags.none,
            usage: AndroidAudioUsage.voiceCommunication,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ));
        state = state.copyWith(status: AudioSourceStatus.idle);
      } else {
        state = state.copyWith(
          status: AudioSourceStatus.error,
          errorMessage: 'Microphone permission denied',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AudioSourceStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
  }

  void updateMicrophoneLevel(double level) {
    if (!state.isMuted) {
      state = state.copyWith(microphoneLevel: level.clamp(0.0, 1.0));
    } else {
      state = state.copyWith(microphoneLevel: 0.0);
    }
  }

  Future<void> startCapture() async {
    if (_audioSession == null) {
      await _initAudio();
    }
    state = state.copyWith(status: AudioSourceStatus.recording);
  }

  void stopCapture() {
    state = state.copyWith(status: AudioSourceStatus.stopped, microphoneLevel: 0.0);
  }

  @override
  void dispose() {
    _audioSession?.dispose();
    super.dispose();
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier();
});

// Audio mixer state for multiple audio sources
class AudioMixerState {
  final List<AudioSource> sources;
  final double masterVolume;
  final bool isMuted;

  const AudioMixerState({
    this.sources = const [],
    this.masterVolume = 1.0,
    this.isMuted = false,
  });

  AudioMixerState copyWith({
    List<AudioSource>? sources,
    double? masterVolume,
    bool? isMuted,
  }) {
    return AudioMixerState(
      sources: sources ?? this.sources,
      masterVolume: masterVolume ?? this.masterVolume,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

class AudioSource {
  final String id;
  final String name;
  final AudioSourceType type;
  final double volume;
  final bool isMuted;
  final bool isActive;

  const AudioSource({
    required this.id,
    required this.name,
    required this.type,
    this.volume = 1.0,
    this.isMuted = false,
    this.isActive = true,
  });

  AudioSource copyWith({
    String? id,
    String? name,
    AudioSourceType? type,
    double? volume,
    bool? isMuted,
    bool? isActive,
  }) {
    return AudioSource(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum AudioSourceType {
  microphone,
  systemAudio,
  media,
}

class AudioMixerNotifier extends StateNotifier<AudioMixerState> {
  AudioMixerNotifier() : super(const AudioMixerState()) {
    _initDefaultSources();
  }

  void _initDefaultSources() {
    state = state.copyWith(
      sources: [
        const AudioSource(
          id: 'mic',
          name: 'Microfone',
          type: AudioSourceType.microphone,
          isActive: true,
        ),
      ],
    );
  }

  void addSource(AudioSource source) {
    state = state.copyWith(sources: [...state.sources, source]);
  }

  void removeSource(String id) {
    state = state.copyWith(
      sources: state.sources.where((s) => s.id != id).toList(),
    );
  }

  void setSourceVolume(String id, double volume) {
    state = state.copyWith(
      sources: state.sources.map((s) {
        if (s.id == id) {
          return s.copyWith(volume: volume.clamp(0.0, 1.0));
        }
        return s;
      }).toList(),
    );
  }

  void toggleSourceMute(String id) {
    state = state.copyWith(
      sources: state.sources.map((s) {
        if (s.id == id) {
          return s.copyWith(isMuted: !s.isMuted);
        }
        return s;
      }).toList(),
    );
  }

  void setMasterVolume(double volume) {
    state = state.copyWith(masterVolume: volume.clamp(0.0, 1.0));
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }
}

final audioMixerProvider = StateNotifierProvider<AudioMixerNotifier, AudioMixerState>((ref) {
  return AudioMixerNotifier();
});
