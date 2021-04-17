
class Task {
  int id;
  String title;
  String priority;
  DateTime date;
  int status;

  Task({this.date, this.priority, this.title, this.status});

  Task.withId({this.id, this.date, this.priority, this.title, this.status});

  Map <String, dynamic> toMap(){
     var map = Map<String, dynamic>();

     if(id !=null){
       map['id'] = id;
     }
     map['title'] = title;
     map['priority'] = priority;
     map['date'] = date.toIso8601String();
     map['status'] = status;

     return map;
  }
  
  factory Task.fromMap(Map<String ,dynamic> map){
      return Task.withId(
       id: map['id'],
       title: map['title'],
       date: DateTime.parse(map['date']),
       priority: map['priority'],
       status: map['status'],
      );

}}