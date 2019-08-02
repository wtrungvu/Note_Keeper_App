import 'package:flutter/material.dart';

class NoteDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
      ),
      body: NoteDetailWidget(),
    );
  }
}

class NoteDetailWidget extends StatefulWidget {
  @override
  _NoteDetailWidgetState createState() => _NoteDetailWidgetState();
}

class _NoteDetailWidgetState extends State<NoteDetailWidget> {
  var _priorities = ["Low", "Hight"];
  var _currentItemSelected = "Low";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          // First Element
          ListTile(
            title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,
                value: _currentItemSelected,
                onChanged: (valueItemSelected) {
                  setState(() {
                    debugPrint("User selected ${valueItemSelected}");
                  });
                }),
          ),
          // Second Element
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value) {
                debugPrint("Something changed in Title TextField");
              },
              decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          // Third Element
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              style: textStyle,
              onChanged: (value) {
                debugPrint("Something changed in Description TextField");
              },
              decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          // Four Element
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
                            debugPrint("Save button clicked");
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
                          });
                        })),
              ],
            ),
          )
        ],
      ),
    );
  }
}
