import 'package:hive/hive.dart';
import '../../domain/entities/journal_entry.dart';

part 'journal_entry_model.g.dart';

/// Data model for Journal Entry with Hive adapter
@HiveType(typeId: 1)
class JournalEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final bool isSynced;

  @HiveField(6)
  final bool isDeleted;

  JournalEntryModel({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    // Tombstone docs may only carry id/isDeleted/updatedAt.
    final updatedAt =
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return JournalEntryModel(
      id: json['id'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? updatedAt,
      content: json['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? updatedAt,
      updatedAt: updatedAt,
      isSynced: true,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  JournalEntryModel copyWith({
    String? id,
    DateTime? date,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// Convert domain entity to data model
  factory JournalEntryModel.fromEntity(JournalEntry entry) {
    return JournalEntryModel(
      id: entry.id,
      date: entry.date,
      content: entry.content,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      isSynced: entry.isSynced,
      isDeleted: entry.isDeleted,
    );
  }

  /// Convert data model to domain entity
  JournalEntry toEntity() {
    return JournalEntry(
      id: id,
      date: date,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }
}
