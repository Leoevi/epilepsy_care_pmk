import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

// This is an introduction to write a StatefulWidget class: https://stackoverflow.com/a/72322408

/// A [TextFormField] with hints that is labeled at the top
class LabelTextFormField extends StatefulWidget {
  const LabelTextFormField({
    super.key,
    required this.label,
    this.hintText,
    this.onChanged,
    this.validator,
    this.initialValue,
  });

  /// The label above the [TextFormField]
  final String label;

  final String? hintText;

  /// Callback function that will get executed when the value in the [TextFormField]
  /// is changed
  final Function(String val)? onChanged;

  /// A validator function. In order for this to work, you need to
  /// wrap this widget with a Form ancestor with a key assigned to it
  /// (https://docs.flutter.dev/cookbook/forms/validation)
  final String? Function(String? x)? validator;

  final String? initialValue;

  @override
  State<LabelTextFormField> createState() => _LabelTextFormFieldState();
}

class _LabelTextFormFieldState extends State<LabelTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: kSmallPadding),
        //spacing between label and TextInput
        TextFormField(
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
              hintText: widget.hintText,
              border: const OutlineInputBorder()
          ),
        ),
      ],
    );
  }
}
