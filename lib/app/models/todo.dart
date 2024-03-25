class Todo {
  final String? id;
  final String task;
  final String category;
  final String description;
  bool isCompleted;

  Todo({
    this.id,
    required this.task,
    required this.category,
    this.description = '',
    this.isCompleted = false,
  });
}
