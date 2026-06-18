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

  @HiveField(6)
  final bool isSynced;

  @HiveField(7)
  final bool isDeleted;

  @HiveField(8)
  final String? localImagePath;

  @HiveField(9)
  final String? remoteImageUrl;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
    String? localImagePath,
    this.remoteImageUrl,
  }) : localImagePath = localImagePath ?? imagePath;

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imagePath: json['localImagePath'] as String?,
      localImagePath: json['localImagePath'] as String?,
      remoteImageUrl: json['remoteImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isSynced: true,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'localImagePath': localImagePath,
      'remoteImageUrl': remoteImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    String? localImagePath,
    String? remoteImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      localImagePath: localImagePath ?? this.localImagePath,
      remoteImageUrl: remoteImageUrl ?? this.remoteImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// Convert domain entity to data model
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      imagePath: note.localImagePath ?? note.imagePath,
      localImagePath: note.localImagePath ?? note.imagePath,
      remoteImageUrl: note.remoteImageUrl,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isSynced: note.isSynced,
      isDeleted: note.isDeleted,
    );
  }

  /// Convert data model to domain entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      description: description,
      imagePath: localImagePath ?? imagePath,
      localImagePath: localImagePath ?? imagePath,
      remoteImageUrl: remoteImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }
}
