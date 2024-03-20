import 'package:flutter/material.dart';
import 'package:todo_app/app/models/todo.dart'; // * Import Model here
import 'package:todo_app/resources/widgets/input_group.dart';
import 'package:todo_app/resources/widgets/input_group.dart';
import 'package:todo_app/resources/widgets/select_group.dart';
import 'package:todo_app/resources/widgets/snack_bar_container.dart';
// import 'package:todo_app/resources/widgets/empty_state.dart';
import 'package:uuid/uuid.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> todoList = [];
  late Todo selectedTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
        child: todoList.isEmpty
            ? SizedBox(
                width: double.infinity,
                child: Column(children: [
                  Image.asset('/images/empty_state.png'),
                  Container(height: 24.0),
                  const Text(
                    "Awesome! Looks like you're free \n from tasks for now.",
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 24.0),
                  MaterialButton(
                      padding: const EdgeInsets.all(24.0),
                      color: const Color(0xffffbb29),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: const Text(
                        'Create Task',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () => _createEditTask())
                ]),
              )
            : ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, int index) {
                  return toDoItemTile(index, todoList[index], context);
                }),
      ),
      floatingActionButton: todoList.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: const Color(0xffffbb29),
              onPressed: () {
                _createEditTask();
              },
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
      'category': Text('#${todoItem.category}',
          style: TextStyle(
            decoration:
                !todoItem.isCompleted ? null : TextDecoration.lineThrough,
            color: const Color(0xff1ea446),
            fontSize: 14,
          )),
      'leading': Checkbox(
          value: todoItem.isCompleted,
          tristate: !todoItem.isCompleted,
          onChanged: (value) {
            setState(() {
              todoItem.isCompleted = value!;
            });
          }),
      'edit': () {
        setState(() {
          selectedTodo = todoItem;
        });

        _createEditTask(selectedTodo, false, index);
      },
      'delete': IconButton(
        icon: const Icon(
          Icons.delete,
          size: 24.0,
        ),
        onPressed: () => _deleteTask(context, index),
      )
    };

    return ListTile(
      title: properties['task'],
      subtitle: properties['category'],
      leading: properties['leading'],
      trailing: properties['delete'],
      onTap: todoItem.isCompleted ? null : properties['edit'],
    );
  }

  String generateGuid() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  void _createEditTask([Todo? todo, bool isCreate = true, int index = 0]) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController taskController = TextEditingController();
    taskController.text = isCreate ? '' : todo!.task;
    String category = isCreate ? 'Home' : todo!.category;

    showDialog(
      context: context,
      builder: (context) {
        String mode = isCreate ? 'Create New' : 'Edit';
        return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '$mode Task',
              style: const TextStyle(fontSize: 18),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectGroup(
                            value: category,
                            labelText: 'Category',
                            onItemSelected: (selectedItem) {
                              setState(() {
                                category = selectedItem;
                              });
                            },
                          ),
                          InputGroup(
                            labelText: 'Task',
                            name: 'task',
                            controller: taskController,
                          ),
                          MaterialButton(
                              padding: const EdgeInsets.all(24.0),
                              color: const Color(0xffffbb29),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              minWidth: double.infinity,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  String mode =
                                      'Task ${isCreate ? 'added' : 'update'} successfully!';
                                  if (isCreate) {
                                    setState(() {
                                      todoList.add(Todo(
                                          id: generateGuid(),
                                          category: category,
                                          task: taskController.text.trim()));
                                    });
                                  } else {
                                    setState(() {
                                      todoList[index] = Todo(
                                          id: todo!.id,
                                          category: category,
                                          task: taskController.text.trim());
                                    });
                                  }

                                  SnackBar snackBar = SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: const Color(0xff1ea446),
                                    content: SnackBarContent(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      message: mode,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  taskController.clear();

                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                'Add Task',
                                style: TextStyle(fontSize: 16.0),
                              )),
                        ]),
                  )),
            ));
      },
    );
  }

  void _deleteTask(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            title: const Text(
              'Are you sure you?',
              style: TextStyle(fontSize: 18),
            ),
            icon: const Icon(Icons.warning),
            iconPadding: const EdgeInsets.all(20),
            iconColor: Colors.redAccent,
            contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    // padding: const EdgeInsets.all(24.0),
                    child: const Text('Yes'),
                    onPressed: () {
                      setState(() {
                        todoList.removeAt(index);
                      });

                      SnackBar snackBar = const SnackBar(
                        behavior: SnackBarBehavior.fixed,
                        backgroundColor: Color(0xff1ea446),
                        content: SnackBarContent(
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          message: 'Task deleted successfully!',
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  MaterialButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.all(10),
          );
        });
  }
}
