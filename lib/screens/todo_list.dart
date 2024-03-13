import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List - Todo App'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Welcome to Todo App List')),
    );
  }
}
