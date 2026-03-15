import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/entities/stream_settings.dart';
import '../providers/stream_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamState = ref.watch(streamProvider);
    final settings = ref.watch(streamSettingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Estatísticas'), backgroundColor: AppTheme.surfaceColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(streamState),
            const SizedBox(height: 16),
            const Text('Sessão Atual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStatsCard(streamState),
            const SizedBox(height: 16),
            const Text('Configurações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildSettingsCard(settings),
            const SizedBox(height: 16),
            const Text('Saúde do Stream', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildHealthCard(streamState),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(StreamState state) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: _getStatusColor(state.status).withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(_getStatusIcon(state.status), size: 40, color: _getStatusColor(state.status)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getStatusText(state.status), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getStatusColor(state.status))),
                  if (state.isLive) Text(_formatDuration(state.duration), style: const TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(StreamState state) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow(Icons.timer, 'Duração', _formatDuration(state.duration), AppTheme.primaryColor),
            const Divider(height: 24),
            _buildStatRow(Icons.speed, 'Taxa de Bits', '${state.bitrate.toInt()} kbps', AppTheme.successColor),
            const Divider(height: 24),
            _buildStatRow(Icons.warning_amber, 'Frames Perdidos', '${state.droppedFrames}', state.droppedFrames > 0 ? AppTheme.warningColor : AppTheme.successColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(StreamSettings settings) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSettingRow(Icons.aspect_ratio, 'Resolução', '${settings.videoWidth} x ${settings.videoHeight}'),
            const Divider(height: 24),
            _buildSettingRow(Icons.videocam, 'FPS', '${settings.frameRate}'),
            const Divider(height: 24),
            _buildSettingRow(Icons.speed, 'Bitrate Vídeo', '${settings.videoBitrate} kbps'),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(StreamState state) {
    final health = _calculateHealth(state);
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(health.icon, size: 40, color: health.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(health.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: health.color)),
                      Text(health.description, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: health.value, backgroundColor: AppTheme.surfaceColor, valueColor: AlwaysStoppedAnimation<Color>(health.color)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: AppTheme.textSecondary))),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildSettingRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: AppTheme.textSecondary))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getStatusColor(StreamStatus status) {
    if (status == StreamStatus.idle) return AppTheme.textSecondary;
    if (status == StreamStatus.connecting) return AppTheme.warningColor;
    if (status == StreamStatus.live) return AppTheme.liveColor;
    if (status == StreamStatus.paused) return AppTheme.warningColor;
    if (status == StreamStatus.reconnecting) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  IconData _getStatusIcon(StreamStatus status) {
    if (status == StreamStatus.idle) return Icons.stop;
    if (status == StreamStatus.connecting) return Icons.sync;
    if (status == StreamStatus.live) return Icons.live_tv;
    if (status == StreamStatus.paused) return Icons.pause;
    if (status == StreamStatus.reconnecting) return Icons.sync;
    return Icons.error;
  }

  String _getStatusText(StreamStatus status) {
    if (status == StreamStatus.idle) return 'Pronto';
    if (status == StreamStatus.connecting) return 'Conectando...';
    if (status == StreamStatus.live) return 'Ao Vivo';
    if (status == StreamStatus.paused) return 'Pausado';
    if (status == StreamStatus.reconnecting) return 'Reconectando...';
    return 'Erro';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  _HealthInfo _calculateHealth(StreamState state) {
    if (!state.isLive) {
      return _HealthInfo(title: 'Aguardando', description: 'Inicie a transmissão', value: 0, icon: Icons.hourglass_empty, color: AppTheme.textSecondary);
    }
    if (state.droppedFrames > 50) {
      return _HealthInfo(title: 'Pobre', description: 'Muitos frames perdidos', value: 0.3, icon: Icons.warning, color: AppTheme.errorColor);
    }
    if (state.droppedFrames > 20) {
      return _HealthInfo(title: 'Regular', description: 'Alguns frames perdidos', value: 0.6, icon: Icons.warning_amber, color: AppTheme.warningColor);
    }
    return _HealthInfo(title: 'Excelente', description: 'Stream com qualidade perfeita', value: 1.0, icon: Icons.check_circle, color: AppTheme.successColor);
  }
}

class _HealthInfo {
  final String title;
  final String description;
  final double value;
  final IconData icon;
  final Color color;

  _HealthInfo({required this.title, required this.description, required this.value, required this.icon, required this.color});
}
