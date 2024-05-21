import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom.dart';
import 'package:flutter/material.dart';

class SymptomDetail extends StatelessWidget {
  SymptomDetail({
    super.key,
    required this.symptomEntry,
  });

  final Symptom symptomEntry;

  @override
  Widget build(BuildContext context) {
    // Straight from https://api.flutter.dev/flutter/material/SliverAppBar-class.html
    return Scaffold(
      body: CustomScrollView(
        // TODO: scroll the app bar away, even if the content is not long enough
        // https://stackoverflow.com/questions/55346982/sliverappbar-doesnt-fully-collapse-with-short-list
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            // stretch: true,
            onStretchTrigger: () async {
              // Triggers when stretching
            },
            // [stretchTriggerOffset] describes the amount of overscroll that must occur
            // to trigger [onStretchTrigger]
            //
            // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
            // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
            stretchTriggerOffset: 300.0,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(symptomEntry.title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.displaySmall!.color,  // For some reason, the color doesn't follow the theme (https://stackoverflow.com/questions/66311991/cant-get-sliverappbar-title-color-to-follow-themedata)
                ),),
              background: symptomEntry.picture ?? FlutterLogo(),  // TODO: remove the flutter logo
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(kLargePadding),
              child: symptomEntry.content,
            ),
          ),
        ],
      ),
    );
  }
}
