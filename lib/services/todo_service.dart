import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  // Get todos for current user
  Stream<List<Todo>> getTodos(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.exists && doc.data().isNotEmpty)
          .map((doc) {
            final data = doc.data();
            return Todo(
              id: doc.id,
              title: data['title']?.toString() ?? '',
              isCompleted: data['isCompleted'] == true,
              deadline: (data['deadline'] is Timestamp)
                  ? (data['deadline'] as Timestamp).toDate()
                  : DateTime.now(),
              userId: data['userId']?.toString() ?? '',
            );
          })
          .toList();
    });
  }

  // Add new todo
  Future<void> addTodo(Todo todo) async {
    try {
      await _firestore.collection(_collection).add(todo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Update todo
  Future<void> updateTodo(Todo todo) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(todo.id)
          .update(todo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await _firestore.collection(_collection).doc(todoId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Toggle todo completion status
  Future<void> toggleTodoStatus(Todo todo) async {
    try {
      await _firestore.collection(_collection).doc(todo.id).update({
        'isCompleted': !todo.isCompleted,
      });
    } catch (e) {
      rethrow;
    }
  }
} 