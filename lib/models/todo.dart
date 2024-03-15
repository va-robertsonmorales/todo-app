class Todo {
  String task;
  String category;
  bool isCompleted;

  Todo({
    required this.task,
    required this.category,
    this.isCompleted = false,
  });
}
