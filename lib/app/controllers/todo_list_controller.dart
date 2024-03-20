// import 'package:flutter/material.dart';
// import 'package:todo_app/app/models/todo.dart'; // * Import Model here

class toDoListController {
  // void _createEditTask([Todo? todo, bool isCreate = true, int index = 0]) {
  //   final formKey = GlobalKey<FormState>();
  //   final TextEditingController taskController = TextEditingController();
  //   String category = isCreate ? 'Home' : todo!.category;
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       String mode = isCreate ? 'Create New' : 'Edit';
  //       return AlertDialog(
  //           backgroundColor: Colors.white,
  //           title: Text(
  //             '$mode Task',
  //             style: const TextStyle(fontSize: 18),
  //           ),
  //           content: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Form(
  //                 key: formKey,
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         SelectGroup(
  //                           value: category,
  //                           labelText: 'Category',
  //                           onItemSelected: (selectedItem) {
  //                             setState(() {
  //                               category = selectedItem;
  //                             });
  //                           },
  //                         ),
  //                         InputGroup(
  //                             initialValue: null,
  //                             labelText: 'Task',
  //                             name: 'task',
  //                             controller: taskController,
  //                             spacing: 32.0),
  //                         MaterialButton(
  //                             padding: const EdgeInsets.all(24.0),
  //                             color: const Color(0xffffbb29),
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(12.0)),
  //                             minWidth: double.infinity,
  //                             onPressed: () {
  //                               if (formKey.currentState!.validate()) {
  //                                 setState(() {
  //                                   if (isCreate) {
  //                                     todoList.add(Todo(
  //                                         id: generateGuid(),
  //                                         category: category,
  //                                         task: taskController.text.trim()));
  //                                   } else {
  //                                     todoList[index] = Todo(
  //                                         id: todo!.id,
  //                                         category: category,
  //                                         task: taskController.text.trim());
  //                                   }
  //                                 });
  //
  //                                 SnackBar snackBar = const SnackBar(
  //                                   behavior: SnackBarBehavior.fixed,
  //                                   backgroundColor: Color(0xff1ea446),
  //                                   content: SnackBarContent(
  //                                     icon: Icon(
  //                                       Icons.check,
  //                                       color: Colors.white,
  //                                     ),
  //                                     message: 'Task added successfully!',
  //                                   ),
  //                                 );
  //
  //                                 ScaffoldMessenger.of(context)
  //                                     .showSnackBar(snackBar);
  //
  //                                 taskController.clear();
  //
  //                                 Navigator.of(context).pop();
  //                               }
  //                             },
  //                             child: const Text(
  //                               'Add Task',
  //                               style: TextStyle(fontSize: 16.0),
  //                             )),
  //                       ]),
  //                 )),
  //           ));
  //     },
  //   );
  // }
}
