import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/entities/source.dart';
import '../../../../core/entities/stream_settings.dart';
import '../../domain/entities/scene.dart';

const _uuid = Uuid();

class ScenesNotifier extends StateNotifier<List<Scene>> {
  final Box _box;

  ScenesNotifier(this._box) : super([]) {
    _loadScenes();
  }

  void _loadScenes() {
    final scenesJson = _box.get('scenes', defaultValue: <Map>[]);
    final scenes = scenesJson
        .map<Scene>((s) => Scene.fromJson(Map<String, dynamic>.from(s as Map)))
        .toList();
    
    if (scenes.isEmpty) {
      final defaultScene = Scene(
        id: _uuid.v4(),
        name: 'Main Scene',
        order: 0,
        isActive: true,
      );
      state = [defaultScene];
      _saveScenes();
    } else {
      state = scenes;
    }
  }

  void _saveScenes() {
    _box.put('scenes', state.map((s) => s.toJson()).toList());
  }

  void addScene(String name) {
    final scene = Scene(
      id: _uuid.v4(),
      name: name,
      order: state.length,
    );
    state = [...state, scene];
    _saveScenes();
  }

  void removeScene(String id) {
    state = state.where((s) => s.id != id).toList();
    _saveScenes();
  }

  void updateScene(Scene scene) {
    state = state.map((s) => s.id == scene.id ? scene : s).toList();
    _saveScenes();
  }

  void setActiveScene(String id) {
    state = state.map((s) => s.copyWith(isActive: s.id == id)).toList();
    _saveScenes();
  }

  void reorderScenes(int oldIndex, int newIndex) {
    final scenes = [...state];
    final item = scenes.removeAt(oldIndex);
    scenes.insert(newIndex, item);
    state = scenes.asMap().entries.map((e) => e.value.copyWith(order: e.key)).toList();
    _saveScenes();
  }

  void addSource(String sceneId, Source source) {
    state = state.map((scene) {
      if (scene.id == sceneId) {
        final newSource = source.copyWith(zIndex: scene.sources.length);
        return scene.copyWith(sources: [...scene.sources, newSource]);
      }
      return scene;
    }).toList();
    _saveScenes();
  }

  void removeSource(String sceneId, String sourceId) {
    state = state.map((scene) {
      if (scene.id == sceneId) {
        return scene.copyWith(
          sources: scene.sources.where((s) => s.id != sourceId).toList(),
        );
      }
      return scene;
    }).toList();
    _saveScenes();
  }

  void updateSource(String sceneId, Source source) {
    state = state.map((scene) {
      if (scene.id == sceneId) {
        return scene.copyWith(
          sources: scene.sources.map((s) => s.id == source.id ? source : s).toList(),
        );
      }
      return scene;
    }).toList();
    _saveScenes();
  }

  void reorderSources(String sceneId, int oldIndex, int newIndex) {
    state = state.map((scene) {
      if (scene.id == sceneId) {
        final sources = [...scene.sources];
        final item = sources.removeAt(oldIndex);
        sources.insert(newIndex, item);
        return scene.copyWith(
          sources: sources.asMap().entries.map((e) => e.value.copyWith(zIndex: e.key)).toList(),
        );
      }
      return scene;
    }).toList();
    _saveScenes();
  }

  Scene? get activeScene {
    try {
      return state.firstWhere((s) => s.isActive);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }
}

final scenesProvider = StateNotifierProvider<ScenesNotifier, List<Scene>>((ref) {
  final box = Hive.box('scenes_box');
  return ScenesNotifier(box);
});

final activeSceneProvider = Provider<Scene?>((ref) {
  final scenes = ref.watch(scenesProvider);
  try {
    return scenes.firstWhere((s) => s.isActive);
  } catch (_) {
    return scenes.isNotEmpty ? scenes.first : null;
  }
});
