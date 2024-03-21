import 'package:todo_app/app/helpers/helper.dart';

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

  Helper helper = Helper();

  static List<Todo> filterByCategoryAndStatus(
      List<Todo> list, String category, String status) {
    if (category == 'All') {
      if (status == 'Completed') {
        return list.where((element) => element.isCompleted == true).toList();
      } else if (status == 'Pending') {
        return list.where((element) => element.isCompleted == false).toList();
      } else {
        return list;
      }
    } else {
      if (status == 'Completed') {
        return list
            .where((element) =>
                element.category == category && element.isCompleted == true)
            .toList();
      } else if (status == 'Pending') {
        return list
            .where((element) =>
                element.category == category && element.isCompleted == false)
            .toList();
      } else {
        return list.where((element) => element.category == category).toList();
      }
    }

    // return list.where((element) => element.category == category).toList();
  }

  // List<Map<String, dynamic>> all() {
  //   return [
  //     {
  //       'id': id,
  //       'task': task,
  //       'category': category,
  //       'is_completed': isCompleted
  //     }
  //   ];
  // }

  // factory Todo.fromJson(Map<String, dynamic> json) {
  //   return Todo(
  //     id: json['id'],
  //     category: json['category'],
  //     task: json['task'],
  //     isCompleted: json['is_completed'],
  //   );
  // }

  // static Future<List<Todo>> getTodoList() async {
  //   final response = await http.get(
  //       Uri.parse('https://955e-180-191-173-122.ngrok-free.app/api/todos'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonList = jsonDecode(response.body);
  //     List<Todo> todoList =
  //         jsonList.map((item) => Todo.fromJson(item)).toList();

  //     return todoList;
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
}
