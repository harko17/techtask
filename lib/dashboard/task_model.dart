class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, required this.completed});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] ?? false,
    );
  }
}
