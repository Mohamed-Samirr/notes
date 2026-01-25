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
  
  JournalEntryModel({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Convert domain entity to data model
  factory JournalEntryModel.fromEntity(JournalEntry entry) {
    return JournalEntryModel(
      id: entry.id,
      date: entry.date,
      content: entry.content,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
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
    );
  }
}
