import 'package:flutter/material.dart';

class SelectGroup extends StatefulWidget {
  final String value;
  final String labelText;
  final List<String> options;
  final double spacing;
  final Function(String) onItemSelected;

  const SelectGroup(
      {required this.value,
      required this.labelText,
      required this.options,
      this.spacing = 24.0,
      required this.onItemSelected,
      Key? key})
      : super(key: key);

  @override
  SelectGroupState createState() => SelectGroupState();
}

class SelectGroupState extends State<SelectGroup> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = widget.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          value: _selectedValue,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            widget.onItemSelected(newValue!);
          },
          decoration: InputDecoration(
              labelText: widget.labelText, border: const OutlineInputBorder()),
        ),
        SizedBox(height: widget.spacing),
      ],
    );
  }
}
