// Values for used in various widgets.
// This is to keep the the design uniform throughout the app
// There doesn't seem to be many alternatives, and from what I have
// looked at other apps, padding seems to also be just hardcoded in.
// (https://stackoverflow.com/questions/61961988/how-do-i-store-my-default-padding-in-theme-of-in-flutter)

// Initially, I wanted to create a class of constants, but that seemed
// like it was not a good practice (https://stackoverflow.com/a/64795039)
// So we will just declare them at the top level like so
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double kSmallPadding = 8.0;
const double kMediumPadding = 12.0;
const double kLargePadding = 16.0;

const double kSmallRoundedCornerRadius = 8.0;
const double kMediumRoundedCornerRadius = 12.0;

ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 201, 128, 247), //Color(0x7FCA80F7)
    // padding: EdgeInsets.all(0),
    fixedSize: const Size.fromWidth(140),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));

ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    side: const BorderSide(color: Color.fromARGB(255, 201, 128, 247)),
    // padding: EdgeInsets.all(20),
    fixedSize: const Size.fromWidth(140),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));

/// A value that is used as indent in paragraph text, mainly in the wiki page
const String indent = "\t\t\t\t";

const TextStyle mediumLargeBoldText =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

/// TextStyle that tries to mimic the usual error style, in case if
/// [Theme.of(context).inputDecorationTheme.errorStyle] is null.
TextStyle errorStyle = TextStyle(fontSize: 14, color: Colors.red[700]);

const double kCircleRadius = 32;

/// A decoration intend to be used by containers wrapping scaffolds
/// of many screens in the app, this is to give a gradient background
const baseBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
      Color(0xFFFFCEFE),
      Color(0xFFFDEBED),
      Color(0xFFFFCEFE)
    ] // TODO: use colors from theme instead of hardcoding
        ));

/// A decoration intend to be used by containers wrapping scaffold
/// of the register screen, this is to give a gradient background
const splashBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
      Color(0xFFFFCEFE),
      Color(0xFFFDEBED),
      Color(0xFFFFCEFE)
    ] // TODO: use colors from theme instead of hardcoding
        ));

/// Used for formatting DateTime objects to what we want instead of the usual
/// "dd-MM-yyyy hh:mm:ssss" default formatting.
///
/// Also used in pdf export since it had trouble display non-English characters.
DateFormat dateDateFormat = DateFormat("yyyy-MM-dd");
DateFormat dateTimeDateFormat = DateFormat("yyyy-MM-dd – kk:mm");

/// Locale of the app, used for formatting DateTime objects (intl).
const String locale = "th_TH";

/// A picture that is used if the user doesn't set their profile picture
const profilePlaceholder = AssetImage("image/profile_placeholder.png");

/// Duration that is used for animations
const Duration animationDuration = Duration(milliseconds: 250);