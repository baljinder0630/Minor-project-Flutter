import 'package:equatable/equatable.dart';
import '../../utils/utils.dart';

class Task extends Equatable {
  final String? id;
  final String title;
  final String note;
  final TaskCategory category;
  final String time;
  final String date;
  final String assignedBy;
  final bool isCompleted;
  const Task({
    this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.date,
    required this.note,
    required this.assignedBy,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      TaskKeys.id: id,
      TaskKeys.title: title,
      TaskKeys.note: note,
      TaskKeys.category: category.name,
      TaskKeys.time: time,
      TaskKeys.date: date,
      TaskKeys.assignedBy: assignedBy,
      TaskKeys.isCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      id: map[TaskKeys.id],
      title: map[TaskKeys.title],
      note: map[TaskKeys.note],
      category: TaskCategory.stringToTaskCategory(map[TaskKeys.category]),
      time: map[TaskKeys.time],
      date: map[TaskKeys.date],
      assignedBy: map[TaskKeys.assignedBy],
      isCompleted: map[TaskKeys.isCompleted] == 1 ? true : false,
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      note,
      category,
      time,
      date,
      assignedBy,
      isCompleted,
    ];
  }

  Task copyWith({
    String? id,
    String? title,
    String? note,
    TaskCategory? category,
    String? time,
    String? date,
    String? assignedBy,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      category: category ?? this.category,
      time: time ?? this.time,
      date: date ?? this.date,
      assignedBy: assignedBy ?? this.assignedBy,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
