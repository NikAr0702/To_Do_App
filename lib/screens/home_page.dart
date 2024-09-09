import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  DateTime _selectedDate = DateTime.now();
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
              // DateBarSlider(),
              _showDateBar(),
              const SizedBox(height: 24),
              _showTasks(),
            ],
          ),
        ));
  }

  // _showTasks() {
  //   return Obx(() {
  //     return Expanded(
  //       child: ListView.builder(
  //           itemCount: _taskController.taskList.length,
  //           // itemCount: 10,
  //           shrinkWrap: true,
  //           itemBuilder: (_, index) {
  //             // print(_taskController.taskList.length);
  //             Task task = _taskController.taskList[index];
  //             // print(task.toJson());

  //             if (task.repeat == 'Daily') {
  //               DateTime date =
  //                   DateFormat.jm().parse(task.startTime.toString());
  //               var myTime = DateFormat("HH:mm").format(date);
  //               // print(myTime);

  //               notifyHelper.scheduledNotification(
  //                 int.parse(myTime.toString().split(':')[0]),
  //                 int.parse(myTime.toString().split(':')[1]),
  //                 task,
  //               );
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 10),
  //                 child: AnimationConfiguration.staggeredList(
  //                   position: index,
  //                   child: SlideAnimation(
  //                     child: FadeInAnimation(
  //                       child: Row(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () {
  //                               _showBottomSheet(context, task);
  //                             },
  //                             child: TaskTile(task),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }
  //             if (task.date == DateFormat.yMd().format(_selectedDate)) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 10),
  //                 child: AnimationConfiguration.staggeredList(
  //                   position: index,
  //                   child: SlideAnimation(
  //                     child: FadeInAnimation(
  //                       child: Row(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () {
  //                               _showBottomSheet(context, task);
  //                             },
  //                             child: TaskTile(task),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             } else {
  //               return Container();
  //             }
  //           }),
  //     );
  //   });
  // }

  // _showTasks() {
  //   return Obx(() {
  //     return Expanded(
  //       child: ListView.builder(
  //         itemCount: _taskController.taskList.length,
  //         shrinkWrap: true,
  //         itemBuilder: (_, index) {
  //           Task task = _taskController.taskList[index];

  //           DateTime date = _parseDateTime(task.startTime.toString());
  //           var myTime = DateFormat.Hm().format(date);

  //           var remind = DateFormat.Hm()
  //               .format(date.subtract(Duration(minutes: task.remind!)));

  //           if (task.repeat == 'Daily') {
  //             try {
  //               notifyHelper.scheduledNotification(
  //                 int.parse(myTime.toString().split(":")[0]), //hour
  //                 int.parse(myTime.toString().split(":")[1]), //minute
  //                 task,
  //               );

  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 10),
  //                 child: AnimationConfiguration.staggeredList(
  //                   position: index,
  //                   child: SlideAnimation(
  //                     child: FadeInAnimation(
  //                       child: Row(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () {
  //                               _showBottomSheet(context, task);
  //                             },
  //                             child: TaskTile(task),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             } catch (e) {
  //               print("Error parsing start time: $e");
  //               return Container(); // Skip this task if there's an error
  //             }
  //           }

  //           if (task.date == DateFormat('MM/dd/yyyy').format(_selectedDate)) {
  //             notifyHelper.scheduledNotification(
  //               int.parse(myTime.toString().split(":")[0]), //hour
  //               int.parse(myTime.toString().split(":")[1]), //minute
  //               task,
  //             );

  //             return Padding(
  //               padding: const EdgeInsets.only(bottom: 10),
  //               child: AnimationConfiguration.staggeredList(
  //                 position: index,
  //                 child: SlideAnimation(
  //                   child: FadeInAnimation(
  //                     child: Row(
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             _showBottomSheet(context, task);
  //                           },
  //                           child: TaskTile(task),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           } else {
  //             return Container();
  //           }
  //         },
  //       ),
  //     );
  //   });
  // }

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

  //           if (task.repeat == "None" &&
  //               task.date == DateFormat('MM/dd/yyyy').format(_selectedDate)) {
  //             // Schedule notification if needed
  //             notifyHelper.scheduledNotification(
  //               int.parse(myTime.toString().split(":")[0]), // hour
  //               int.parse(myTime.toString().split(":")[1]), // minute
  //               task,
  //             );

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
  //                         child: TaskTile(task),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }

  //           if (task.repeat == "Daily") {
  //             notifyHelper.scheduledNotification(
  //               int.parse(myTime.toString().split(":")[0]), //hour
  //               int.parse(myTime.toString().split(":")[1]), //minute
  //               task,
  //             );

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
  //                         child: TaskTile(task),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           } else if (task.date ==
  //               DateFormat('MM/dd/yyyy').format(_selectedDate)) {
  //             notifyHelper.scheduledNotification(
  //               int.parse(myTime.toString().split(":")[0]), //hour
  //               int.parse(myTime.toString().split(":")[1]), //minute
  //               task,
  //             );

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
  //           } else if (task.repeat == "Weekly" &&
  //               DateFormat('EEEE').format(_selectedDate) ==
  //                   DateFormat('EEEE').format(DateTime.now())) {
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
  //                         child: TaskTile(task),
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
  //                         child: TaskTile(task),
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

            // Handle the "None" repeat option
            if (task.repeat == "None" &&
                task.date == DateFormat('MM/dd/yyyy').format(_selectedDate)) {
              // Schedule notification if needed
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), // hour
                int.parse(myTime.toString().split(":")[1]), // minute
                task,
              );

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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.repeat == "Daily") {
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), // hour
                int.parse(myTime.toString().split(":")[1]), // minute
                task,
              );

              // Update if daily task is completed to reset it every 11:59 pm if not completed
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
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.date ==
                DateFormat('MM/dd/yyyy').format(_selectedDate)) {
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), // hour
                int.parse(myTime.toString().split(":")[1]), // minute
                task,
              );

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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.repeat == "Weekly" &&
                DateFormat('EEEE').format(_selectedDate) ==
                    DateFormat('EEEE').format(DateTime.now())) {
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
                        ),
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
                        ),
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
                    _taskController.markTaskAsCompleted(task.id!, false);
                    Get.back();
                  },
                  color: primaryColor,
                  context: context,
                ),
          _bottomSheetButton(
            label: 'Delete Task',
            onTap: () {
              _taskController.deleteTask(task.id!);

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

  _showDateBar() {
    return SizedBox(
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
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
}
