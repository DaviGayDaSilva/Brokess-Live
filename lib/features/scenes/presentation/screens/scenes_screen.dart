import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/entities/source.dart';
import '../../../../core/entities/stream_settings.dart';
import '../../domain/entities/scene.dart';
import '../providers/scenes_provider.dart';

class ScenesScreen extends ConsumerWidget {
  const ScenesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(scenesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Cenas'),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSceneDialog(context, ref),
          ),
        ],
      ),
      body: scenes.isEmpty
          ? _buildEmptyState(context, ref)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scenes.length,
              itemBuilder: (context, index) {
                final scene = scenes[index];
                return _SceneCard(scene: scene);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.layers_outlined,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma cena criada',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crie sua primeira cena para começar',
            style: TextStyle(color: AppTheme.textHint),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddSceneDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Criar Cena'),
          ),
        ],
      ),
    );
  }

  void _showAddSceneDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Cena'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome da Cena',
            hintText: 'Ex: Main Scene',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(scenesProvider.notifier).addScene(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }
}

class _SceneCard extends ConsumerWidget {
  final Scene scene;

  const _SceneCard({required this.scene});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: scene.isActive ? AppTheme.primaryColor.withValues(alpha: 0.2) : AppTheme.cardColor,
      child: InkWell(
        onTap: () {
          ref.read(scenesProvider.notifier).setActiveScene(scene.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.layers,
                    color: scene.isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      scene.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: scene.isActive ? AppTheme.primaryColor : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  if (scene.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ATIVA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(context, ref);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, ref);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                            SizedBox(width: 8),
                            Text('Excluir', style: TextStyle(color: AppTheme.errorColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Sources list
              if (scene.sources.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 20, color: AppTheme.textSecondary),
                      SizedBox(width: 8),
                      Text(
                        'Adicionar fonte',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: scene.sources.map((source) {
                    return _SourceChip(source: source, sceneId: scene.id);
                  }).toList(),
                ),
              const SizedBox(height: 12),
              // Add source button
              OutlinedButton.icon(
                onPressed: () => _showAddSourceDialog(context, ref, scene.id),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Adicionar Fonte'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  side: const BorderSide(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: scene.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Cena'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(scenesProvider.notifier).updateScene(
                      scene.copyWith(name: controller.text),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Cena?'),
        content: Text('Tem certeza que deseja excluir "${scene.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(scenesProvider.notifier).removeScene(scene.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showAddSourceDialog(BuildContext context, WidgetRef ref, String sceneId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adicionar Fonte',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSourceOption(
              context,
              ref,
              sceneId,
              Icons.videocam,
              'Câmera',
              'Capture vídeo da câmera',
              SourceType.camera,
            ),
            _buildSourceOption(
              context,
              ref,
              sceneId,
              Icons.image,
              'Imagem',
              'Adicione uma imagem',
              SourceType.image,
            ),
            _buildSourceOption(
              context,
              ref,
              sceneId,
              Icons.movie,
              'Vídeo',
              'Reproduza um vídeo',
              SourceType.video,
            ),
            _buildSourceOption(
              context,
              ref,
              sceneId,
              Icons.text_fields,
              'Texto',
              'Adicione texto personalizado',
              SourceType.text,
            ),
            _buildSourceOption(
              context,
              ref,
              sceneId,
              Icons.color_lens,
              'Cor',
              'Cor sólida',
              SourceType.color,
            ),
            _buildSourceOption(
              context,
              ref,
              sceneId,
              Icons.public,
              'Navegador',
              'Página web',
              SourceType.browser,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context,
    WidgetRef ref,
    String sceneId,
    IconData icon,
    String title,
    String subtitle,
    SourceType type,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
      onTap: () {
        final source = Source(
          id: const Uuid().v4(),
          name: title,
          type: type,
        );
        ref.read(scenesProvider.notifier).addSource(sceneId, source);
        Navigator.pop(context);
      },
    );
  }
}

class _SourceChip extends ConsumerWidget {
  final Source source;
  final String sceneId;

  const _SourceChip({required this.source, required this.sceneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: source.visible ? AppTheme.primaryColor : AppTheme.textSecondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSourceIcon(source.type),
            size: 16,
            color: source.visible ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            source.name,
            style: TextStyle(
              fontSize: 12,
              color: source.visible ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              ref.read(scenesProvider.notifier).updateSource(
                    sceneId,
                    source.copyWith(visible: !source.visible),
                  );
            },
            child: Icon(
              source.visible ? Icons.visibility : Icons.visibility_off,
              size: 14,
              color: source.visible ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSourceIcon(SourceType type) {
    switch (type) {
      case SourceType.camera:
        return Icons.videocam;
      case SourceType.image:
        return Icons.image;
      case SourceType.video:
        return Icons.movie;
      case SourceType.text:
        return Icons.text_fields;
      case SourceType.color:
        return Icons.color_lens;
      case SourceType.browser:
        return Icons.public;
    }
  }
}
