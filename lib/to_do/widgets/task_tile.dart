import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Provider/todoProvider.dart';
import 'package:minor_project/constants.dart';
import '../data/data.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'package:gap/gap.dart';

class TaskTile extends ConsumerStatefulWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.onCompleted,
  });

  final Task task;

  final Function(bool?)? onCompleted;

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    final colors = context.colorScheme;

    final textDecoration = widget.task.isCompleted
        ? TextDecoration.lineThrough
        : TextDecoration.none;
    final fontWeight =
        widget.task.isCompleted ? FontWeight.normal : FontWeight.bold;
    final double iconOpacity = widget.task.isCompleted ? 0.3 : 0.5;
    final double backgroundOpacity = widget.task.isCompleted ? 0.1 : 0.3;

    return Container(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          Stack(
            children: [
              CircleContainer(
                borderColor: widget.task.assignedBy != widget.task.assignedTo
                    ? Colors.redAccent
                    : widget.task.category.color,
                color:
                    widget.task.category.color.withOpacity(backgroundOpacity),
                child: Icon(
                  widget.task.category.icon,
                  color: widget.task.category.color.withOpacity(iconOpacity),
                ),
              ),
              if (widget.task.assignedBy != widget.task.assignedTo)
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: kPrimaryLightColor,
                        width: 2,
                      ),
                    ),
                  ),
                )
            ],
          ),
          const Gap(16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.title,
                style: style.titleMedium?.copyWith(
                  fontWeight: fontWeight,
                  fontSize: 20,
                  decoration: textDecoration,
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.task.date + " | ",
                    style: style.titleMedium?.copyWith(
                      decoration: textDecoration,
                    ),
                  ),
                  Text(
                    widget.task.time,
                    style: style.titleMedium?.copyWith(
                      decoration: textDecoration,
                    ),
                  ),
                ],
              ),
            ],
          )),
          Checkbox(
            value: widget.task.isCompleted,
            onChanged: (value) {
              ref.read(todoProvider.notifier).updateTask(
                  id: widget.task.id.toString(), isCompleted: value ?? false);
            },
            checkColor: colors.surface,
          ),
        ],
      ),
    );
  }
}
