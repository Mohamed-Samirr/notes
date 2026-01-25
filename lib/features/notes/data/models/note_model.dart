import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';

part 'note_model.g.dart';

/// Data model for Note with Hive adapter
@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String? imagePath;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime updatedAt;
  
  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Convert domain entity to data model
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      imagePath: note.imagePath,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }
  
  /// Convert data model to domain entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      description: description,
      imagePath: imagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
