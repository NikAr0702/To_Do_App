import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/date_bar_slider.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/theme.dart';
import 'package:todo_app/screens/widgets/add_task_bar_page.dart';
import 'package:todo_app/screens/widgets/button.dart';
import 'package:todo_app/screens/widgets/task_tile.dart';
import 'package:todo_app/services/notifications_services.dart';
import 'package:todo_app/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? width;
  double? height;

  // ignore: prefer_typing_uninitialized_variables
  var notifyHelper;

  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();

    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestAndroidPermissions();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            _addTaskBar(),
            const SizedBox(height: 12),
            // _dateBar(),
            DateBarSlider(),
            const SizedBox(height: 16),
            _showTasks(),
          ],
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
          // notifyHelper.scheduledNotification();
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

  _addTaskBar() {
    return Container(
      // margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("EEE, d MMM yyyy").format(DateTime.now()),
                style: subHeadingStyle.copyWith(fontSize: width! * .049),
              ),
              Text(
                "Today",
                style: headingStyle.copyWith(fontSize: width! * .06),
              )
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskBarPage());
              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 125,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          // New date selected
          setState(() {
            _selectedDate = date;
          });
        },
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: width! * 0.039,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: width! * 0.037,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: width! * 0.030,
            fontWeight: FontWeight.normal,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // _showTasks() {
  //   return Expanded(
  //     child: Obx(() {
  //       return ListView.builder(
  //         itemCount: _taskController.taskList.length,
  //         itemBuilder: (_, index) {
  //           Task task = _taskController.taskList[index];

  //           DateTime date = _parseDateTime(task.startTime.toString());
  //           var myTime = DateFormat.Hm().format(date);

  //           var remind = DateFormat.Hm()
  //               .format(date.subtract(Duration(minutes: task.remind!)));

  //           int mainTaskNotificationId = task.id!.toInt();
  //           int reminderNotificationId = mainTaskNotificationId + 1;

  //           if (task.repeat == "Daily") {
  //             if (task.remind! > 4) {
  //               notifyHelper.remindNotification(
  //                 int.parse(remind.toString().split(":")[0]), //hour
  //                 int.parse(remind.toString().split(":")[1]), //minute
  //                 task,
  //               );
  //               notifyHelper.cancelNotification(reminderNotificationId);
  //             }
  //             notifyHelper.scheduledNotification(
  //               int.parse(myTime.toString().split(":")[0]), //hour
  //               int.parse(myTime.toString().split(":")[1]), //minute
  //               task,
  //             );
  //             notifyHelper.cancelNotification(reminderNotificationId);

  //             // update if daily task is completed to reset it every 11:59 pm is not completed
  //             if (DateTime.now().hour == 23 && DateTime.now().minute == 59) {
  //               _taskController.markTaskAsCompleted(task.id!, false);
  //             }

  //             return AnimationConfiguration.staggeredList(
  //               position: index,
  //               child: SlideAnimation(
  //                 child: FadeInAnimation(
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           _showBottomSheet(context, task);
  //                         },
  //                         onLongPress: () {
  //                           HapticFeedback.mediumImpact();
  //                           Get.to(
  //                             () => AddTaskBarPage(task: task),
  //                           );
  //                         },
  //                         child: TaskTile(task),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           } else if (task.date ==
  //               DateFormat('MM/dd/yyyy').format(_selectedDate)) {
  //             if (task.remind! > 0) {
  //               notifyHelper.remindNotification(
  //                 int.parse(remind.toString().split(":")[0]), //hour
  //                 int.parse(remind.toString().split(":")[1]), //minute
  //                 task,
  //               );
  //               notifyHelper.cancelNotification(reminderNotificationId);
  //             }
  //             notifyHelper.scheduledNotification(
  //               int.parse(myTime.toString().split(":")[0]), //hour
  //               int.parse(myTime.toString().split(":")[1]), //minute
  //               task,
  //             );
  //             notifyHelper.cancelNotification(reminderNotificationId);

  //             return AnimationConfiguration.staggeredList(
  //               position: index,
  //               child: SlideAnimation(
  //                 child: FadeInAnimation(
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           _showBottomSheet(context, task);
  //                         },
  //                         child: TaskTile(
  //                           task,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //           // else if (task.repeat == "Weekly" &&
  //           //     DateFormat('EEEE').format(_selectedDate) ==
  //           //         DateFormat('EEEE').format(DateTime.now()))
  //           else if (task.repeat == "Weekly") {
  //             return AnimationConfiguration.staggeredList(
  //               position: index,
  //               child: SlideAnimation(
  //                 child: FadeInAnimation(
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           _showBottomSheet(context, task);
  //                         },
  //                         child: TaskTile(
  //                           task,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           } else if (task.repeat == "Monthly" &&
  //               DateFormat('dd').format(_selectedDate) ==
  //                   DateFormat('dd').format(DateTime.now())) {
  //             return AnimationConfiguration.staggeredList(
  //               position: index,
  //               child: SlideAnimation(
  //                 child: FadeInAnimation(
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           _showBottomSheet(context, task);
  //                         },
  //                         child: TaskTile(
  //                           task,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           } else {
  //             return Container();
  //           }
  //         },
  //       );
  //     }),
  //   );
  // }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];

            DateTime date = _parseDateTime(task.startTime.toString());
            var myTime = DateFormat.Hm().format(date);

            var remind = DateFormat.Hm()
                .format(date.subtract(Duration(minutes: task.remind!)));

            int mainTaskNotificationId = task.id!.toInt();
            int reminderNotificationId = mainTaskNotificationId + 1;

            if (task.repeat == "Daily") {
              // print("Selected Date: ${_selectedDate}");
              // print("Task Repeat: ${task.repeat}");
              // print("Task Date: ${task.date}");
              if (task.remind! > 4) {
                notifyHelper.remindNotification(
                  int.parse(remind.toString().split(":")[0]), // hour
                  int.parse(remind.toString().split(":")[1]), // minute
                  task,
                );
                notifyHelper.cancelNotification(reminderNotificationId);
              }
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), // hour
                int.parse(myTime.toString().split(":")[1]), // minute
                task,
              );
              notifyHelper.cancelNotification(reminderNotificationId);

              if (DateTime.now().hour == 23 && DateTime.now().minute == 59) {
                _taskController.markTaskAsCompleted(task.id!, false);
              }

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          onLongPress: () {
                            HapticFeedback.mediumImpact();
                            Get.to(
                              () => AddTaskBarPage(task: task),
                            );
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.date ==
                DateFormat('MM/dd/yyyy').format(_selectedDate)) {
              if (task.remind! > 0) {
                notifyHelper.remindNotification(
                  int.parse(remind.toString().split(":")[0]), // hour
                  int.parse(remind.toString().split(":")[1]), // minute
                  task,
                );
                notifyHelper.cancelNotification(reminderNotificationId);
              }
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), // hour
                int.parse(myTime.toString().split(":")[1]), // minute
                task,
              );
              notifyHelper.cancelNotification(reminderNotificationId);

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.repeat == "Weekly" &&
                DateFormat('EEEE').format(_selectedDate) ==
                    DateFormat('EEEE').format(DateTime.now())) {
              // print("Selected Date: ${_selectedDate}");
              // print("Task Repeat: ${task.repeat}");
              // print("Task Date: ${task.date}");
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.repeat == "Monthly" &&
                DateFormat('dd').format(_selectedDate) ==
                    DateFormat('dd').format(DateTime.now())) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  DateTime _parseDateTime(String timeString) {
    // Split the timeString into components (hour, minute, period)
    List<String> components = timeString.split(' ');

    // Extract and parse the hour and minute
    List<String> timeComponents = components[0].split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // If the time string contains a period (AM or PM),
    //adjust the hour for 12-hour format
    if (components.length > 1) {
      String period = components[1];
      if (period.toLowerCase() == 'pm' && hour < 12) {
        hour += 12;
      } else if (period.toLowerCase() == 'am' && hour == 12) {
        hour = 0;
      }
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.35
            : MediaQuery.of(context).size.height * 0.4,
        color: Get.isDarkMode ? darkGreyColor : Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 4),
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            _bottomSheetButton(
              label: " Update Task",
              color: Colors.green[400]!,
              onTap: () {
                Get.back();
                Get.to(() => AddTaskBarPage(task: task));
              },
              context: context,
              icon: Icons.update,
            ),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Task Completed",
                    color: primaryColor,
                    onTap: () {
                      Get.back();
                      _taskController.markTaskAsCompleted(task.id!, true);
                      _taskController.getTasks();
                    },
                    context: context,
                    icon: Icons.check,
                  ),
            _bottomSheetButton(
              label: "Delete Task",
              color: Colors.red[400]!,
              onTap: () {
                Get.back();
                showDialog(
                    context: context,
                    builder: (_) => _alertDialogBox(context, task));
                // _taskController.deleteTask(task.id!);
              },
              context: context,
              icon: Icons.delete,
            ),
            const SizedBox(height: 15),
            _bottomSheetButton(
              label: "Close",
              color: Colors.red[400]!.withOpacity(0.5),
              isClose: true,
              onTap: () {
                Get.back();
              },
              context: context,
              icon: Icons.close,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  _alertDialogBox(BuildContext context, Task task) {
    return AlertDialog(
      backgroundColor: context.theme.colorScheme.surface,
      icon: const Icon(Icons.warning, color: Colors.red),
      title: Text("Are you sure you want to delete?", style: subHeadingStyle),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Get.back();
              _taskController.deleteTask(task.id!);
              // Cancel delete notification
              if (task.remind! > 4) {
                notifyHelper.cancelNotification(task.id! + 1);
              }
              _showTasks();
            },
            child: const SizedBox(
              width: 60,
              child: Text(
                "Yes",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Get.back();
            },
            child: const SizedBox(
              width: 60,
              child: Text(
                "No",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required BuildContext context,
      required Color color,
      required Function()? onTap,
      IconData? icon,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 7),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,

        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[700]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: isClose
                        ? Get.isDarkMode
                            ? Colors.white
                            : Colors.black
                        : Colors.white,
                    size: 30,
                  )
                : const SizedBox(),
            Text(
              label,
              style: titleStyle.copyWith(
                fontSize: 18,
                color: isClose
                    ? Get.isDarkMode
                        ? Colors.white
                        : Colors.black
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Task> getTasksCompletedToday(List<Task> taskList) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return taskList.where((task) {
      if (task.completedAt == null) {
        return false;
      }

      DateTime completedDate = DateTime.parse(task.completedAt!);
      completedDate = DateTime(
        completedDate.year,
        completedDate.month,
        completedDate.day,
      );

      return completedDate == today;
    }).toList();
  }
}
