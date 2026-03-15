import 'package:equatable/equatable.dart';
import '../../../../core/entities/source.dart';

class Scene extends Equatable {
  final String id;
  final String name;
  final List<Source> sources;
  final bool isActive;
  final int order;

  const Scene({
    required this.id,
    required this.name,
    this.sources = const [],
    this.isActive = false,
    this.order = 0,
  });

  Scene copyWith({
    String? id,
    String? name,
    List<Source>? sources,
    bool? isActive,
    int? order,
  }) {
    return Scene(
      id: id ?? this.id,
      name: name ?? this.name,
      sources: sources ?? this.sources,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sources': sources.map((s) => s.toJson()).toList(),
      'isActive': isActive,
      'order': order,
    };
  }

  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as String,
      name: json['name'] as String,
      sources: (json['sources'] as List<dynamic>?)
              ?.map<Source>((s) => Source.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, sources, isActive, order];
}
