import 'package:flutter/material.dart';
import 'package:todo_app/app/controllers/todo_list_controller.dart';
import 'package:todo_app/app/models/todo.dart'; // * Import Model here
import 'package:todo_app/resources/widgets/input_group.dart';
import 'package:todo_app/resources/widgets/select_group.dart';
import 'package:todo_app/resources/widgets/snack_bar_container.dart';
// import 'package:todo_app/resources/widgets/search.dart';
import 'package:todo_app/resources/widgets/empty_state.dart';
import 'package:todo_app/variables.dart';
import 'package:todo_app/app/helpers/helper.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> with AutomaticKeepAliveClientMixin {
  Helper helper = Helper();
  Variables variable = Variables();
  ToDoListController toDoListController = ToDoListController();

  bool hasNoResult = false;

  List<Todo> todoList = [];
  List<Todo> oldTodoList = [];

  late Todo selectedTodo;

  TextEditingController filterCategory = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);

    return Scaffold(
      drawer: const DrawerButton(),
      appBar: AppBar(
        title: const Text('ToDo App',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Container(
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
        child: todoList.isEmpty
            ? (hasNoResult
                ? EmptyStateContainer(
                    asset: '/images/not_found.png',
                    description: "Looks like there are no tasks to be found.",
                    buttonText: 'Go to List',
                    onTakeAction: () {
                      Navigator.pushNamed(context, '/');
                    })
                : EmptyStateContainer(
                    asset: '/images/empty_state.png',
                    description:
                        "Awesome! Looks like you're free \n from tasks for now.",
                    buttonText: 'Create Task',
                    onTakeAction: _createEditTask))
            : _showList(todoList.reversed.toList()),
      ),
      floatingActionButton: fab(),
    );
  }

  FloatingActionButton? fab() {
    return todoList.isEmpty
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
            child: const Icon(Icons.add));
  }

  Container _showList(List<Todo> list) {
    return Container(
      padding: EdgeInsets.all(variable.getPadding()),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${todoList.length.toString()} to-dos'),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                WidgetSpan(
                    child: Row(children: [_searchAction(), _filterAction()])),
              ]))
        ]),
        const SizedBox(
          height: 16.0,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, int index) {
                  return Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: _showListTile(index, list[index], context),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  );
                })),
      ]),
    );
  }

  ListTile _showListTile(int index, Todo todoItem, BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(variable.getBorderRadius())),
      title: _category(todoItem),
      subtitle: _task(todoItem),
      leading: _checked(todoItem, index),
      trailing: _triggerDeleteTask(index, context),
      onTap:
          todoItem.isCompleted ? null : () => _triggerEditTask(todoItem, index),
    );
  }

  void _createEditTask([Todo? todo, bool isCreate = true, int index = 0]) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController taskController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    // Set initial values based on action
    categoryController.text = isCreate ? 'Home' : todo!.category;
    taskController.text = isCreate ? '' : todo!.task;
    descriptionController.text = isCreate ? '' : todo!.description;

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
                            value: categoryController.text,
                            labelText: 'Category',
                            options: const ['Home', 'Personal', 'Work'],
                            onItemSelected: (selectedItem) {
                              setState(() {
                                categoryController.text = selectedItem;
                              });
                            },
                          ),
                          InputGroup(
                            labelText: 'Task',
                            controller: taskController,
                          ),
                          InputGroup(
                            labelText: 'Description',
                            controller: descriptionController,
                            isRichTextBox: true,
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
                            child: Text(
                              '${isCreate ? 'Add' : 'Update'} Task',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (isCreate) {
                                  setState(() {
                                    todoList.add(Todo(
                                        id: helper.generateGuid(),
                                        category: categoryController.text,
                                        task: taskController.text.trim(),
                                        description:
                                            descriptionController.text.trim()));

                                    oldTodoList = todoList;
                                  });
                                } else {
                                  setState(() {
                                    todoList[index] = Todo(
                                        id: todo!.id,
                                        category: categoryController.text,
                                        task: taskController.text.trim(),
                                        description:
                                            descriptionController.text.trim());

                                    oldTodoList = todoList;
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
                                    message:
                                        'Task ${isCreate ? 'added' : 'updated'} successfully!',
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                categoryController.clear();
                                taskController.clear();
                                descriptionController.clear();

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
                        oldTodoList = todoList;
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

  Column _task(Todo todoItem) {
    int maxLength = 20;

    List<Widget> items = [
      const SizedBox(
        height: 8.0,
      ),
      Text(todoItem.task,
          style: TextStyle(
              decoration:
                  !todoItem.isCompleted ? null : TextDecoration.lineThrough,
              fontWeight: FontWeight.w600,
              fontSize: 18.0)),
      Visibility(
          visible: todoItem.description == '' ? false : true,
          child: Text(
              todoItem.description.length < maxLength
                  ? todoItem.description
                  : '${todoItem.description.substring(0, maxLength)} ...',
              style: TextStyle(
                  decoration: !todoItem.isCompleted
                      ? null
                      : TextDecoration.lineThrough))),
      // Chip(
      //   backgroundColor: Color(variable.getSuccess()),
      //   labelStyle: const TextStyle(color: Colors.white),
      //   padding: const EdgeInsets.all(2.0),
      //   label: Text(todoItem.isCompleted ? 'Completed' : 'Pending'),
      //   surfaceTintColor: Color(variable.getSuccess()),
      // )
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  RichText _category(Todo todoItem) {
    return RichText(
        text: TextSpan(children: [
      WidgetSpan(
        child: Row(
          children: [
            Icon(
                todoItem.category == 'Personal'
                    ? Icons.person
                    : (todoItem.category == 'Work' ? Icons.work : Icons.home),
                color: Color(variable.getSuccess()),
                size: 16.0),
            const SizedBox(width: 4.0),
            Text(todoItem.category,
                style: TextStyle(
                  decoration:
                      !todoItem.isCompleted ? null : TextDecoration.lineThrough,
                  color: Color(variable.getSuccess()),
                  fontSize: 12.0,
                )),
          ],
        ),
      )
    ]));
  }

  Checkbox _checked(Todo todoItem, int index) {
    return Checkbox(
        value: todoItem.isCompleted,
        activeColor: Color(variable.getSuccess()),
        tristate: !todoItem.isCompleted,
        onChanged: (value) {
          setState(() {
            todoList[index].isCompleted = value!;
            oldTodoList = todoList;
          });
        });
  }

  void _triggerEditTask(Todo todoItem, int index) {
    setState(() {
      selectedTodo = todoItem;
    });

    _createEditTask(selectedTodo, false, index);
  }

  IconButton _triggerDeleteTask(int index, BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        size: 24.0,
      ),
      onPressed: () => _deleteTask(context, index),
    );
  }

  void _searchToDo(String search) {
    if (search.isEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          hasNoResult = false;
          todoList = oldTodoList;
        });
      });

      return;
    } else {
      List<Todo> listData = oldTodoList
          .where(
              (todo) => todo.task.toLowerCase().contains(search.toLowerCase()))
          .toList();

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          hasNoResult = listData.isEmpty;
          todoList = listData;
        });
      });
    }
  }

  Row _searchAction() {
    return Row(
      children: [
        SizedBox(
            width: 180,
            child: TextField(
              controller: searchController,
              onSubmitted: _searchToDo,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                labelText: 'Search',
                hintText: 'Search for tasks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            )),
        const SizedBox(
          width: 8.0,
        )
      ],
    );
  }

  IconButton _filterAction() {
    return IconButton(
        icon: const Icon(Icons.filter_list_alt),
        onPressed: () {
          final filterFormKey = GlobalKey<FormState>();

          setState(() {
            filterCategory.text = 'All';
            status.text = 'All';

            todoList = oldTodoList;
          });

          showGeneralDialog(
            context: context,
            barrierLabel: '',
            barrierDismissible: true,
            transitionBuilder: (context, animation1, animation2, child) {
              return FadeTransition(opacity: animation1, child: child);
            },
            pageBuilder: (context, animation1, animation2) {
              return Material(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        title: const Text(
                          'Filter Tasks',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        content: Padding(
                          padding: EdgeInsets.fromLTRB(0, variable.getPadding(),
                              0, variable.getPadding()),
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
                                              borderRadius:
                                                  BorderRadius.circular(variable
                                                      .getBorderRadius())),
                                          minWidth: double.infinity,
                                          onPressed: _filterTask,
                                          child: const Text(
                                            'Filter',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                              )),
                        ),
                      ),
                    ),
                    // Positioned close button
                    Positioned(
                      top: 0, // Adjust top padding
                      right: 0, // Adjust right padding
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            Navigator.pop(context), // Dismiss the dialog
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _filterTask() {
    List<Todo> filteredList = toDoListController.filterByCategoryAndStatus(
        oldTodoList, filterCategory.text.toString(), status.text.toString());

    setState(() {
      todoList = filteredList;
      hasNoResult = filteredList.isEmpty;
    });

    Navigator.of(context).pop();
  }

  // void _seeder() {
  //   oldTodoList = [
  //     Todo(
  //       task: 'Task 1',
  //       category: 'Home',
  //       description:
  //           'lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum',
  //       isCompleted: false,
  //     ),
  //     Todo(
  //       task: 'Task 2',
  //       category: 'Personal',
  //       description:
  //           'lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum',
  //       isCompleted: false,
  //     ),
  //     Todo(
  //       task: 'Task 3',
  //       category: 'Work',
  //       description:
  //           'lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum',
  //       isCompleted: false,
  //     ),
  //   ];
  // }
}
