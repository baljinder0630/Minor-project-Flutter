import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/to_do/data/data.dart';
import 'package:uuid/uuid.dart';

final todoProvider =
    StateNotifierProvider<TODO, TodoState>(((ref) => TODO(ref: ref)));

class TODO extends StateNotifier<TodoState> {
  StateNotifierProviderRef ref;

  TODO({required this.ref}) : super(TodoState()) {}

  createTask({required Task task}) async {
    // create task
    try {
      final uuid = Uuid().v1();
      return await FirebaseFirestore.instance
          .collection('tasks')
          .doc(uuid)
          .set(
            task.toJson(),
          )
          .whenComplete(() => true)
          .onError((error, stackTrace) => false);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .where('id', isEqualTo: id)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          // log(element.reference.toString());
          element.reference.delete();
        });
      });

      print('Task deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  updateTask({
    required String id,
    required bool isCompleted,
  }) async {
    try {
      log('id: $id, isCompleted: $isCompleted');
      await FirebaseFirestore.instance
          .collection('tasks')
          .where('id', isEqualTo: id)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.update({'isCompleted': isCompleted ? 1 : 0});
        });
      });
    } catch (e) {
      print(e);
    }
  }

  getAllTask() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('assignedTo',
            isEqualTo: ref.read(authStateProvider).role == Role.careTaker
                ? ref.read(authStateProvider).currentPatient!.id
                : ref.read(authStateProvider).user.id)
        .snapshots();
  }
}

class TodoState {
  TodoState();

  TodoState copyWith() {
    return TodoState();
  }
}
