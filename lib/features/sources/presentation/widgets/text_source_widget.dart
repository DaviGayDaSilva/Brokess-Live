import 'package:flutter/material.dart';
import '../../../../core/entities/source.dart';
import '../../../../core/theme/app_theme.dart';

class TextSourceWidget extends StatelessWidget {
  final Source source;
  final VoidCallback? onTap;

  const TextSourceWidget({
    super.key,
    required this.source,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = source.settings['text'] as String? ?? source.name;
    final fontSize = (source.settings['fontSize'] as num?)?.toDouble() ?? 24.0;
    final fontColor = Color(source.settings['fontColor'] as int? ?? 0xFFFFFFFF);
    final backgroundColor = Color(source.settings['backgroundColor'] as int? ?? 0x00000000);
    final isBold = source.settings['bold'] as bool? ?? false;
    final isItalic = source.settings['italic'] as bool? ?? false;
    final alignment = source.settings['alignment'] as String? ?? 'center';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: backgroundColor != Colors.transparent ? backgroundColor : null,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: fontColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
            textAlign: _getTextAlign(alignment),
          ),
        ),
      ),
    );
  }

  TextAlign _getTextAlign(String alignment) {
    switch (alignment) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }
}

class TextSourceEditor extends StatefulWidget {
  final Source source;
  final ValueChanged<Source> onSave;

  const TextSourceEditor({
    super.key,
    required this.source,
    required this.onSave,
  });

  @override
  State<TextSourceEditor> createState() => _TextSourceEditorState();
}

class _TextSourceEditorState extends State<TextSourceEditor> {
  late TextEditingController _textController;
  late double _fontSize;
  late Color _fontColor;
  late Color _backgroundColor;
  late bool _isBold;
  late bool _isItalic;
  late String _alignment;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.source.settings['text'] as String? ?? widget.source.name,
    );
    _fontSize = (widget.source.settings['fontSize'] as num?)?.toDouble() ?? 24.0;
    _fontColor = Color(widget.source.settings['fontColor'] as int? ?? 0xFFFFFFFF);
    _backgroundColor = Color(widget.source.settings['backgroundColor'] as int? ?? 0x00000000);
    _isBold = widget.source.settings['bold'] as bool? ?? false;
    _isItalic = widget.source.settings['italic'] as bool? ?? false;
    _alignment = widget.source.settings['alignment'] as String? ?? 'center';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Editar Texto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Text input
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Texto',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Font size
            Row(
              children: [
                const Text('Tamanho: '),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 8,
                    max: 72,
                    divisions: 64,
                    label: _fontSize.toInt().toString(),
                    onChanged: (value) => setState(() => _fontSize = value),
                  ),
                ),
                Text('${_fontSize.toInt()}px'),
              ],
            ),
            const SizedBox(height: 16),
            
            // Font color
            Row(
              children: [
                const Text('Cor do texto: '),
                const SizedBox(width: 8),
                _buildColorOption(_fontColor, (color) {
                  setState(() => _fontColor = color);
                }),
              ],
            ),
            const SizedBox(height: 16),
            
            // Background color
            Row(
              children: [
                const Text('Fundo: '),
                const SizedBox(width: 8),
                _buildColorOption(_backgroundColor, (color) {
                  setState(() => _backgroundColor = color);
                }),
              ],
            ),
            const SizedBox(height: 16),
            
            // Style options
            Row(
              children: [
                const Text('Estilo: '),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Negrito'),
                  selected: _isBold,
                  onSelected: (value) => setState(() => _isBold = value),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Itálico'),
                  selected: _isItalic,
                  onSelected: (value) => setState(() => _isItalic = value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Alignment
            Row(
              children: [
                const Text('Alinhamento: '),
                const SizedBox(width: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'left', icon: Icon(Icons.format_align_left)),
                    ButtonSegment(value: 'center', icon: Icon(Icons.format_align_center)),
                    ButtonSegment(value: 'right', icon: Icon(Icons.format_align_right)),
                  ],
                  selected: {_alignment},
                  onSelectionChanged: (value) => setState(() => _alignment = value.first),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Preview
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: _backgroundColor != Colors.transparent ? _backgroundColor : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.textSecondary),
              ),
              child: Center(
                child: Text(
                  _textController.text.isEmpty ? 'Preview' : _textController.text,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: _fontColor,
                    fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                    fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  ),
                  textAlign: _getTextAlign(_alignment),
                ),
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
      ),
    );
  }

  Widget _buildColorOption(Color currentColor, ValueChanged<Color> onColorSelected) {
    const colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.transparent,
    ];

    return Wrap(
      spacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              border: currentColor == color
                  ? Border.all(color: AppTheme.primaryColor, width: 3)
                  : Border.all(color: AppTheme.textSecondary),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }

  TextAlign _getTextAlign(String alignment) {
    switch (alignment) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }

  void _save() {
    final updatedSource = widget.source.copyWith(
      settings: {
        ...widget.source.settings,
        'text': _textController.text,
        'fontSize': _fontSize,
        'fontColor': _fontColor.toARGB32(),
        'backgroundColor': _backgroundColor.toARGB32(),
        'bold': _isBold,
        'italic': _isItalic,
        'alignment': _alignment,
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
