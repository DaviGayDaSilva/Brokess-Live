import 'package:flutter/material.dart';
import '../../../../core/entities/source.dart';
import '../../../../core/theme/app_theme.dart';

class ColorSourceWidget extends StatelessWidget {
  final Source source;
  final VoidCallback? onTap;

  const ColorSourceWidget({
    super.key,
    required this.source,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = source.settings['color'] as int? ?? 0xFF000000;
    final color = Color(colorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '#${colorValue.toRadixString(16).substring(2).toUpperCase()}',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorSourceEditor extends StatefulWidget {
  final Source source;
  final ValueChanged<Source> onSave;

  const ColorSourceEditor({
    super.key,
    required this.source,
    required this.onSave,
  });

  @override
  State<ColorSourceEditor> createState() => _ColorSourceEditorState();
}

class _ColorSourceEditorState extends State<ColorSourceEditor> {
  late Color _selectedColor;

  final List<Color> _presetColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    final colorValue = widget.source.settings['color'] as int? ?? 0xFF000000;
    _selectedColor = Color(colorValue);
  }

  @override
  Widget build(BuildContext context) {
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
            'Selecionar Cor',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Current color preview
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.textSecondary),
            ),
            child: Center(
              child: Text(
                '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                style: TextStyle(
                  color: _selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Preset colors
          const Text(
            'Cores Predefinidas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetColors.map((color) {
              final isSelected = color.toARGB32() == _selectedColor.toARGB32();
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Custom color picker hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Toque em uma cor para selecionar',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final updatedSource = widget.source.copyWith(
      settings: {
        ...widget.source.settings,
        'color': _selectedColor.toARGB32(),
      },
    );
    widget.onSave(updatedSource);
    Navigator.pop(context);
  }
}

extension on Color {
  int toARGB32() {
    return (a.toInt() << 24) | (r.toInt() << 16) | (g.toInt() << 8) | b.toInt();
  }
}
