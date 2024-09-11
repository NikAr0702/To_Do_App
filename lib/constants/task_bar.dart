import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/screens/theme.dart';
import 'package:todo_app/screens/widgets/add_task_bar_page.dart';
import 'package:todo_app/screens/widgets/button.dart';

class TaskBar extends StatelessWidget {
  final _taskController = Get.put(TaskController());
  TaskBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              'Today',
              style: headingStyle,
              // style: TextStyle(
              //   color: Get.isDarkMode ? Colors.white : Colors.black,
              //   fontSize: 28,
              //   fontWeight: FontWeight.bold,
              // ),
            ),
          ],
        ),
        MyButton(
          label: '+ Add Task',
          onTap: () async {
            await Get.to(() => const AddTaskBarPage());
            _taskController.getTasks();
            print('_taskController.getTasks();');
          },
        )
      ],
    );
  }
}
