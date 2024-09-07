import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/input_text_field.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/theme.dart';
import 'package:todo_app/screens/widgets/button.dart';

class AddTaskBarPage extends StatefulWidget {
  const AddTaskBarPage({super.key});

  @override
  State<AddTaskBarPage> createState() => _AddTaskBarPageState();
}

class _AddTaskBarPageState extends State<AddTaskBarPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20, 25];

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.dialogBackgroundColor,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task', style: headingStyle),
              const SizedBox(height: 14),
              MyInputTextField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              const SizedBox(height: 14),
              MyInputTextField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              const SizedBox(height: 14),
              MyInputTextField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.grey,
                    )),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: MyInputTextField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(Icons.access_time_rounded,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: MyInputTextField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(Icons.access_time_rounded,
                            color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 14),
              MyInputTextField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  underline: Container(height: 0),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue ?? '');
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ),
                  iconSize: 32,
                  elevation: 2,
                  style: subTitleStyle,
                  dropdownColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              MyInputTextField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  underline: Container(height: 0),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRepeat = newValue ?? '';
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ),
                  iconSize: 32,
                  elevation: 2,
                  style: subTitleStyle,
                  dropdownColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(
                      label: 'Create Task',
                      onTap: () {
                        _validateDate();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDataBase();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All fields are required',
          borderRadius: 10,
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff4e5ae8),
          icon: const Icon(Icons.warning_amber_rounded));
    }
  }

  _addTaskToDataBase() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print('My ID is ' + '$value');
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(5, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                          ? pinkColor
                          : index == 2
                              ? yellowishColor
                              : index == 3
                                  ? darkHeaderColor
                                  : orangeColor,
                  child: _selectedColor == index
                      ? const Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.dialogBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2045),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print("It's null or Something went wrong!");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time is not chosen by user');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
