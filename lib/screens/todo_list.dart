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
            return toDoItem(index, todoList[index], context);
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

  void _createNewTask() {
    TextEditingController categoryController = TextEditingController();
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Create New Task',
            style: TextStyle(fontSize: 18),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  controller: categoryController,
                  autofocus: true,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task',
                  ),
                  controller: taskController,
                ),
                MaterialButton(
                    padding: const EdgeInsets.all(24.0),
                    onPressed: () {
                      setState(() {
                        todoList.add(Todo(
                            category: categoryController.text.trim(),
                            task: taskController.text.trim()));

                        categoryController.clear();
                        taskController.clear();
                      });

                      Navigator.of(context).pop();
                    },
                    child: const Text('Add Task'))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget toDoItem(int index, Todo todoItem, BuildContext context) {
    bool hideEditButton = false;
    return ListTile(
      title: Text(todoItem.task),
      leading: Checkbox(
          value: todoItem.isCompleted,
          onChanged: (value) {
            setState(() {
              todoItem.isCompleted = value!;
            });
            // todoItem.isCompleted = value!;
          }),
      subtitle: Text(todoItem.category),
      contentPadding: const EdgeInsets.all(20.0),
      trailing: editTask(context, index, hideEditButton),
      onLongPress: () {
        setState(() {
          deleteTask(context, index);
        });
      },
    );
  }
}

IconButton editTask(BuildContext context, int index, bool hideEditButton) {
  return IconButton(
    tooltip: 'Edit Task',
    icon: const Icon(Icons.edit),
    iconSize: 32,
    color: Colors.blueAccent,
    onPressed: () => {
      if (hideEditButton) {null} else {}
    },
  );
}

Future deleteTask(BuildContext context, int index) {
  return showDialog(
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
                // _todoList.removeAt(index);
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

// class TodoForm extends StatefulWidget {
//   const TodoForm({super.key});

//   @override
//   State<TodoForm> createState() => _TodoFormState();
// }

// class _TodoFormState extends State<TodoForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('New To-do')),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // Form fields go here
//                 TextFormField(
//                   controller: _categoryController,
//                   decoration: const InputDecoration(
//                     labelText: 'Category',
//                     hintText: 'Enter category',
//                   ),
//                   validator: (value) {
//                     if (value == "") {
//                       return 'This field is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _taskController,
//                   decoration: const InputDecoration(
//                     labelText: 'Task',
//                     hintText: 'Enter task',
//                   ),
//                   validator: (value) {
//                     if (value == "") {
//                       return 'This is field is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 MaterialButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       setState(() {});
//                       // If the form is valid, display a snackbar. If there are any errors (defined above), they will be shown here.
//                       // ScaffoldMessenger.of(context).showSnackBar(
//                       //   const SnackBar(
//                       //     content: Text('Task Added Successfully',
//                       //         style: TextStyle(color: Colors.white)),
//                       //     backgroundColor: Color.fromARGB(255, 13, 121, 69),
//                       //     duration: Duration(seconds: 3),
//                       //   ),
//                       // );

//                       // Navigator.pop(context); // redirect back to the list page
//                     }
//                   },
//                   padding: const EdgeInsets.all(24.0),
//                   child: const Text('Submit', style: TextStyle(fontSize: 16.0)),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
