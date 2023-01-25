import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class MyTextBox extends StatelessWidget {
  final String text;

  MyTextBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(5),
          color: Colors.pink,
          child: Link(
            target: LinkTarget.blank,
            uri: Uri.parse(text),
            builder: (context, followLink) => ElevatedButton(
              onPressed: followLink,
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
