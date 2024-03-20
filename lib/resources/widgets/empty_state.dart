import 'package:flutter/material.dart';

class EmptyState extends StatefulWidget {
  final Function(void)? onRedirect;

  const EmptyState({required this.onRedirect, Key? key}) : super(key: key);

  @override
  _EmptyStateState createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            onPressed: () {
              if (widget.onRedirect != null) {
                widget.onRedirect;
              }
            })
      ]),
    );
  }
}
