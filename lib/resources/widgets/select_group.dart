import 'package:flutter/material.dart';

class SelectGroup extends StatefulWidget {
  final String value;
  final String labelText;
  final double spacing;
  final Function(String)? onItemSelected;

  const SelectGroup(
      {required this.value,
      required this.labelText,
      this.spacing = 24.0,
      required this.onItemSelected,
      Key? key})
      : super(key: key);

  @override
  SelectGroupState createState() => SelectGroupState();
}

class SelectGroupState extends State<SelectGroup> {
  @override
  Widget build(BuildContext context) {
    List<String> items = ['Home', 'Personal', 'Work'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          value: widget.value,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (widget.onItemSelected != null) {
              widget.onItemSelected!(newValue!);
            }
          },
          decoration: InputDecoration(
              labelText: widget.labelText, border: const OutlineInputBorder()),
        ),
        SizedBox(height: widget.spacing),
      ],
    );
  }
}
