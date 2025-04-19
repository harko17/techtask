import 'package:flutter/material.dart';
import '../dashboard/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback? onToggle;

  const TaskTile({required this.task, required this.onDelete, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      leading: Checkbox(value: task.completed, onChanged: (_) => onToggle?.call()),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
    );
  }
}
