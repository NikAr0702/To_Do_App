import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todo_app/database/database_helper.dart';
import 'package:todo_app/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void OnReady() {
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }
}
