import 'package:epilepsy_care_pmk/constants/padding_values.dart';
import 'package:flutter/material.dart';

// A card that is used as a button for
class IconLabelDetailButton extends StatelessWidget {
  const IconLabelDetailButton({
    super.key,
    this.icon,
    required this.label,  // The button must have a header label
    this.detail,
  });

  // If we want a member to be nullable, we need to use the ? operator
  final Widget? icon;
  final String label;
  final String? detail;

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
                  radius: 32,  // Image radius
                  child: icon,
                ),
                const SizedBox(
                  width: kMediumPadding,
                ),
                Expanded(  // Wrapping column/row with expanded will allow content to wrap cross-axis direction (https://stackoverflow.com/questions/54634093/flutter-wrap-text-instead-of-overflow/54650374#54650374)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label),
                      // https://stackoverflow.com/questions/54387599/how-to-fix-text-is-null-in-flutter
                      if (detail != null) Text(detail!),
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