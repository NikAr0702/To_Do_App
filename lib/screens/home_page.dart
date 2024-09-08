import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:todo_app/constants/date_bar_slider.dart';
import 'package:todo_app/constants/task_bar.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/theme.dart';
import 'package:todo_app/screens/widgets/task_tile.dart';
import 'package:todo_app/services/notifications_services.dart';
import 'package:todo_app/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.dialogBackgroundColor,
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            children: [
              TaskBar(),
              const SizedBox(height: 16),
              DateBarSlider(),
              const SizedBox(height: 24),
              _showTasks(),
            ],
          ),
        ));
  }

  _showTasks() {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
            itemCount: _taskController.taskList.length,
            // itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyColor : Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: 'Task Completed',
                  onTap: () {
                    Get.back();
                  },
                  color: primaryColor,
                  context: context,
                ),
          _bottomSheetButton(
            label: 'Delete Task',
            onTap: () {
              Get.back();
            },
            color: Colors.red[300]!,
            context: context,
          ),
          const SizedBox(height: 20),
          _bottomSheetButton(
            label: 'Close',
            isClose: true,
            onTap: () {
              Get.back();
            },
            color: Colors.grey[700]!,
            context: context,
          ),
          const SizedBox(height: 16),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.dialogBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: 'Theme Changed',
            body: Get.isDarkMode
                ? 'Activated Light Theme'
                : 'Activated Dark Theme',
          );
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        Icon(Icons.person, size: 20),
        SizedBox(width: 20),
      ],
    );
  }
}
