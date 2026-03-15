import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../stream/presentation/providers/stream_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/entities/stream_settings.dart';
import '../providers/camera_provider.dart';
import '../widgets/stream_controls.dart';
import '../widgets/preview_area.dart';

class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({super.key});

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    await ref.read(cameraProvider.notifier).initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = ref.read(cameraControllerProvider);
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamState = ref.watch(streamProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Brokess Live'),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(streamState.status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (streamState.isLive || streamState.status == StreamStatus.connecting)
                  SizedBox(
                    width: 8,
                    height: 8,
                    child: streamState.status == StreamStatus.connecting
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                const SizedBox(width: 6),
                Text(
                  _getStatusText(streamState.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (streamState.isRecording)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppTheme.recordingColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'REC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: PreviewArea()),
          if (streamState.isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.surfaceColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoChip(Icons.timer, _formatDuration(streamState.duration)),
                  _buildInfoChip(Icons.speed, '${streamState.bitrate.toInt()} kbps'),
                  _buildInfoChip(Icons.warning_amber, '${streamState.droppedFrames} frames'),
                ],
              ),
            ),
          const StreamControls(),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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

  String _getStatusText(StreamStatus status) {
    if (status == StreamStatus.idle) return 'Pronto';
    if (status == StreamStatus.connecting) return 'Conectando';
    if (status == StreamStatus.live) return 'AO VIVO';
    if (status == StreamStatus.paused) return 'Pausado';
    if (status == StreamStatus.reconnecting) return 'Reconectando';
    return 'Erro';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
