import 'package:flutter/material.dart';

import '../../commons/screen_with_app_bar.dart';

class SymptomDetail extends StatelessWidget {
  const SymptomDetail({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(title: title);
  }
}
