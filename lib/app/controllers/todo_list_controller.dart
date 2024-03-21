import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_app/app/models/todo.dart';

class ToDoListController {
  List<Todo> todoList = [];

  Future<void> index() async {
    final response = await http.get(
        Uri.parse('https://955e-180-191-173-122.ngrok-free.app/api/todos'));

    if (response.statusCode == 200) {
      // todoList.addAll();
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
