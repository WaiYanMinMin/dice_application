import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MainButtonWidget extends StatefulWidget {
  Color? color;
  String buttonText;
  Function onPressedFunction;
  double width;
  double height;
  double buttonTextFontSize;
  MainButtonWidget(
      {Key? key,
      this.color,
      required this.onPressedFunction,
      required this.buttonText,
      required this.width,
      required this.height,
      required this.buttonTextFontSize})
      : super(key: key);

  @override
  State<MainButtonWidget> createState() => _MainButtonWidgetState();
}

class _MainButtonWidgetState extends State<MainButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      onTap: () => {
        
        widget.onPressedFunction(),
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.color,
        ),
        height: widget.height,
        width: widget.width,
        child: Center(
          child: Text(
            widget.buttonText,
            style: GoogleFonts.armata(
              color: Colors.white,
              fontSize: widget.buttonTextFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
