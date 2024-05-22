import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom.dart';
import 'package:flutter/material.dart';

class SymptomDetail extends StatelessWidget {
  const SymptomDetail({
    super.key,
    required this.symptomEntry,
  });

  final Symptom symptomEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fully collapsing sliver app bar from https://stackoverflow.com/a/65398940
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverOverlapAbsorber(
              handle:
              NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                //floating: true,
                stretch: true,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(symptomEntry.title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displaySmall!.color,  // For some reason, the color doesn't follow the theme (https://stackoverflow.com/questions/66311991/cant-get-sliverappbar-title-color-to-follow-themedata)
                    ),),
                  background: FadeInImage(
                    // by the time this page is launched, the icon will
                    // already in memory, so we will use that.
                    placeholder: symptomEntry.icon,
                    image: symptomEntry.picture,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    fadeInDuration: const Duration(milliseconds: 1),
                    fadeOutDuration: const Duration(milliseconds: 1),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          child: Builder(
              builder:(BuildContext context) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(kLargePadding),
                        child: symptomEntry.content,
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
