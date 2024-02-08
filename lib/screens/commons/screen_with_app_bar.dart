import 'package:flutter/material.dart';

/// A full screen page with the app bar at the top
/// This is intend to be full screen and is not to be used
/// with bottom navigation bar
class ScreenWithAppBar extends StatelessWidget {
  const ScreenWithAppBar({
    super.key,
    required this.title,
    this.body,
    this.actions,
  });

  final String title;
  final Widget? body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      // To have a gradient background, need to wrap with container
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFCA80F7),
                Color(0x7FCA80F7)
              ] // TODO: use colors from theme instead of hardcoding
          )),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        backgroundColor: Colors.transparent,
        body: body,
      ),
    );
  }
}
