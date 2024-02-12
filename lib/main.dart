import 'package:epilepsy_care_pmk/screens/add_event/add_select.dart';
import 'package:epilepsy_care_pmk/screens/calendar/calendar.dart';
import 'package:epilepsy_care_pmk/screens/contacts/contact.dart';
import 'package:epilepsy_care_pmk/screens/home/home.dart';
import 'package:epilepsy_care_pmk/screens/wiki/wiki.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epilepsy Care',
      // To change the app's name, you need to go into each platform's manifest file (https://stackoverflow.com/questions/49353199/how-can-i-change-the-app-display-name-build-with-flutter)
      theme: ThemeData(
        useMaterial3:
            true, // https://docs.flutter.dev/release/breaking-changes/material-3-default
      ),
      home: const MyHomePage(title: 'Epilepsy Care'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
    padding: const EdgeInsets.all(0),  // To prevent overflow. This is still needed despite with Expanded/Flex
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // To have a gradient background, need to wrap with container
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFFF6C0FF),
            Color(0xFFF69AFF)
          ] // TODO: use colors from theme instead of hardcoding
              )),
      child: Scaffold(
        bottomNavigationBar: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .inversePrimary, // TODO: use colors from theme instead of hardcoding
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
              Stack(  // TODO: Make the button float a bit above the bottom nav bar
                // alignment: AlignmentDirectional.center,
                // clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    // top: addButtonOffset.dy,
                    child: RawMaterialButton(
                      // https://stackoverflow.com/questions/49809351/how-to-create-a-circle-icon-button-in-flutter
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddSelect()));
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
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
