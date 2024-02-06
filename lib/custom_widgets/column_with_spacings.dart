import 'package:flutter/material.dart';

/// Column with spacings if there is space available,
/// but becomes scrollable with no spacing if the content overflows.
///
/// Parent must have a non-infinite height (that means if this widget
/// is used in another column, flex factor must be given.)
///
/// Copy from https://docs.flutter.dev/cookbook/lists/spaced-items
class ColumnWithSpacings extends StatelessWidget {
  const ColumnWithSpacings({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          // LayoutBuilder must have a flex; otherwise, constraints.maxHeight will be Infinity
          child: Column(
            // Could change from col to Wrap if wanted to add spacing between children
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ),
      );
    });
  }
}
