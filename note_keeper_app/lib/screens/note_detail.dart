import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  static var _priorities = ["High", "Low"];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailState(this.note, this.appBarTitle);

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: () {
        /* Write some code to control things, when user press Back navigation button in device */
        moveToLastScreen(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen(context);
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                // =========== First Element ===========
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(note.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint("User selected $valueSelectedByUser");
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),
                // =========== Second Element ===========
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: titleController,
                    style: textStyle,
                    // onSaved: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Title is not Emty!";
                      } else {
                        debugPrint("Something changed in Title TextFormField");
                        updateTitle();
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                // =========== Third Element ===========
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    style: textStyle,
                    // onSaved: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Description is not Emty!";
                      } else {
                        debugPrint(
                            "Something changed in Description TextFormField");
                        updateDescription();
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                // =========== Four Element ===========
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_formKey.currentState.validate()) {
                                    debugPrint("Save button clicked");
                                    _save();
                                  }
                                });
                              })),
                      Container(
                        width: 10.0,
                      ),
                      Expanded(
                          child: RaisedButton(
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint("Delete button clicked");
                                  _delete();
                                });
                              })),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
      default:
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // "High"
        break;
      case 2:
        priority = _priorities[1]; // "Low"
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen(context);

    note.date = DateFormat.yMMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlterDialog("Status", "Note Saved Successfully");
    } else {
      // Failure
      _showAlterDialog("Status", "Problem Saving Note");
    }
  }

  void _delete() async {
    moveToLastScreen(context);

    // Case 1: If user is trying to delete the NEW NOTE
    // i.e. he has come to the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlterDialog("Status", "No Note was deleted");
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlterDialog("Status", "Note Deleted Successfully");
    } else {
      _showAlterDialog("Status", "Error Occured while Deleting Note");
    }
  }

  void _showAlterDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

void moveToLastScreen(BuildContext context) {
  Navigator.pop(context, true);
}
