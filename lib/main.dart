import 'package:flutter/material.dart';

// import 'package:todo_app/app/helpers/shared_preferences_helper.dart';
import 'package:todo_app/resources/screens/todo/todo.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SharedPreferencesHelper.init();
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor:
              const Color(0xfff7f7f7), // Background color for the entire app
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, // Background color for app bar
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const TodoList(),
        });
  }
}
