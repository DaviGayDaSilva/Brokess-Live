import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CameraType { front, back, external }

class CameraState {
  final bool isInitialized;
  final CameraController? controller;
  final CameraType cameraType;
  final String? errorMessage;
  final List<CameraDescription> availableCameras;

  const CameraState({
    this.isInitialized = false,
    this.controller,
    this.cameraType = CameraType.back,
    this.errorMessage,
    this.availableCameras = const [],
  });

  CameraState copyWith({
    bool? isInitialized,
    CameraController? controller,
    CameraType? cameraType,
    String? errorMessage,
    List<CameraDescription>? availableCameras,
  }) {
    return CameraState(
      isInitialized: isInitialized ?? this.isInitialized,
      controller: controller ?? this.controller,
      cameraType: cameraType ?? this.cameraType,
      errorMessage: errorMessage,
      availableCameras: availableCameras ?? this.availableCameras,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(const CameraState());

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(
          errorMessage: 'Nenhuma câmera disponível',
          isInitialized: false,
        );
        return;
      }

      // Find back camera first
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await controller.initialize();

      state = state.copyWith(
        isInitialized: true,
        controller: controller,
        availableCameras: cameras,
        cameraType: CameraType.back,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao inicializar câmera: $e',
        isInitialized: false,
      );
    }
  }

  Future<void> switchCamera() async {
    if (state.availableCameras.length < 2) return;

    final newDirection = state.cameraType == CameraType.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    final newCamera = state.availableCameras.firstWhere(
      (camera) => camera.lensDirection == newDirection,
      orElse: () => state.availableCameras.first,
    );

    await state.controller?.dispose();

    final controller = CameraController(
      newCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await controller.initialize();

    state = state.copyWith(
      controller: controller,
      cameraType: newDirection == CameraLensDirection.front
          ? CameraType.front
          : CameraType.back,
    );
  }

  Future<void> setResolution(ResolutionPreset resolution) async {
    if (state.controller == null) return;

    await state.controller?.dispose();

    final camera = state.cameraType == CameraType.back
        ? state.availableCameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => state.availableCameras.first,
          )
        : state.availableCameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => state.availableCameras.first,
          );

    final controller = CameraController(
      camera,
      resolution,
      enableAudio: true,
    );

    await controller.initialize();

    state = state.copyWith(controller: controller);
  }

  Future<void> toggleFlash() async {
    if (state.controller == null) return;
    try {
      final isOn = state.controller!.value.flashMode == FlashMode.torch;
      await state.controller!.setFlashMode(
        isOn ? FlashMode.off : FlashMode.torch,
      );
    } catch (e) {
      // Flash not supported
    }
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});

final cameraControllerProvider = Provider<CameraController?>((ref) {
  final cameraState = ref.watch(cameraProvider);
  return cameraState.controller;
});

final isCameraInitializedProvider = Provider<bool>((ref) {
  final cameraState = ref.watch(cameraProvider);
  return cameraState.isInitialized;
});
