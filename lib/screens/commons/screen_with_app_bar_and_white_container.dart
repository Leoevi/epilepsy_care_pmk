import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

import '../../constants/styling.dart';

class ScreenWithAppbarAndWhiteContainer extends StatelessWidget {
  const ScreenWithAppbarAndWhiteContainer({
    super.key,
    required this.title,
    this.child,
  });

  final String title;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: title,
      body: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: const Padding(
            padding: EdgeInsets.all(kLargePadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
