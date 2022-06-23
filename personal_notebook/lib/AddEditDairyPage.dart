import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DB.dart';
import 'Diary.dart';

class AddEditDairyPage extends StatefulWidget {
  final Diary diary;

  const AddEditDairyPage({Key key, this.diary}) : super(key: key);

  @override
  State<AddEditDairyPage> createState() => _AddEditDairyPageState();
}

class _AddEditDairyPageState extends State<AddEditDairyPage> {
  bool loading = false;
  bool editmode = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  var curDate = DateFormat.yMd().add_jm().format(DateTime.now());
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
    if (widget.diary.id != null) {
      editmode = true;
      titleController.text = widget.diary.title;
      bodyController.text = widget.diary.body;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editmode ? Text("Edit") : Text("Add"),
        actions: <Widget>[
          if (editmode)
            IconButton(
                onPressed: () {
                  delete();
                },
                icon: Icon(Icons.delete)),
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.green,
                          offset: new Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter Title",
                        hintStyle: TextStyle(color: Colors.greenAccent),
                        fillColor: Colors.white30,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.red,
                          offset: new Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: bodyController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Body',
                        labelStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        hintText: "Write here:",
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white30,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: editmode
                              ? Text(
                                  "Update",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Update",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                          // color: Colors.green,
                          onPressed: () {
                            save();
                          },
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          // color: Colors.pink,
                          onPressed: () {
                            delete();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Future<void> save() async {
    if (titleController.text != null) {
      widget.diary.date = curDate;
      widget.diary.title = titleController.text;
      widget.diary.body = bodyController.text;
      if (editmode)
        await DB().update(widget.diary);
      else
        await DB().save(widget.diary);
    }
    print(widget.diary.title);
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }

  Future<void> delete() async {
    await DB().delete(widget.diary);
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }
}
