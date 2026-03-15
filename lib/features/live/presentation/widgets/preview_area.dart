import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../scenes/presentation/providers/scenes_provider.dart';
import '../../../scenes/domain/entities/scene.dart';
import '../../../../core/entities/source.dart';
import '../../../screen_capture/presentation/widgets/screen_capture_widget.dart';
import '../../../sources/presentation/widgets/image_source_widget.dart';
import '../../../sources/presentation/widgets/text_source_widget.dart';
import '../../../sources/presentation/widgets/color_source_widget.dart';

class PreviewArea extends ConsumerWidget {
  const PreviewArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final controller = cameraState.controller;
    final activeScene = ref.watch(activeSceneProvider);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildScenePreview(activeScene, cameraState, controller),
      ),
    );
  }

  Widget _buildScenePreview(Scene? scene, CameraState cameraState, CameraController? controller) {
    if (scene == null || scene.sources.isEmpty) {
      return _buildEmptyPreview();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        for (final source in scene.sources.where((s) => s.visible))
          _buildSourceWidget(source, cameraState, controller),
        const PreviewOverlay(),
      ],
    );
  }

  Widget _buildSourceWidget(Source source, CameraState cameraState, CameraController? controller) {
    switch (source.type) {
      case SourceType.camera:
        if (cameraState.isInitialized && controller != null) {
          return CameraPreview(controller);
        }
        return _buildSourcePlaceholder(Icons.videocam, 'Câmera');
      
      case SourceType.screenCapture:
        return ScreenCaptureWidget(sourceId: source.id);
      
      case SourceType.color:
        return ColorSourceWidget(source: source);
      
      case SourceType.image:
        return ImageSourceWidget(source: source);
      
      case SourceType.video:
        // TODO: Implement video source
        return _buildSourcePlaceholder(Icons.movie, 'Vídeo');
      
      case SourceType.text:
        return TextSourceWidget(source: source);
      
      case SourceType.browser:
        // TODO: Implement browser source
        return _buildSourcePlaceholder(Icons.public, 'Navegador');
    }
  }

  Widget _buildEmptyPreview() {
    return Container(
      color: AppTheme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.layers_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma fonte na cena',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione fontes na aba Cenas',
              style: TextStyle(
                color: AppTheme.textHint,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourcePlaceholder(IconData icon, String label) {
    return Container(
      color: AppTheme.surfaceColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppTheme.textSecondary),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewOverlay extends StatelessWidget {
  const PreviewOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // This is where overlays will be rendered
    return const SizedBox.shrink();
  }
}
