import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/theme.dart';

class MyInputTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputTextField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 10),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              widget == null ? Container() : Container(child: widget),
            ],
          ),
        )
      ],
    );
  }
}
