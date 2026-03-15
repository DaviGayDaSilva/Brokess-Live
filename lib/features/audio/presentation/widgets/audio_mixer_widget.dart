import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/audio_provider.dart';

class AudioMixerWidget extends ConsumerWidget {
  const AudioMixerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioMixer = ref.watch(audioMixerProvider);
    final audioState = ref.watch(audioProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mixer de Áudio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Master volume
          Row(
            children: [
              const Icon(Icons.volume_up, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Master',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(
                  audioMixer.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: audioMixer.isMuted ? AppTheme.errorColor : AppTheme.textPrimary,
                ),
                onPressed: () {
                  ref.read(audioMixerProvider.notifier).toggleMute();
                },
              ),
              SizedBox(
                width: 150,
                child: Slider(
                  value: audioMixer.masterVolume,
                  onChanged: (value) {
                    ref.read(audioMixerProvider.notifier).setMasterVolume(value);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Text(
                '${(audioMixer.masterVolume * 100).toInt()}%',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          
          const Divider(height: 24),
          
          // Audio sources
          ...audioMixer.sources.map((source) => _AudioSourceTile(
            source: source,
            onVolumeChanged: (volume) {
              ref.read(audioMixerProvider.notifier).setSourceVolume(source.id, volume);
            },
            onMuteToggle: () {
              ref.read(audioMixerProvider.notifier).toggleSourceMute(source.id);
            },
          )),
          
          const SizedBox(height: 16),
          
          // Microphone status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  audioState.isMuted ? Icons.mic_off : Icons.mic,
                  color: audioState.isMuted ? AppTheme.errorColor : AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        audioState.isMuted ? 'Microfone mutado' : 'Microfone ativo',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        audioState.status.name,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Audio level indicator
                Container(
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: audioState.isMuted ? 0 : audioState.microphoneLevel,
                    child: Container(
                      decoration: BoxDecoration(
                        color: audioState.isMuted 
                            ? AppTheme.errorColor 
                            : AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Mute button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(audioProvider.notifier).toggleMute();
              },
              icon: Icon(audioState.isMuted ? Icons.mic : Icons.mic_off),
              label: Text(audioState.isMuted ? 'Ativar Microfone' : 'Silenciar Microfone'),
              style: ElevatedButton.styleFrom(
                backgroundColor: audioState.isMuted 
                    ? AppTheme.errorColor 
                    : AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioSourceTile extends StatelessWidget {
  final AudioSource source;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onMuteToggle;

  const _AudioSourceTile({
    required this.source,
    required this.onVolumeChanged,
    required this.onMuteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            _getSourceIcon(source.type),
            color: source.isMuted ? AppTheme.textSecondary : AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              source.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: source.isMuted ? AppTheme.textSecondary : AppTheme.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              source.isMuted ? Icons.volume_off : Icons.volume_up,
              color: source.isMuted ? AppTheme.errorColor : AppTheme.textPrimary,
              size: 20,
            ),
            onPressed: onMuteToggle,
          ),
          SizedBox(
            width: 120,
            child: Slider(
              value: source.volume,
              onChanged: source.isMuted ? null : onVolumeChanged,
              activeColor: AppTheme.primaryColor,
            ),
          ),
          Text(
            '${(source.volume * 100).toInt()}%',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSourceIcon(AudioSourceType type) {
    switch (type) {
      case AudioSourceType.microphone:
        return Icons.mic;
      case AudioSourceType.systemAudio:
        return Icons.speaker;
      case AudioSourceType.media:
        return Icons.music_note;
    }
  }
}
