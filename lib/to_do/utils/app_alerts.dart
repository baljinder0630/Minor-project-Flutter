import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minor_project/Provider/todoProvider.dart';
import '../data/data.dart';
import '../utils/utils.dart';

@immutable
class AppAlerts {
  const AppAlerts._();

  static displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.textTheme.bodyMedium,
        ),
        backgroundColor: context.colorScheme.onSecondary,
      ),
    );
  }

  static Future<void> showAlertDeleteDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Task task,
  }) async {
    Widget deleteButton = TextButton(
      onPressed: () async {
        await ref.read(todoProvider.notifier).deleteTask(task.id).then(
          (value) {
            displaySnackbar(
              context,
              'Task deleted successfully',
            );
          },
        );
        context.pop();
      },
      child: const Text('YES'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Are you sure you want to delete this task?'),
      actions: [
        deleteButton,
      ],
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
