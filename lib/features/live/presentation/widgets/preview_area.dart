import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';
import '../../../../core/theme/app_theme.dart';

class PreviewArea extends ConsumerWidget {
  const PreviewArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final controller = cameraState.controller;

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
        child: cameraState.isInitialized && controller != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  // Camera Preview
                  CameraPreview(controller),
                  // Overlay - can add more layers here
                  const PreviewOverlay(),
                ],
              )
            : _buildPlaceholder(cameraState.errorMessage),
      ),
    );
  }

  Widget _buildPlaceholder(String? errorMessage) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorMessage != null ? Icons.error_outline : Icons.videocam_off,
              size: 64,
              color: errorMessage != null
                  ? AppTheme.errorColor
                  : AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Inicializando câmera...',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Tentar novamente'),
              ),
            ],
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
