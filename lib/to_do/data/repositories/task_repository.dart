import '../data.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
  Future<void> clearDatabase();
  Future<List<Task>> getAllTasks();
}
