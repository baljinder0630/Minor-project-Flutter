import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Provider/todoProvider.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../data/data.dart';

class DisplayListOfTasks extends ConsumerWidget {
  const DisplayListOfTasks({
    super.key,
    this.isCompletedTasks = false,
    required this.tasks,
  });
  final bool isCompletedTasks;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final height =
        isCompletedTasks ? deviceSize.height * 0.24 : deviceSize.height * 0.28;
    final emptyTasksAlert = isCompletedTasks
        ? 'There is no completed task yet'
        : 'There is no task to todo!';

    return CommonContainer(
        height: height,
        child: StreamBuilder(
          stream: ref.watch(todoProvider.notifier).getAllTask(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred!'));
            }
            if (snapshot.data == null) {
              return const Center(child: Text('No data found!'));
            }
            final tasks = snapshot.data!.docs
                .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            print(tasks.toString());

            final completedTasks = tasks
                .where((element) =>
                    element.isCompleted == true || element.isCompleted == 1)
                .toList();

            final inCompletedTasks = tasks
                .where((element) =>
                    element.isCompleted == false || element.isCompleted == 0)
                .toList();

            log(tasks.toString());
            if (isCompletedTasks) {
              if (completedTasks.isEmpty) {
                return Center(
                    child: Text(
                  emptyTasksAlert,
                  style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ));
              }
              return ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task =
                      completedTasks[index]; // Use completedTasks list here
                  return InkWell(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return TaskDetails(task: task);
                        },
                      );
                    },
                    onLongPress: () async {
                      await AppAlerts.showAlertDeleteDialog(
                        context: context,
                        ref: ref,
                        task: task,
                      );
                    },
                    child: TaskTile(
                      task: task,
                      onCompleted: (value) {
                        ref
                            .read(todoProvider.notifier)
                            .updateTask(id: task.id, isCompleted: value!);
                      },
                    ),
                  );
                },
              );
            } else {
              if (inCompletedTasks.isEmpty) {
                return Center(
                    child: Text(emptyTasksAlert,
                        style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)));
              }
              return ListView.builder(
                itemCount: inCompletedTasks.length,
                itemBuilder: (context, index) {
                  final task =
                      inCompletedTasks[index]; // Use inCompletedTasks list here
                  return InkWell(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return TaskDetails(task: task);
                        },
                      );
                    },
                    onLongPress: () async {
                      await AppAlerts.showAlertDeleteDialog(
                        context: context,
                        ref: ref,
                        task: task,
                      );
                    },
                    child: TaskTile(
                      task: task,
                      onCompleted: (value) {
                        ref
                            .read(todoProvider.notifier)
                            .updateTask(id: task.id, isCompleted: value!);
                      },
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
