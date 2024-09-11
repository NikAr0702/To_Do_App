
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'tasks';
  static const String _dbName = 'todo.db';

  static Future<void> initDb() async {
    if (_database != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + _dbName;

      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER, completedAt STRING, createdAt STRING, updatedAt STRING)',
          );
        },
      );
    } catch (e) {
      // Handle exception here
    }
  }

  static Future<int> insert(Task task) async {
    try {
      return await _database!.insert(_tableName, task.toJson());
    } catch (e) {
      // Handle exception here
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    try {
      return await _database!.query(_tableName);
    } catch (e) {
      // Handle exception here
      return [];
    }
  }

  static Future<int> delete(int id) async {
    try {
      return await _database!.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // Handle exception here
      return 0;
    }
  }

  static updateTask(int id, bool isCompleted) async {
    int isComplete = isCompleted ? 1 : 0;
    try {
      return await _database!.rawUpdate('''
      UPDATE $_tableName 
      SET isCompleted = ?, completedAt = ?
      WHERE id = ?
    ''', [isComplete, DateTime.now().toIso8601String(), id]);
    } catch (e) {
      // Handle exception here
      return 0;
    }
  }

  static Future<int> updateTaskInfo(Task task) async {
    try {
      return await _database!.rawUpdate(
        '''
      UPDATE $_tableName
      SET title = ?, note = ?, date = ?, startTime = ?, endTime = ?, remind = ?, repeat = ?, color = ?, isCompleted = ?, createdAt = ?, updatedAt = ?, completedAt = ?
      WHERE id = ?
      ''',
        [
          task.title,
          task.note,
          task.date,
          task.startTime,
          task.endTime,
          task.remind,
          task.repeat,
          task.color,
          task.isCompleted,
          task.createdAt,
          task.updatedAt,
          task.completedAt,
          task.id
        ],
      );
    } catch (e) {
      // Handle exception here
      return 0;
    }
  }

  // New search function
  static Future<List<Map<String, dynamic>>> searchTasks(String query) async {
    try {
      return await _database!.query(
        _tableName,
        where: 'title LIKE ? OR note LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
    } catch (e) {
      // Handle exception here
      return [];
    }
  }
}
