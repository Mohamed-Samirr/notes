import 'package:equatable/equatable.dart';

/// Domain entity representing a Note
class Note extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Note({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Note copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [id, title, description, imagePath, createdAt, updatedAt];
}
