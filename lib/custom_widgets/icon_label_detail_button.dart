import 'package:flutter/material.dart';

class IconLabelDetailButton extends StatelessWidget {
  const IconLabelDetailButton({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(  // Make clickable, (Inkwell for ripple effect, GestureDetector for no effect)
        onTap: () {},
        child: SizedBox(
          height: 100,
          child: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}