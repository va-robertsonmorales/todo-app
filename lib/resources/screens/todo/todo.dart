import 'package:flutter/material.dart';
import 'package:todo_app/app/models/todo.dart'; // * Import Model here
import 'package:todo_app/resources/widgets/input_group.dart';
import 'package:todo_app/resources/widgets/select_group.dart';
import 'package:todo_app/resources/widgets/snack_bar_container.dart';
import 'package:todo_app/resources/widgets/search.dart';
// import 'package:todo_app/resources/widgets/empty_state.dart';
import 'package:todo_app/variables.dart';
import 'package:todo_app/app/helpers/helper.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  Helper helper = Helper();
  Variables variable = Variables();
  List<Todo> todoList = [];
  List<Todo> oldTodoList = [];
  late Todo selectedTodo;
  TextEditingController filterCategory = TextEditingController();
  TextEditingController status = TextEditingController();

  @override
  void initState() {
    super.initState();

    // _seeder();
    oldTodoList = todoList;

    filterCategory.text = 'All';
    status.text = 'All';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerButton(),
      appBar: AppBar(
        title: const Text('WhatToDo',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          Visibility(
              visible: todoList.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchDelegator());
                },
              )),
          Visibility(
            visible: todoList.isNotEmpty,
            child: IconButton(
                icon: const Icon(Icons.filter_list_alt),
                onPressed: () {
                  final filterFormKey = GlobalKey<FormState>();

                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          title: const Text(
                            'Filter Tasks',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                variable.getPadding(),
                                0,
                                variable.getPadding()),
                            child: Form(
                                key: filterFormKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectGroup(
                                          value: filterCategory.text,
                                          labelText: 'Category',
                                          options: const <String>[
                                            'All',
                                            'Home',
                                            'Personal',
                                            'Work'
                                          ],
                                          onItemSelected: (selectedItem) {
                                            setState(() {
                                              filterCategory.text =
                                                  selectedItem.toString();
                                            });
                                          },
                                        ),
                                        SelectGroup(
                                          value: status.text.toString(),
                                          labelText: 'Status',
                                          options: const [
                                            'All',
                                            'Pending',
                                            'Completed'
                                          ],
                                          onItemSelected: (selectedItem) {
                                            setState(() {
                                              status.text = selectedItem;
                                            });
                                          },
                                        ),
                                        MaterialButton(
                                            padding: EdgeInsets.fromLTRB(
                                                28.0,
                                                variable.getPadding(),
                                                28.0,
                                                variable.getPadding()),
                                            color: Color(variable.getPrimary()),
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(variable
                                                        .getBorderRadius())),
                                            minWidth: double.infinity,
                                            child: const Text(
                                              'Filter',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                todoList = Todo
                                                    .filterByCategoryAndStatus(
                                                        oldTodoList,
                                                        filterCategory.text
                                                            .toString(),
                                                        status.text.toString());
                                              });

                                              Navigator.of(context).pop();
                                            }),
                                      ]),
                                )),
                          ),
                          // actions: <Widget>[],
                          // actionsAlignment: MainAxisAlignment.center,
                          // actionsPadding: const EdgeInsets.all(10),
                        );
                      });
                }),
          ),
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
        child: todoList.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(children: [
                  Container(height: 24.0),
                  Image.asset(
                    '/images/empty_state.png',
                    width: 350,
                  ),
                  Container(height: 24.0),
                  const Text(
                    "Awesome! Looks like you're free \n from tasks for now.",
                    style: TextStyle(fontSize: 18.0, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 24.0),
                  MaterialButton(
                      padding: EdgeInsets.fromLTRB(28.0, variable.getPadding(),
                          28.0, variable.getPadding()),
                      color: Color(variable.getPrimary()),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              variable.getBorderRadius())),
                      child: const Text(
                        'Create Task',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () => _createEditTask())
                ]),
              )
            : Container(
                padding: EdgeInsets.all(variable.getPadding()),
                child: ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, int index) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            toDoItemTile(index, todoList[index], context)
                          ],
                        ),
                      );
                    }),
              ),
      ),
      floatingActionButton: todoList.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: Color(variable.getPrimary()),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(variable.getBorderRadius())),
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
        style: TextStyle(
            decoration:
                !todoItem.isCompleted ? null : TextDecoration.lineThrough,
            fontWeight: FontWeight.w600),
      ),
      'category': Text(todoItem.category,
          style: TextStyle(
            decoration:
                !todoItem.isCompleted ? null : TextDecoration.lineThrough,
            color: Color(variable.getSuccess()),
            fontSize: 14,
          )),
      'leading': Checkbox(
          value: todoItem.isCompleted,
          activeColor: Color(variable.getSuccess()),
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
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(variable.getBorderRadius())),
      title: properties['task'],
      subtitle: properties['category'],
      leading: properties['leading'],
      trailing: properties['delete'],
      onTap: todoItem.isCompleted ? null : properties['edit'],
    );
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
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(variable.getBorderRadius())),
            title: Text(
              '$mode Task',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            content: Padding(
              padding: EdgeInsets.fromLTRB(
                  0, variable.getPadding(), 0, variable.getPadding()),
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectGroup(
                            value: category,
                            labelText: 'Category',
                            options: const ['Home', 'Personal', 'Work'],
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
                            padding: EdgeInsets.fromLTRB(
                                28.0,
                                variable.getPadding(),
                                28.0,
                                variable.getPadding()),
                            color: Color(variable.getPrimary()),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    variable.getBorderRadius())),
                            minWidth: double.infinity,
                            child: const Text(
                              'Add Task',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                String mode =
                                    'Task ${isCreate ? 'added' : 'update'} successfully!';
                                if (isCreate) {
                                  setState(() {
                                    todoList.add(Todo(
                                        id: helper.generateGuid(),
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
                                  backgroundColor: Color(variable.getSuccess()),
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
                          ),
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

  void _seeder() {
    oldTodoList = [
      Todo(
        task: 'Task 1',
        category: 'Home',
        isCompleted: false,
      ),
      Todo(
        task: 'Task 2',
        category: 'Personal',
        isCompleted: false,
      ),
      Todo(
        task: 'Task 3',
        category: 'Work',
        isCompleted: false,
      ),
    ];
  }
}
