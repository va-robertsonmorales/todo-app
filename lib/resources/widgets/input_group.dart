import 'package:flutter/material.dart';

class InputGroup extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final double spacing;
  final bool isRichTextBox;

  const InputGroup(
      {required this.labelText,
      this.controller,
      this.spacing = 24.0,
      this.isRichTextBox = false,
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
          maxLength: widget.isRichTextBox ? null : 50,
          maxLines: widget.isRichTextBox ? null : 1,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
          ),
          controller: widget.controller,
          textInputAction:
              widget.isRichTextBox ? TextInputAction.newline : null,
          keyboardType: widget.isRichTextBox ? TextInputType.multiline : null,
          validator: widget.isRichTextBox
              ? null
              : (value) {
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
