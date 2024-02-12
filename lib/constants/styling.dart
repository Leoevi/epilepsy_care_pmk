// Values for used in various widgets.
// This is to keep the the design uniform throughout the app
// There doesn't seem to be many alternatives, and from what I have
// looked at other apps, padding seems to also be just hardcoded in.
// (https://stackoverflow.com/questions/61961988/how-do-i-store-my-default-padding-in-theme-of-in-flutter)

// Initially, I wanted to create a class of constants, but that seemed
// like it was not a good practice (https://stackoverflow.com/a/64795039)
// So we will just declare them at the top level like so
import 'package:flutter/material.dart';

const double kSmallPadding = 8.0;
const double kMediumPadding = 12.0;
const double kLargePadding = 16.0;

const double kSmallRoundedCornerRadius = 8.0;
const double kMediumRoundedCornerRadius = 12.0;

//style: purpleButton
ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 201, 128, 247), //Color(0x7FCA80F7)
    padding: EdgeInsets.all(20),
    fixedSize: Size.fromWidth(140),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));

const String indent = "\t\t\t\t";

const TextStyle mediumLargeBoldText =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

const double circleRadius = 32;
