import 'package:flutter/material.dart';
import 'package:personal_notebook/AddEditDairyPage.dart';
import 'package:personal_notebook/DB.dart';

import 'Diary.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  List<Diary> diaryList;

  Future<void> refreshList() async {
    diaryList = await DB().getDiaryList();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var diaryList;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('NoteBook'),
              IconButton(
                icon: Icon(Icons.add),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 200),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditDairyPage(
                        diary: Diary(),
                      ),
                    ),
                  ).then((value) {
                    refreshList();
                  });
                },
              ),
            ],
          ),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: diaryList.lenght,
                itemBuilder: (context, index) {
                  Diary diary = diaryList[index];
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditDairyPage(
                              diary: Diary(),
                            ),
                          ),
                        ).then((value) {
                          refreshList();
                        });
                      },
                      leading: IconButton(
                        icon: Icon(Icons.view_list),
                        onPressed: () {
                          categoryDialog(context, diary);
                        },
                      ),
                      title: Text(diary.title),
                      subtitle: Text(diary.body),
                      trailing: Text(diary.date),
                    ),
                  );
                }));
  }

  void categoryDialog(BuildContext context, Diary diary) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialogOption(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    diary.body,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "close",
                    style: TextStyle(
                      color: Colors.pink[200],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.pinkAccent,
                )
              ],
            ),
          );
        });
  }
}
