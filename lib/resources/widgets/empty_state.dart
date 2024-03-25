import 'package:flutter/material.dart';
import 'package:todo_app/variables.dart';

class EmptyStateContainer extends StatefulWidget {
  final VoidCallback onTakeAction;
  final String asset;
  final String description;
  final String buttonText;

  const EmptyStateContainer(
      {required this.onTakeAction,
      required this.asset,
      required this.description,
      required this.buttonText,
      Key? key})
      : super(key: key);

  @override
  EmptyState createState() => EmptyState();
}

class EmptyState extends State<EmptyStateContainer> {
  Variables variable = Variables();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [
        Container(height: 24.0),
        Image.asset(
          widget.asset,
          width: 350,
        ),
        Container(height: 24.0),
        Text(
          widget.description,
          style: const TextStyle(fontSize: 18.0, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        Container(height: 24.0),
        MaterialButton(
            padding: EdgeInsets.fromLTRB(
                28.0, variable.getPadding(), 28.0, variable.getPadding()),
            color: Color(variable.getPrimary()),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(variable.getBorderRadius())),
            onPressed: widget.onTakeAction,
            child: Text(
              widget.buttonText,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            )),
      ]),
    );
  }
}
