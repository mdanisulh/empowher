import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatCard extends StatelessWidget {
  final String text;
  final String role;
  const ChatCard({super.key, required this.text, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: role == 'user' ? Alignment.bottomRight : Alignment.bottomLeft,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: role == 'user' ? Colors.deepPurple.shade300 : Colors.amberAccent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: MarkdownBody(
            listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.baseline,
            data: text,
            selectable: true,
          ),
        ),
      ),
    );
  }
}
