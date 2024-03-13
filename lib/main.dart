import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list.dart';

void main() => runApp(const MyTodoApp());

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Todo App', debugShowCheckedModeBanner: false, home: TodoList());
  }
}
