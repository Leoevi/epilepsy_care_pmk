import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:flutter/material.dart';

import '../../constants/styling.dart';

/// A page with the PMK logo on top. This page is divided by flex
/// So you can use [ColumnWithSpacings] as a child of this.
///
/// The [child] is the actual content of the page.
class PageWithHeaderLogo extends StatelessWidget {
  const PageWithHeaderLogo({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kLargePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Image(
                      alignment: Alignment.centerLeft,
                      image: AssetImage("image/header_logo_eng.png"),
                    )),
                Spacer(flex: 3),
                // Spacers are good for spacing with flex, but if you wanted to space with pixel, use sizedBox (like below)
              ],
            ),
          ),
          const SizedBox(height: kLargePadding),
          Expanded(
            flex: 4,
            child: child,
          ),
        ],
      ),
    );
  }
}
