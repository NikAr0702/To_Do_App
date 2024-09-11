import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 2;
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
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER, completedAt STRING, createdAt STRING, updatedAt STRING, priority STRING)',
          );
        },
        onUpgrade: (db, oldVersion, newVersion) {
          if (oldVersion < 2) {
            db.execute("ALTER TABLE $_tableName ADD COLUMN priority STRING");
          }
        },
      );
    } catch (e) {
      Get.snackbar('initDb', 'DB ERROR');
    }
  }

  // Insert function now includes the priority field
  static Future<int> insert(Task task) async {
    try {
      return await _database!.insert(_tableName, task.toJson());
    } catch (e) {
      Get.snackbar('insert', 'DB ERROR');
      return 0;
    }
  }

  // Query all tasks
  static Future<List<Map<String, dynamic>>> query() async {
    try {
      return await _database!.query(_tableName);
    } catch (e) {
      Get.snackbar('query', 'DB ERROR');
      return [];
    }
  }

  // Delete a task by ID
  static Future<int> delete(int id) async {
    try {
      return await _database!.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Get.snackbar('delete', 'DB ERROR');
      return 0;
    }
  }

  // Update task completion status
  static updateTask(int id, bool isCompleted) async {
    int isComplete = isCompleted ? 1 : 0;
    try {
      return await _database!.rawUpdate('''
      UPDATE $_tableName 
      SET isCompleted = ?, completedAt = ?
      WHERE id = ?
    ''', [isComplete, DateTime.now().toIso8601String(), id]);
    } catch (e) {
      Get.snackbar('updateTask', 'DB ERROR');
      return 0;
    }
  }

  static Future<int> updateTaskInfo(Task task) async {
    try {
      return await _database!.rawUpdate(
        '''
      UPDATE $_tableName
      SET title = ?, note = ?, date = ?, startTime = ?, endTime = ?, remind = ?, repeat = ?, color = ?, isCompleted = ?, createdAt = ?, updatedAt = ?, completedAt = ?, priority = ?
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
          task.priority,
          task.id
        ],
      );
    } catch (e) {
      Get.snackbar('updateTaskInfo', 'DB ERROR');
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> searchTasks(String query) async {
    try {
      return await _database!.query(
        _tableName,
        where: 'title LIKE ? OR note LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
    } catch (e) {
      Get.snackbar('searchTasks', 'DB ERROR');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getTasksByPriority(
      String priority) async {
    try {
      return await _database!.query(
        _tableName,
        where: 'priority = ?',
        whereArgs: [priority],
      );
    } catch (e) {
      Get.snackbar('getTasksByPriority', 'DB ERROR');
      return [];
    }
  }
}
