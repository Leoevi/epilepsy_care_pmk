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
import 'package:epilepsy_care_pmk/custom_widgets/home_drawer.dart';
import 'package:epilepsy_care_pmk/models/med_intake_event.dart';
import 'package:epilepsy_care_pmk/screens/add_event/add_select.dart';
import 'package:epilepsy_care_pmk/screens/add_event/med_intake/add_med_intake_input.dart';
import 'package:epilepsy_care_pmk/screens/calendar/calendar.dart';
import 'package:epilepsy_care_pmk/screens/contacts/contact.dart';
import 'package:epilepsy_care_pmk/screens/home/home.dart';
import 'package:epilepsy_care_pmk/screens/register.dart';
import 'package:epilepsy_care_pmk/screens/wiki/wiki.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:epilepsy_care_pmk/services/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/alarm.dart';

/// A SharedPreference instance for the whole app.
/// Will be init in main before the app opens so that every page
/// that want to access it doesn't have to use async/await.
/// Right now, this method causes cyclic dependency, but it doesn't
/// seem to be a problem for now.
///
/// Inspiration from: https://stackoverflow.com/a/51228189
///
/// If cyclic dep were to became too much of a problem, then it might
/// be worth it to look into dependency injection tools such as GetIt.
late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Prevent errors from awaiting later
  prefs = await SharedPreferences.getInstance();
  NotificationService.initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileService(),
      builder: (context, _) => MaterialApp(
        // To change the app's name, you need to go into each platform's manifest file (https://stackoverflow.com/questions/49353199/how-can-i-change-the-app-display-name-build-with-flutter)
        title: 'Epilepsy Care',
        // https://docs.flutter.dev/cookbook/design/themes
        theme: ThemeData(
          useMaterial3: true,
          // https://docs.flutter.dev/release/breaking-changes/material-3-default
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          // Was going to use textTheme to handle the whole app's font,
          // but it seemed like it will impact other widgets too much, so we'll defined extra ones instead
          // textTheme: TextTheme(
          //   labelSmall: TextStyle(fontWeight: FontWeight.bold,)
          // )
        ),
        home: Consumer<UserProfileService>(
          builder: (context, model, child) => !model.isRegistered ? const Register() : const MyHomePage(),
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  final pages = [
    const Home(),
    const Calendar(),
    const Wiki(),
    const Contact(),
  ];

  // Use ElevatedButton.styleFrom instead of ButtonStyle: https://stackoverflow.com/questions/66542199/what-is-materialstatepropertycolor
  final bottomNavButtonStyle = ElevatedButton.styleFrom(
    // Without this, the background of the button will not be transparent
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.all(
        0), // To prevent overflow. This is still needed despite with Expanded/Flex
  );

  @override
  void initState() {
    super.initState();
    listenNotification();
  }

  void listenNotification() =>
      NotificationService.notificationTriggerStream.listen((payload) {
        onClickedNotification(payload);
      });

  void onClickedNotification(String? payload) {
    if (payload != null) {
      Alarm alarmFromNotification = Alarm.fromSerializedString(payload);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddMedIntakeInput(
                initAlarm: alarmFromNotification,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // To have a gradient background, need to wrap with container
      decoration: baseBackgroundDecoration,
      child: Scaffold(
        endDrawer: SafeArea(child: HomeDrawer()),
        endDrawerEnableOpenDragGesture: false,
        bottomNavigationBar: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  style: bottomNavButtonStyle,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.home_outlined), Text("หน้าแรก")],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  style: bottomNavButtonStyle,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      Text("ปฎิทิน")
                    ],
                  ),
                ),
              ),
              Stack(
                // alignment: AlignmentDirectional.center,
                // clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    // top: addButtonOffset.dy,
                    child: RawMaterialButton(
                      // https://stackoverflow.com/questions/49809351/how-to-create-a-circle-icon-button-in-flutter
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddSelect()));
                      },
                      elevation: 2.0,
                      fillColor: Color(0xffD9ACF5),
                      child: const Icon(
                        Icons.add,
                        size: 35.0,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    ),
                  )
                ],
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  style: bottomNavButtonStyle,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.book_outlined), Text("ข้อมูล")],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pageIndex = 3;
                    });
                  },
                  style: bottomNavButtonStyle,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.headset_outlined), Text("ติดต่อ")],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: pages[pageIndex],
        ),
      ),
    );
  }
}
