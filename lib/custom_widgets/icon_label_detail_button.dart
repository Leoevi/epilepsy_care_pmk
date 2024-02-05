import 'package:epilepsy_care_pmk/constants/padding_values.dart';
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
      clipBehavior: Clip.hardEdge,  // Prevent ripple effect from rounded corners at a bit of performance cost
      child: InkWell(  // Make clickable, (Inkwell for ripple effect, GestureDetector for no effect)
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(kMediumPadding),
          child: SizedBox(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32, // Image radius
                ),
                SizedBox(
                  width: kMediumPadding,
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