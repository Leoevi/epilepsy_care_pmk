// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Pantira Chinsuwan, Wilawan W.Wilodjananunt, Dittaya Wanvarie
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
import 'package:epilepsy_care_pmk/helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TimeRangeDropdownOption timeRangeDropdownOption =
      TimeRangeDropdownOption.sevenDays;
  late DateTimeRange range;

  String? firstName;
  // String? lastName;
  Image? imageFromPreferences;

  @override
  void initState() {
    loadData();
    super.initState();
    range = timeRangeDropdownOption.dateTimeRange;
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = prefs.getString('firstName') ?? null;
      // lastName = prefs.getString('lastName') ?? null;

      Utility.getImageFromPreferences().then((img) {
        if (null == img) {
          return;
        }
        imageFromPreferences = Utility.imageFromBase64String(img);
    });
      });
      
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kLargePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // flex: 1,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Image(
                      alignment: Alignment.centerLeft,
                      image: AssetImage("image/header_logo_eng.png"),
                    )),
                Expanded(
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
                            backgroundImage: imageFromPreferences?.image,
                          ),
                          SizedBox(
                            width: kSmallPadding,
                          ),
                          //Name
                          Expanded(
                              child: Text(
                            "$firstName",
                            textAlign: TextAlign.justify,
                          )),
                          //Button

                          IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              icon: Icon(Icons.menu))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: kLargePadding),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
            child: Row(children: [
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
          ),
          Flexible(
            flex: 5,
            child: EventList(
              dateTimeRange: range,
            ),
          )
        ],
      ),
    );
  }
}
