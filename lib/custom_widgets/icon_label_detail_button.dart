import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

/// A card that is used as a button. It has an icon, a main label
/// and you can describe the details of the button.
///
/// [icon] is the image that will be used as the icon
///
/// [label] is the label for the button
///
/// [detail] is the detail of the button
class IconLabelDetailButton extends StatelessWidget {
  const IconLabelDetailButton({
    super.key,
    this.icon,
    required this.label, // The button must have a header label
    this.detail,
    this.onTap,
  });

  // If we want a member to be nullable, we need to use the ? operator
  final ImageProvider<Object>? icon;
  final String label;
  final String? detail;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      // Prevent ripple effect from rounded corners at a bit of performance cost
      child: InkWell(
        // Make clickable, (Inkwell for ripple effect, GestureDetector for no effect)
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(kLargePadding),
          child: SizedBox(
            child: Row(
              children: [
                CircleAvatar(
                  radius: circleRadius, // Image radius
                  backgroundImage: icon,
                ),
                const SizedBox(
                  width: kMediumPadding,
                ),
                Expanded(
                  // Wrapping column/row with expanded will allow content to wrap cross-axis direction (https://stackoverflow.com/questions/54634093/flutter-wrap-text-instead-of-overflow/54650374#54650374)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: mediumLargeBoldText,
                      ),
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
