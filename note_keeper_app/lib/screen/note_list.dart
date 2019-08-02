import 'package:flutter/material.dart';
import 'package:note_keeper_app/screen/note_detail.dart';

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "Add Note",
            backgroundColor: Colors.blue,
            onPressed: () {
              debugPrint("FAB Clicked!");
              navigateToDetail(context, "Add Note");
            }),
        body: NoteListWidget());
  }
}

class NoteListWidget extends StatefulWidget {
  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getNoteListView(),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.account_circle),
              ),
              title: Text("Dummy Title"),
              subtitle: Text("Dummy Date"),
              trailing: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                debugPrint("ListTile Tapped!");
                navigateToDetail(context, "Edit Note");
              },
            ),
          );
        });
  }
}

void navigateToDetail(BuildContext context, String appBarTitle) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return NoteDetail(appBarTitle);
  }));
}
