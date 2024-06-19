import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final Function(String) onSend;
  final String hintText;
  final InputDecoration decoration;

  const ChatTextField({
    Key? key,
    required this.onSend,
    this.hintText = 'Type your message...',
    this.decoration = const InputDecoration(
      hintText: 'Type your message...',
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      // ),
    ),
  }) : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: FocusNode(), // Optional: Manage focus behavior
            decoration: widget.decoration,
            onChanged: (text) {
              // Enable/disable send button conditionally (optional)
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSend(_controller.text);
              _controller.clear();
            }
          },
          disabledColor: Colors.grey, // Optional: Visually indicate disabled state
        ),
      ],
    );
  }
}