class Task {
  final int id;
  final String title;
  final String detail;
  final bool completed;

  Task({required this.id, required this.title, required this.completed,required
  this.detail});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] ?? false,
      detail: map['detail']??"",
    );
  }
}
