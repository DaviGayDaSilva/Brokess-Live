import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/theme/app_theme.dart';

enum OverlayType { web, camera, text, image, widget }

class StreamOverlay extends ConsumerStatefulWidget {
  final String id;
  final OverlayType type;
  final String? url;
  final String? text;
  final String? imagePath;
  final double x;
  final double y;
  final double width;
  final double height;
  final double opacity;
  final bool visible;

  const StreamOverlay({
    super.key,
    required this.id,
    required this.type,
    this.url,
    this.text,
    this.imagePath,
    this.x = 0,
    this.y = 0,
    this.width = 200,
    this.height = 200,
    this.opacity = 1.0,
    this.visible = true,
  });

  @override
  ConsumerState<StreamOverlay> createState() => _StreamOverlayState();
}

class _StreamOverlayState extends ConsumerState<StreamOverlay> {
  late double _x;
  late double _y;
  late double _width;
  late double _height;
  bool _isDragging = false;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _x = widget.x;
    _y = widget.y;
    _width = widget.width;
    _height = widget.height;
  }

  @override
  void didUpdateWidget(StreamOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.x != widget.x || oldWidget.y != widget.y) {
      _x = widget.x;
      _y = widget.y;
    }
    if (oldWidget.width != widget.width || oldWidget.height != widget.height) {
      _width = widget.width;
      _height = widget.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            _x += details.delta.dx;
            _y += details.delta.dy;
          });
        },
        onPanEnd: (_) => setState(() => _isDragging = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.opacity,
          child: Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              border: _isDragging
                  ? Border.all(color: AppTheme.primaryColor, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Overlay content
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _buildOverlayContent(),
                ),
                // Resize handle
                if (_isDragging)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (_) => setState(() => _isResizing = true),
                      onPanUpdate: (details) {
                        setState(() {
                          _width = (_width + details.delta.dx).clamp(50.0, 500.0);
                          _height = (_height + details.delta.dy).clamp(50.0, 500.0);
                        });
                      },
                      onPanEnd: (_) => setState(() => _isResizing = false),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.open_in_full,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayContent() {
    switch (widget.type) {
      case OverlayType.web:
        return _buildWebOverlay();
      case OverlayType.camera:
        return _buildCameraOverlay();
      case OverlayType.text:
        return _buildTextOverlay();
      case OverlayType.image:
        return _buildImageOverlay();
      case OverlayType.widget:
        return _buildWidgetOverlay();
    }
  }

  Widget _buildWebOverlay() {
    if (widget.url == null || widget.url!.isEmpty) {
      return Container(
        color: AppTheme.surfaceColor,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.public, size: 40, color: AppTheme.textSecondary),
              SizedBox(height: 8),
              Text(
                'URL não configurada',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url!)),
    );
  }

  Widget _buildCameraOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam, size: 40, color: AppTheme.textSecondary),
            SizedBox(height: 8),
            Text(
              'Câmera',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextOverlay() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        widget.text ?? 'Texto',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 40, color: AppTheme.textSecondary),
            SizedBox(height: 8),
            Text(
              'Imagem',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.widgets, size: 40, color: AppTheme.textSecondary),
            SizedBox(height: 8),
            Text(
              'Widget',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// Overlay Manager for managing multiple overlays
class OverlayManager extends StatefulWidget {
  final List<StreamOverlay> overlays;
  final Widget child;

  const OverlayManager({
    super.key,
    required this.overlays,
    required this.child,
  });

  @override
  State<OverlayManager> createState() => _OverlayManagerState();
}

class _OverlayManagerState extends State<OverlayManager> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ...widget.overlays.map((overlay) => overlay),
      ],
    );
  }
}
