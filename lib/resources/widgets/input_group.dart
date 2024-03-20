import 'package:flutter/material.dart';

class InputGroup extends StatefulWidget {
  final String labelText;
  final String name;
  final TextEditingController? controller;
  final double spacing;

  const InputGroup(
      {required this.labelText,
      required this.name,
      this.controller,
      this.spacing = 24.0,
      Key? key})
      : super(key: key);

  @override
  InputGroupState createState() => InputGroupState();
}

class InputGroupState extends State<InputGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          maxLength: 50,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
          ),
          controller: widget.controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          },
        ),
        SizedBox(height: widget.spacing),
      ],
    );
  }
}
