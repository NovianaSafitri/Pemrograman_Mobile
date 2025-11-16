// lib/model/activity_model.dart
class ActivityModel {
  String name;
  String category;
  double duration; // Durasi dalam jam
  bool isCompleted;
  String? notes; // Catatan tambahan bersifat opsional

  ActivityModel({
    required this.name,
    required this.category,
    required this.duration,
    this.isCompleted = false,
    this.notes,
  });
}