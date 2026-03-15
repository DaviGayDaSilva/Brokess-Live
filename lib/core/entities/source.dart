import 'package:equatable/equatable.dart';

enum SourceType {
  camera,
  image,
  video,
  text,
  color,
  browser,
  screenCapture,
}

class Source extends Equatable {
  final String id;
  final String name;
  final SourceType type;
  final Map<String, dynamic> settings;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final double opacity;
  final bool visible;
  final int zIndex;

  const Source({
    required this.id,
    required this.name,
    required this.type,
    this.settings = const {},
    this.x = 0,
    this.y = 0,
    this.width = 1920,
    this.height = 1080,
    this.rotation = 0,
    this.opacity = 1.0,
    this.visible = true,
    this.zIndex = 0,
  });

  Source copyWith({
    String? id,
    String? name,
    SourceType? type,
    Map<String, dynamic>? settings,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    double? opacity,
    bool? visible,
    int? zIndex,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      settings: settings ?? this.settings,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      visible: visible ?? this.visible,
      zIndex: zIndex ?? this.zIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'settings': settings,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'rotation': rotation,
      'opacity': opacity,
      'visible': visible,
      'zIndex': zIndex,
    };
  }

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String,
      name: json['name'] as String,
      type: SourceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SourceType.color,
      ),
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      width: (json['width'] as num?)?.toDouble() ?? 1920,
      height: (json['height'] as num?)?.toDouble() ?? 1080,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      visible: json['visible'] as bool? ?? true,
      zIndex: json['zIndex'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, type, settings, x, y, width, height, rotation, opacity, visible, zIndex];
}
