import 'package:flutter/material.dart';
import 'package:todo_app/variables.dart';

class EmptyState extends StatelessWidget {
  Variables variable = Variables();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(children: [
        Image.asset('/images/empty_state.png'),
        Container(height: 24.0),
        const Text(
          "Awesome! Looks like you're free \n from tasks for now.",
          style: TextStyle(fontSize: 18.0, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        Container(height: 24.0),
        MaterialButton(
            padding: EdgeInsets.fromLTRB(
                28.0, variable.getPadding(), 28.0, variable.getPadding()),
            color: Color(variable.getPrimary()),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(variable.getBorderRadius())),
            onPressed: null,
            child: const Text(
              'Create Task',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            )),
      ]),
    );
  }
}
