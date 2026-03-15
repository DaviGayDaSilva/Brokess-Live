import 'package:equatable/equatable.dart';

enum StreamStatus {
  idle,
  connecting,
  live,
  paused,
  reconnecting,
  error,
}

class StreamSettings extends Equatable {
  final String rtmpUrl;
  final String streamKey;
  final int videoWidth;
  final int videoHeight;
  final int frameRate;
  final int videoBitrate;
  final int audioBitrate;
  final int audioSampleRate;
  final String videoEncoder;
  final String audioEncoder;
  final bool recordLocal;
  final String recordPath;
  final bool lowLatency;

  const StreamSettings({
    this.rtmpUrl = '',
    this.streamKey = '',
    this.videoWidth = 1280,
    this.videoHeight = 720,
    this.frameRate = 30,
    this.videoBitrate = 4500,
    this.audioBitrate = 128,
    this.audioSampleRate = 44100,
    this.videoEncoder = 'h264',
    this.audioEncoder = 'aac',
    this.recordLocal = false,
    this.recordPath = '',
    this.lowLatency = true,
  });

  StreamSettings copyWith({
    String? rtmpUrl,
    String? streamKey,
    int? videoWidth,
    int? videoHeight,
    int? frameRate,
    int? videoBitrate,
    int? audioBitrate,
    int? audioSampleRate,
    String? videoEncoder,
    String? audioEncoder,
    bool? recordLocal,
    String? recordPath,
    bool? lowLatency,
  }) {
    return StreamSettings(
      rtmpUrl: rtmpUrl ?? this.rtmpUrl,
      streamKey: streamKey ?? this.streamKey,
      videoWidth: videoWidth ?? this.videoWidth,
      videoHeight: videoHeight ?? this.videoHeight,
      frameRate: frameRate ?? this.frameRate,
      videoBitrate: videoBitrate ?? this.videoBitrate,
      audioBitrate: audioBitrate ?? this.audioBitrate,
      audioSampleRate: audioSampleRate ?? this.audioSampleRate,
      videoEncoder: videoEncoder ?? this.videoEncoder,
      audioEncoder: audioEncoder ?? this.audioEncoder,
      recordLocal: recordLocal ?? this.recordLocal,
      recordPath: recordPath ?? this.recordPath,
      lowLatency: lowLatency ?? this.lowLatency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rtmpUrl': rtmpUrl,
      'streamKey': streamKey,
      'videoWidth': videoWidth,
      'videoHeight': videoHeight,
      'frameRate': frameRate,
      'videoBitrate': videoBitrate,
      'audioBitrate': audioBitrate,
      'audioSampleRate': audioSampleRate,
      'videoEncoder': videoEncoder,
      'audioEncoder': audioEncoder,
      'recordLocal': recordLocal,
      'recordPath': recordPath,
      'lowLatency': lowLatency,
    };
  }

  factory StreamSettings.fromJson(Map<String, dynamic> json) {
    return StreamSettings(
      rtmpUrl: json['rtmpUrl'] as String? ?? '',
      streamKey: json['streamKey'] as String? ?? '',
      videoWidth: json['videoWidth'] as int? ?? 1280,
      videoHeight: json['videoHeight'] as int? ?? 720,
      frameRate: json['frameRate'] as int? ?? 30,
      videoBitrate: json['videoBitrate'] as int? ?? 4500,
      audioBitrate: json['audioBitrate'] as int? ?? 128,
      audioSampleRate: json['audioSampleRate'] as int? ?? 44100,
      videoEncoder: json['videoEncoder'] as String? ?? 'h264',
      audioEncoder: json['audioEncoder'] as String? ?? 'aac',
      recordLocal: json['recordLocal'] as bool? ?? false,
      recordPath: json['recordPath'] as String? ?? '',
      lowLatency: json['lowLatency'] as bool? ?? true,
    );
  }

  String get fullStreamUrl => '$rtmpUrl/$streamKey';

  @override
  List<Object?> get props => [
        rtmpUrl,
        streamKey,
        videoWidth,
        videoHeight,
        frameRate,
        videoBitrate,
        audioBitrate,
        audioSampleRate,
        videoEncoder,
        audioEncoder,
        recordLocal,
        recordPath,
        lowLatency,
      ];
}

class StreamState extends Equatable {
  final StreamStatus status;
  final Duration duration;
  final int droppedFrames;
  final double bitrate;
  final String? errorMessage;
  final bool isRecording;

  const StreamState({
    this.status = StreamStatus.idle,
    this.duration = Duration.zero,
    this.droppedFrames = 0,
    this.bitrate = 0,
    this.errorMessage,
    this.isRecording = false,
  });

  StreamState copyWith({
    StreamStatus? status,
    Duration? duration,
    int? droppedFrames,
    double? bitrate,
    String? errorMessage,
    bool? isRecording,
  }) {
    return StreamState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
      droppedFrames: droppedFrames ?? this.droppedFrames,
      bitrate: bitrate ?? this.bitrate,
      errorMessage: errorMessage,
      isRecording: isRecording ?? this.isRecording,
    );
  }

  bool get isLive => status == StreamStatus.live;
  bool get isConnected =>
      status == StreamStatus.live || status == StreamStatus.paused;

  @override
  List<Object?> get props => [
        status,
        duration,
        droppedFrames,
        bitrate,
        errorMessage,
        isRecording,
      ];
}
