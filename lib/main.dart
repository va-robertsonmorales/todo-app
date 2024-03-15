import 'package:flutter/material.dart';

import 'package:todo_app/helpers/shared_preferences_helper.dart';
import 'package:todo_app/screens/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const TodoList(),
        });
  }
}
