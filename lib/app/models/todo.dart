class Todo {
  String id;
  String task;
  String category;
  bool isCompleted;

  Todo({
    this.id = '0',
    required this.task,
    required this.category,
    this.isCompleted = false,
  });
}
