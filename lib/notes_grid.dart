import 'package:flutter/material.dart';
import 'package:bookmark/google_sheets_api.dart';
import 'package:bookmark/textbox.dart';

class NotesGrid  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: GoogleSheetsApi.currentNotes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return MyTextBox(text: GoogleSheetsApi.currentNotes[index]); 
        });
  }
}