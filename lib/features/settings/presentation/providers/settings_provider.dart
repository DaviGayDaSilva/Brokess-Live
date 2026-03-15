import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppThemeMode { dark, light, system }

class AppSettings {
  final AppThemeMode themeMode;
  final String language;
  final bool showStatsOnStream;
  final bool enableGpuAcceleration;
  final bool enableHardwareEncoding;
  final bool autoReconnect;
  final int reconnectAttempts;
  final int reconnectDelay; // seconds
  final bool showViewerCount;
  final bool hapticFeedback;

  const AppSettings({
    this.themeMode = AppThemeMode.dark,
    this.language = 'en',
    this.showStatsOnStream = false,
    this.enableGpuAcceleration = true,
    this.enableHardwareEncoding = true,
    this.autoReconnect = true,
    this.reconnectAttempts = 5,
    this.reconnectDelay = 5,
    this.showViewerCount = true,
    this.hapticFeedback = true,
  });

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? language,
    bool? showStatsOnStream,
    bool? enableGpuAcceleration,
    bool? enableHardwareEncoding,
    bool? autoReconnect,
    int? reconnectAttempts,
    int? reconnectDelay,
    bool? showViewerCount,
    bool? hapticFeedback,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      showStatsOnStream: showStatsOnStream ?? this.showStatsOnStream,
      enableGpuAcceleration: enableGpuAcceleration ?? this.enableGpuAcceleration,
      enableHardwareEncoding: enableHardwareEncoding ?? this.enableHardwareEncoding,
      autoReconnect: autoReconnect ?? this.autoReconnect,
      reconnectAttempts: reconnectAttempts ?? this.reconnectAttempts,
      reconnectDelay: reconnectDelay ?? this.reconnectDelay,
      showViewerCount: showViewerCount ?? this.showViewerCount,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'language': language,
      'showStatsOnStream': showStatsOnStream,
      'enableGpuAcceleration': enableGpuAcceleration,
      'enableHardwareEncoding': enableHardwareEncoding,
      'autoReconnect': autoReconnect,
      'reconnectAttempts': reconnectAttempts,
      'reconnectDelay': reconnectDelay,
      'showViewerCount': showViewerCount,
      'hapticFeedback': hapticFeedback,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: AppThemeMode.values[json['themeMode'] as int? ?? 0],
      language: json['language'] as String? ?? 'en',
      showStatsOnStream: json['showStatsOnStream'] as bool? ?? false,
      enableGpuAcceleration: json['enableGpuAcceleration'] as bool? ?? true,
      enableHardwareEncoding: json['enableHardwareEncoding'] as bool? ?? true,
      autoReconnect: json['autoReconnect'] as bool? ?? true,
      reconnectAttempts: json['reconnectAttempts'] as int? ?? 5,
      reconnectDelay: json['reconnectDelay'] as int? ?? 5,
      showViewerCount: json['showViewerCount'] as bool? ?? true,
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final Box _box;

  SettingsNotifier(this._box) : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final settingsJson = _box.get('app_settings');
    if (settingsJson != null) {
      state = AppSettings.fromJson(Map<String, dynamic>.from(settingsJson));
    }
  }

  void _saveSettings() {
    _box.put('app_settings', state.toJson());
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveSettings();
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
    _saveSettings();
  }

  void setShowStatsOnStream(bool value) {
    state = state.copyWith(showStatsOnStream: value);
    _saveSettings();
  }

  void setEnableGpuAcceleration(bool value) {
    state = state.copyWith(enableGpuAcceleration: value);
    _saveSettings();
  }

  void setEnableHardwareEncoding(bool value) {
    state = state.copyWith(enableHardwareEncoding: value);
    _saveSettings();
  }

  void setAutoReconnect(bool value) {
    state = state.copyWith(autoReconnect: value);
    _saveSettings();
  }

  void setReconnectAttempts(int value) {
    state = state.copyWith(reconnectAttempts: value);
    _saveSettings();
  }

  void setReconnectDelay(int value) {
    state = state.copyWith(reconnectDelay: value);
    _saveSettings();
  }

  void setShowViewerCount(bool value) {
    state = state.copyWith(showViewerCount: value);
    _saveSettings();
  }

  void setHapticFeedback(bool value) {
    state = state.copyWith(hapticFeedback: value);
    _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final box = Hive.box('settings_box');
  return SettingsNotifier(box);
});
