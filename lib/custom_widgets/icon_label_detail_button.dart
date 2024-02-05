import 'package:flutter/material.dart';

class IconLabelDetailButton extends StatelessWidget {
  const IconLabelDetailButton({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    const paddingValue = 12.0;  // TODO: make this become a global thing others can use

    return Card(
      child: InkWell(  // Make clickable, (Inkwell for ripple effect, GestureDetector for no effect)
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: SizedBox(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32, // Image radius
                ),
                SizedBox(
                  width: paddingValue,
                ),
                Expanded(  // Wrapping column/row with expanded will allow content to wrap cross-axis direction (https://stackoverflow.com/questions/54634093/flutter-wrap-text-instead-of-overflow/54650374#54650374)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjff Hello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjff Hello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjff"
                      ),
                      Text(
                        "detailsHello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjffHello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjffHello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjffHello Worldlljfakjfla;djfsajfslfjljfasjfdkjflksjf;sa;jjff"
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}