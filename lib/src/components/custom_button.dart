import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed; // Function to be called when the button is pressed
  final String text; // Text displayed on the button
  final Color? backgroundColor; // Background color of the button (optional)
  final Color? textColor;     // Text color of the button (optional)
  final double? fontSize;     // Font size of the button text (optional)
  final double? paddingHorizontal;
  final double? paddingVertical;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.paddingHorizontal,
    this.paddingVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: fontSize, color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? 40,
          vertical: paddingVertical ?? 15,
        ),
        textStyle: const TextStyle(), // Add any default text style
      ),
    );
  }
}