// lib/models/note.dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Note {
  final String id;
  String title;
  bool isCompleted;

  Note({
    required this.title,
    this.isCompleted = false,
  }) : id = uuid.v4();

  // Konversi dari Map (untuk SharedPreferences)
  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        title = map['title'] as String,
        isCompleted = map['isCompleted'] as bool;

  // Konversi ke Map (untuk SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}