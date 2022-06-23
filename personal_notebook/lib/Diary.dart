class Diary {
  int id;
  String title, body, date;
  Diary();
  Diary.fromtap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    body = map["body"];
    date = map["date"];
  }
  toMap(){
    return{
      'id':id,
      'title':title,
      'body':body,
      'date':date
    };
  }
}

