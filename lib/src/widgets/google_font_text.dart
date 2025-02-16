import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleFontText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const GoogleFontText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.vazirmatn(
        textStyle:
            style ?? TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }
}
