import 'package:flutter/material.dart';

class ToDoTail extends StatelessWidget {
  final String task;
  final bool taskstatus;
  final String priority;
  final String dueDate;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  const ToDoTail({
    super.key,
    required this.task,
    required this.taskstatus,
    required this.priority,
    required this.dueDate,
    required this.onChanged,
    required this.deleteFunction,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
      default:
        return Colors.green;
    }
  }

  bool _isOverdue(String dueDate) {
    if (dueDate == 'No Date') return false;
    try {
      DateTime parsed = DateTime.parse(dueDate);
      return !taskstatus && parsed.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOverdue = _isOverdue(dueDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red[100] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(value: taskstatus, onChanged: onChanged),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task,
                    style: TextStyle(
                      decoration: taskstatus ? TextDecoration.lineThrough : null,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("Due: $dueDate", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteFunction?.call(context),
          ),
        ],
      ),
    );
  }
}
