import 'package:equatable/equatable.dart';

/// Domain entity representing a Journal Entry
class JournalEntry extends Equatable {
  final String id;
  final DateTime date;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  
  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [id, date, content, createdAt, updatedAt];
}
