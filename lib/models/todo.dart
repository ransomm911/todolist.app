import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime deadline;
  final String userId;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.deadline,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'deadline': Timestamp.fromDate(deadline),
      'userId': userId,
    };
  }

  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title']?.toString() ?? '',
      isCompleted: map['isCompleted'] == true,
      deadline: (map['deadline'] is Timestamp)
          ? (map['deadline'] as Timestamp).toDate()
          : DateTime.now(),
      userId: map['userId']?.toString() ?? '',
    );
  }

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? deadline,
    String? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      deadline: deadline ?? this.deadline,
      userId: userId ?? this.userId,
    );
  }
} 