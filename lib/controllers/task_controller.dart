import 'package:get/get.dart';
import 'package:todo_app/database/database_helper.dart';
import 'package:todo_app/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void OnReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  //get all data from the table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
   DBHelper.delete(task);
    
  }
}
