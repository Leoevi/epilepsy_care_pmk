import 'package:epilepsy_care_pmk/screens/wiki/wiki.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

import '../constants/styling.dart';
import '../custom_widgets/home_drawer.dart';
import '../models/alarm.dart';
import '../services/notification_service.dart';
import 'add_event/add_select.dart';
import 'add_event/med_intake/add_med_intake_input.dart';
import 'calendar/calendar.dart';
import 'contacts/contact.dart';
import 'home/home.dart';

class MainPage extends StatefulWidget {
  /// Whether or not to display onboarding process. Most of the time, this will
  /// be false, but for the first time after registering, this will be passed in
  /// as true.
  final bool doOnboarding;

  const MainPage({
    super.key,
    this.doOnboarding = false
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return OnboardingIntermediate(doOnboarding: widget.doOnboarding,);
  }
}

/// A class that contains information relating to the onboarding process which
/// will introduce the user to the application the first time after they've
/// registered. Can also be triggered again using an entry in the hamburger
/// menu.
///
/// The reason for using an intermediate is if we instead opted to wrap the
/// whole [MaterialApp] in main instead, during the first registration process
/// when [Navigator.pushReplacement] is called, it will discard the [Onboarding]
/// widget from the widget tree, which cause an error when showing the
/// onboarding process.
class OnboardingIntermediate extends StatefulWidget {
  final bool doOnboarding;

  const OnboardingIntermediate({
    super.key,
    required this.doOnboarding,
  });

  @override
  State<OnboardingIntermediate> createState() => OnboardingIntermediateState();
}

class OnboardingIntermediateState extends State<OnboardingIntermediate> {
  /// [FocusNode] that can be associated with widget of interest that we want to
  /// highlight during the onboarding process. If we didn't associate a node
  /// with any widget, then the overlay will cover the whole screen.
  late final List<FocusNode> focusNodes;
  /// Detail of each onboarding steps.
  late final List<OnboardingStep> steps;

  @override
  void initState() {
    super.initState();
    focusNodes = List<FocusNode>.generate(8, (index) => FocusNode(), growable: false);
    steps = [
      OnboardingStep(
        focusNode: focusNodes[0],
        titleText: "ยินดีต้อนรับ",
        bodyText: "ก่อนเริ่มต้น ขอแนะนำฟังก์ชันพื้นฐานของแอปพลิเคชันเป็นครั้งแรกก่อน แตะเพื่อดูคำแนะนำถัดไป",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[1],
        titleText: "หน้าแรก",
        bodyText: "สามารถดูข้อมูลที่บันทึกล่าสุด และเข้าถึงฟังก์ชันอื่น ๆ เพิ่มเติมได้",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[2],
        titleText: "ปุ่มฟังก์ชันเพิ่มเติม",
        bodyText: "สามารถแก้ไขข้อมูลส่วนตัว ดูสรุปประวัติ และตั้งเวลาแจ้งเตือนทานยาได้",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[3],
        titleText: "ปฏิทิน",
        bodyText: "สามารถดูข้อมูลที่ได้บันทึกเป็นรายวันได้",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[4],
        titleText: "ปุ่มบวก",
        bodyText: "สามารถเพิ่มเหตุการณ์การชัก การแพ้ยา และการทานยาได้",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[5],
        titleText: "ข้อมูล",
        bodyText: "สามารถอ่านข้อมูลที่ควรรู้และยาที่เกี่ยวข้องกับโรคลมชักได้",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[6],
        titleText: "ติดต่อ",
        bodyText: "ช่องทางการติดต่อต่าง ๆ กับทางหน่วยประสาทวิทยา",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
      OnboardingStep(
        focusNode: focusNodes[7],
        titleText: "เสร็จสิ้น",
        bodyText: "สำหรับการรับชมการแนะนำใหม่นี้อีกครั้ง สามารถทำได้จากปุ่มฟังก์ชันเพิ่มเติมในหน้าหลัก",
        hasLabelBox: false,
        fullscreen: true,
        overlayColor: Colors.black.withOpacity(0.8),
        hasArrow: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Onboarding(steps: steps, child: ActualMainPage(focusNodes: focusNodes, steps: steps, doOnboarding: widget.doOnboarding,));
  }
}

class ActualMainPage extends StatefulWidget {
  final List<FocusNode> focusNodes;
  final List<OnboardingStep> steps;
  final bool doOnboarding;

  const ActualMainPage({
    super.key,
    required this.focusNodes,
    required this.steps,
    required this.doOnboarding
  });

  @override
  State<ActualMainPage> createState() => _ActualMainPageState();
}

class _ActualMainPageState extends State<ActualMainPage> {
  int pageIndex = 0;

  late final List<Widget> pages;

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

    pages = [
      Home(focusNodes: widget.focusNodes,),
      const Calendar(),
      const Wiki(),
      const Contact(),
    ];

    listenNotification();

    if (widget.doOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final onboarding = Onboarding.of(context);
        if (onboarding != null) {
          onboarding.show();
        }
      });
    }
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
            initNotification: alarmFromNotification,
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Onboarding.of(context, rootOnboarding: true);
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
                child: Focus(
                  focusNode: widget.focusNodes[1],
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
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Focus(
                  focusNode: widget.focusNodes[3],
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
              ),
              Focus(
                focusNode: widget.focusNodes[4],
                child: Stack(
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
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Focus(
                  focusNode: widget.focusNodes[5],
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
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Focus(
                  focusNode: widget.focusNodes[6],
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
