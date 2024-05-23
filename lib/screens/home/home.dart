// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Piradee Suwanpakdee, Wilawan W.Wilodjananunt, Dittaya Wanvarie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_list.dart';
import 'package:epilepsy_care_pmk/custom_widgets/time_range_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/user_profile_service.dart';

class Home extends StatefulWidget {
  final List<FocusNode> focusNodes;

  const Home({
    super.key,
    required this.focusNodes
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TimeRangeDropdownOption timeRangeDropdownOption =
      TimeRangeDropdownOption.sevenDays;
  late DateTimeRange range;

  @override
  void initState() {
    super.initState();

    range = timeRangeDropdownOption.dateTimeRange;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(kLargePadding, kLargePadding, kLargePadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Image.asset(
                      "image/header_logo_eng.png",
                      alignment: Alignment.centerLeft,
                    )
                ),
                Consumer<UserProfileService>(
                    builder: (context, model, child) => Expanded(
                      flex: 3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 142, 15, 184), width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(kSmallPadding),
                          child: Row(
                            children: [
                              //Image
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: model.image?.image ?? profilePlaceholder,
                              ),
                              SizedBox(
                                width: kSmallPadding,
                              ),
                              //Name
                              Expanded(
                                  child: Text(
                                    "${model.firstName}",
                                    textAlign: TextAlign.justify,
                                  )),
                              //Button

                              Focus(
                                focusNode: widget.focusNodes[2],
                                child: IconButton(
                                    onPressed: () =>
                                        Scaffold.of(context).openEndDrawer(),
                                    icon: Icon(Icons.menu)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSmallPadding,),
          Row(children: [
            Icon(
              Icons.info_rounded,
              color: Color.fromARGB(255, 0, 195, 0),
            ),
            SizedBox(
              width: kSmallPadding,
            ),
            Expanded(
                child: Text(
              "เหตุการณ์ที่เกิดขึ้น",
              style: mediumLargeBoldText,
            )),
            SizedBox(
              width: kLargePadding,
            ),
            TimeRangeDropdownButton(
              initialChoice: timeRangeDropdownOption,
              onChanged: (selectedRange) {
                setState(() {
                  range = selectedRange;
                });
              },
            )
          ]),
          SizedBox(height: kSmallPadding,),
          Flexible(
            flex: 6,
            child: EventList(
              dateTimeRange: range,
            ),
          )
        ],
      ),
    );
  }
}
