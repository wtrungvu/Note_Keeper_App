import 'package:flutter/material.dart';
import 'package:note_keeper_app/screen/note_detail.dart';
import 'package:note_keeper_app/screen/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoteKeeper",
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: NoteList(),
      // home: NoteDetail(),
    );
  }
}
