import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/entities/source.dart';
import '../../../../core/theme/app_theme.dart';

class ImageSourceWidget extends StatelessWidget {
  final Source source;
  final VoidCallback? onTap;

  const ImageSourceWidget({
    super.key,
    required this.source,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = source.settings['path'] as String?;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: imagePath != null && imagePath.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.surfaceColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              source.name,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toque para selecionar',
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
}
