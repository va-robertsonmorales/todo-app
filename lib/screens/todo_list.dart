import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart'; // * Import Model here

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-dos')),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, int index) {
            return toDoItemTile(index, todoList[index], context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createNewTask();
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add)),
    );
  }

  Widget toDoItemTile(int index, Todo todoItem, BuildContext context) {
    Map<String, dynamic> properties = {
      'task': Text(
        todoItem.task,
        style: !todoItem.isCompleted
            ? null
            : const TextStyle(decoration: TextDecoration.lineThrough),
      ),
      'category': Text(
        '# ${todoItem.category}',
        style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
      ),
      'leading': todoItem.isCompleted
          ? null
          : Checkbox(
              value: todoItem.isCompleted,
              onChanged: (value) {
                setState(() {
                  todoItem.isCompleted = value!;
                });
              }),
      'edit': todoItem.isCompleted ? null : editTask(context, index),
    };

    return ListTile(
      title: properties['task'],
      subtitle: properties['category'],
      leading: properties['leading'],
      contentPadding: const EdgeInsets.all(20.0),
      trailing: todoItem.isCompleted ? null : properties['edit'],
      onTap: null,
      onLongPress:
          todoItem.isCompleted ? null : () => _deleteTask(context, index),
    );
  }

  void _createNewTask() {
    TextEditingController categoryController = TextEditingController();
    TextEditingController taskController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        String? selectedItem = 'One';

        return AlertDialog(
            title: const Text(
              'Create New Task',
              style: TextStyle(fontSize: 18),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    controller: categoryController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is field is required.';
                      }

                      return null;
                    },
                    autofocus: true,
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Task',
                      border: OutlineInputBorder(),
                    ),
                    controller: taskController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is field is required.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 32.0),
                  DropdownButtonFormField(
                    value: selectedItem,
                    items: <String>['One', 'Two', 'Three']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                        labelText: 'Category', border: OutlineInputBorder()),
                  ),
                  MaterialButton(
                      padding: const EdgeInsets.all(24.0),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            todoList.add(Todo(
                                category: selectedItem!,
                                task: taskController.text.trim()));
                          });

                          categoryController.clear();
                          taskController.clear();

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Add Task'))
                ]),
              ),
            ));
      },
    );
  }

  void _deleteTask(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Are you sure you?',
              style: TextStyle(fontSize: 18),
            ),
            icon: const Icon(Icons.warning),
            iconPadding: const EdgeInsets.all(20),
            iconColor: Colors.redAccent,
            contentPadding: const EdgeInsets.all(32),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    todoList.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.all(10),
          );
        });
  }

  IconButton editTask(BuildContext context, int index) {
    return const IconButton(
        tooltip: 'Edit Task',
        icon: Icon(Icons.edit),
        iconSize: 32,
        color: Colors.blueAccent,
        onPressed: null);
  }
}
