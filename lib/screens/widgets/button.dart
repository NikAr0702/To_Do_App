import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryColor,
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
