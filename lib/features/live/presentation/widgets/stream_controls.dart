import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../stream/presentation/providers/stream_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/entities/stream_settings.dart';
import '../providers/camera_provider.dart';
import '../../../audio/presentation/widgets/audio_mixer_widget.dart';

class StreamControls extends ConsumerWidget {
  const StreamControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamState = ref.watch(streamProvider);
    final isLive = streamState.isLive;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick actions row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: Icons.cameraswitch,
                  label: 'Trocar',
                  onTap: () {
                    ref.read(cameraProvider.notifier).switchCamera();
                  },
                ),
                _buildControlButton(
                  icon: Icons.flash_on,
                  label: 'Flash',
                  onTap: () {
                    ref.read(cameraProvider.notifier).toggleFlash();
                  },
                ),
                _buildControlButton(
                  icon: Icons.mic_off,
                  label: 'Áudio',
                  onTap: () {
                    _showAudioMixer(context);
                  },
                ),
                _buildControlButton(
                  icon: Icons.settings,
                  label: 'Config',
                  onTap: () {
                    _showStreamSettings(context, ref);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Main action button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMainButton(
                  isLive: isLive,
                  status: streamState.status,
                  onTap: () => _handleMainAction(context, ref, streamState),
                ),
                if (isLive) ...[
                  const SizedBox(width: 16),
                  _buildSecondaryButton(
                    icon: streamState.status == StreamStatus.paused
                        ? Icons.play_arrow
                        : Icons.pause,
                    label: streamState.status == StreamStatus.paused
                        ? 'Retomar'
                        : 'Pausar',
                    onTap: () {
                      if (streamState.status == StreamStatus.paused) {
                        ref.read(streamProvider.notifier).resumeStream();
                      } else {
                        ref.read(streamProvider.notifier).pauseStream();
                      }
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required bool isLive,
    required StreamStatus status,
    required VoidCallback onTap,
  }) {
    final isConnecting = status == StreamStatus.connecting;

    return GestureDetector(
      onTap: isConnecting ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isLive ? AppTheme.errorColor : AppTheme.liveColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isLive ? AppTheme.errorColor : AppTheme.liveColor)
                  .withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: isConnecting
              ? const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Icon(
                  isLive ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.cardColor,
        foregroundColor: AppTheme.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  void _handleMainAction(BuildContext context, WidgetRef ref, StreamState state) {
    if (state.isLive) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Encerrar Live?'),
          content: const Text('Tem certeza que deseja encerrar a transmissão?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(streamProvider.notifier).stopStream();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
              child: const Text('Encerrar'),
            ),
          ],
        ),
      );
    } else {
      ref.read(streamProvider.notifier).startStream();
    }
  }

  void _showStreamSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Configurações de Stream', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.link, color: AppTheme.primaryColor),
                title: const Text('URL do Servidor RTMP'),
                subtitle: const Text('rtmp://live.twitch.tv/app', style: TextStyle(color: AppTheme.textSecondary)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.key, color: AppTheme.primaryColor),
                title: const Text('Chave de Stream'),
                subtitle: const Text('••••••••••••••••', style: TextStyle(color: AppTheme.textSecondary)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.aspect_ratio, color: AppTheme.primaryColor),
                title: const Text('Resolução'),
                subtitle: const Text('1280 x 720', style: TextStyle(color: AppTheme.textSecondary)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }

  void _showAudioMixer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AudioMixerWidget(),
    );
  }
}
