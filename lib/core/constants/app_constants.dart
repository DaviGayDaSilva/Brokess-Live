// App constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Brokess Live';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'OBS no seu celular';

  // Stream Settings Defaults
  static const int defaultVideoWidth = 1280;
  static const int defaultVideoHeight = 720;
  static const int defaultFrameRate = 30;
  static const int defaultBitrate = 4500; // kbps
  static const int defaultAudioBitrate = 128; // kbps

  // Video Presets
  static const Map<String, Map<String, dynamic>> videoPresets = {
    '480p': {'width': 854, 'height': 480, 'bitrate': 2500},
    '720p': {'width': 1280, 'height': 720, 'bitrate': 4500},
    '1080p': {'width': 1920, 'height': 1080, 'bitrate': 8000},
  };

  // Frame Rate Options
  static const List<int> frameRateOptions = [24, 30, 60];

  // Bitrate Options (kbps)
  static const List<int> bitrateOptions = [1500, 2500, 4500, 6000, 8000, 10000];

  // Audio Sample Rates
  static const List<int> audioSampleRates = [44100, 48000];

  // Max sources per scene
  static const int maxSourcesPerScene = 20;

  // Max scenes
  static const int maxScenes = 10;

  // Overlay defaults
  static const double defaultOverlayOpacity = 1.0;
  static const double minOverlayOpacity = 0.0;
  static const double maxOverlayOpacity = 1.0;

  // Storage Keys
  static const String scenesBoxKey = 'scenes_box';
  static const String sourcesBoxKey = 'sources_box';
  static const String settingsBoxKey = 'settings_box';
  static const String streamProfilesBoxKey = 'stream_profiles_box';
}
