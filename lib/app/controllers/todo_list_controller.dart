import 'package:flutter/material.dart';
import 'package:todo_app/app/helpers/helper.dart';
import 'package:todo_app/app/models/todo.dart';

class ToDoListController extends ChangeNotifier {
  List<Todo> todoList = [];

  Helper helper = Helper();

  void addTodo(Todo todo) {
    notifyListeners();
  }

  void updateTodo(int index, Todo todo) {
    todoList[index] = todo;
    notifyListeners();
  }

  void deleteTodo(int index) {
    todoList.removeAt(index);
    notifyListeners();
  }

  List<Todo> filterByCategoryAndStatus(
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
  }
}
