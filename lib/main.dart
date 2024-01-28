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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3:
            true, // https://docs.flutter.dev/release/breaking-changes/material-3-default
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
  ];

  // final addButtonOffset = const Offset(0, -1);
  // Use ElevatedButton.styleFrom instead of ButtonStyle: https://stackoverflow.com/questions/66542199/what-is-materialstatepropertycolor
  final bottomNavButtonStyle = ElevatedButton.styleFrom(  // Without this, the background of the button will not be transparent
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.all(-20),
    // elevation: 0
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              style: bottomNavButtonStyle,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.calendar_month_outlined), Text("ปฎิทิน")],
              ),
            ),
            SizedBox(width: 43, height: 43),
            // Stack(
            //   // alignment: AlignmentDirectional.center,
            //   // clipBehavior: Clip.none,
            //   children: <Widget>[
            //     Positioned(
            //       // top: addButtonOffset.dy,
            //       child: RawMaterialButton(
            //         // https://stackoverflow.com/questions/49809351/how-to-create-a-circle-icon-button-in-flutter
            //         onPressed: () {},
            //         elevation: 2.0,
            //         fillColor: Colors.white,
            //         child: const Icon(
            //           Icons.add,
            //           size: 35.0,
            //         ),
            //         padding: const EdgeInsets.all(15.0),
            //         shape: const CircleBorder(),
            //       ),
            //     )
            //   ],
            // ),
            ElevatedButton(
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
            ElevatedButton(
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
          ],
        ),
      ),
      body: pages[pageIndex],
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
          child: Column(children: <Widget>[
        Text(
          "Page Number 1",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                //get today's date
                firstDate: DateTime(2000),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101));
          },
          child: Text("Date Picker"),
        )
      ])),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 2",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 3",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 4",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
