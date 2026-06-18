import 'package:equatable/equatable.dart';

/// Domain entity representing a Note
class Note extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final String? localImagePath;
  final String? remoteImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const Note({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    this.localImagePath,
    this.remoteImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  Note copyWith({
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
    return Note(
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imagePath,
    localImagePath,
    remoteImageUrl,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  ];
}
