import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/constants/date_bar_slider.dart';
import 'package:todo_app/constants/task_bar.dart';
import 'package:todo_app/services/notifications_services.dart';
import 'package:todo_app/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const TaskBar(),
              const SizedBox(height: 16),
              DateBarSlider(),
            ],
          ),
        ));
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
