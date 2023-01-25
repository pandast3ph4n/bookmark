import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookmark/loading_circle.dart';
import 'package:bookmark/notes_grid.dart';
import 'package:bookmark/textbox.dart';
import 'buttons.dart';
import 'google_sheets_api.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _post() {
    GoogleSheetsApi.insert(_controller.text);
    _controller.clear();
    setState(() {});
  }


    // wait for the data to be fetched from google sheets
  void startLoading() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  } 

  @override
  Widget build(BuildContext context) {

    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true) {
      startLoading();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('B O O K M A R K', 
        style: GoogleFonts.rowdies(
                textStyle: const TextStyle(color: Colors.white,),),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
        ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(child: Container(
            child: GoogleSheetsApi.loading == true ? LoadingCircle() : NotesGrid(),),),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'enter link..',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                        },
                      )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('@ c r e a t e d b y g a r g o y l e'),
                    ),
                    MyButton(
                      text: 'B O O K M A R K',
                      function: _post,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }
}