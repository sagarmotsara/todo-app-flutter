
import 'package:intl/date_symbol_data_file.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/backend/model.dart';

class DataBaseHelper{
  static final DataBaseHelper instance = DataBaseHelper._createInstance();
  static Database _db;
  DataBaseHelper._createInstance();

  String colId = 'id';
  String colTitle = 'title';
  String colPriority = 'priority';
  String colDate = 'date';
  String tasksTable = 'todo_table';
  String colStatus = 'status';


  Future<Database> get db async {
        if(_db ==null){
          _db = await initializeDatabase();
        }
        return _db;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todos.db';

    final todosDatabaseList = await openDatabase(path, version:1, onCreate: _createDb);
    return todosDatabaseList;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
    'CREATE TABLE $tasksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT, $colPriority TEXT , $colDate TEXT, $colStatus INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db; 
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    Database db = await this.db;
    final List<Map<String , dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList =[];
    taskMapList.forEach((taskMap) {
     taskList.add(Task.fromMap(taskMap));
     });
     taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
      return taskList;
  }

  Future<int> insertTask(Task task) async{
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async{
    Database db = await this.db;
    final int result = await db.update(tasksTable, task.toMap(), where: '$colId =?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async{
    Database db = await this.db;
    final int result = await db.delete(tasksTable , where: '$colId =?', whereArgs: [id]);
    return result;
  }
  
}